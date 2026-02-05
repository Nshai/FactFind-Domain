SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckFactFindPredatesIllustration]
  @PolicyBusinessId BIGINT,
  @ErrorMessage VARCHAR(512) OUTPUT
AS

BEGIN

--############################################################
--############################################################
--
--	NOTE: This rule captures the results of 4 other existing rules.
--        Complexity is high as a result.
-- Step 1: Check that there is a joint Fact Find if it is a joint plan or a single fact find for a single plan		
-- Step 2: Obtain Illustration Document of plan (could be manaully added or from a Quote Result)
-- Step 3: Check that an open Service Case is linked to the plan
-- Step 4: Check that a binder is linked to the Service Case
-- Step 5: Check that the Binder contains a Final Fact Find Document
--
-- Step 6: Check that the Fact Find Document Predates the Plan's Quote Illustration Document !
--
--############################################################
--############################################################

Set @ErrorMessage = '' -- not null
DECLARE @QuoteIllustrationDate DATETIME = NULL
DECLARE @FinalFactFindDocumentDate DATETIME = NULL

--############################################################
-- Step 1:  Check that a fact find exists and that it is join if the plan is joint
--
--############################################################

	DECLARE @FactFinds TABLE (FactFindId bigint)
	DECLARE @PlanOwner1Id bigint
	DECLARE @PlanOwner2Id bigint
	DECLARE @PrimaryFactFindOwners TABLE (CRMContactId bigint)
		
	SET @PlanOwner1Id=(SELECT TOP 1 CRMContactId FROM TPolicyOwner A JOIN TPolicyBusiness B ON A.PolicyDetailId=B.PolicyDetailId
					WHERE B.PolicyBusinessId=@PolicyBusinessId ORDER BY A.PolicyOwnerId)

	SET @PlanOwner2Id=(SELECT TOP 1 CRMContactId FROM TPolicyOwner A JOIN TPolicyBusiness B ON A.PolicyDetailId=B.PolicyDetailId	
					WHERE B.PolicyBusinessId=@PolicyBusinessId AND A.CRMContactId!=@PlanOwner1Id ORDER BY A.PolicyOwnerId DESC)


	-- Get fact finds, there might be more than 1 (if the plan owner is the partner on two FFs)
	INSERT INTO @FactFinds
	SELECT FactFindId 
	FROM FactFind..TFactFind 
	WHERE 
		(CRMContactId1=@PlanOwner1Id OR CRMContactId2=@PlanOwner1Id)
		AND (ISNULL(@PlanOwner2Id,0)=0 
			OR ((CRMContactId1=@PlanOwner2Id AND CRMContactId2=@PlanOwner1Id) 
			OR (CRMContactId2=@PlanOwner2Id AND CRMContactId1=@PlanOwner1Id))
		)


	IF NOT EXISTS (SELECT 1 FROM @FactFinds)
	BEGIN
		IF ISNULL(@PlanOwner2Id,0)>0
		BEGIN
			Set @ErrorMessage = '+NOJOINTFACTFIND'
		END
		ELSE
		BEGIN
			Set @ErrorMessage = '+NOSINGLEFACTFIND'
		END		
	END

	-- Get primary owners for FactFinds
	INSERT INTO @PrimaryFactFindOwners
	SELECT CRMContactId1 FROM FactFind..TFactFind 
	WHERE FactFindId IN (SELECT FactFindId FROM @FactFinds)


--############################################################
-- Step 2:  Obtain Illustration Document of plan (could be manaully added or from a Quote Result)
-- From sp: spCustomTransitionRule_CheckPlanLinkedToQuoteIllustration
--############################################################

	DECLARE @QuoteIllustrationDocVesionId BIGINT = NULL
	
	DECLARE @QuoteDocumentId BIGINT = NULL
	DECLARE @EntityTypeQuoteResult INT = 20 -- Enum Value of LinkedDocumentEntityType for Quote result
	DECLARE @EntityTypeQuoteItem INT = 14 -- Enum Value of LinkedDocumentEntityType for Quote item - legacy morgages etc
	



	DECLARE @QuoteResultId BIGINT = NULL
	SET @QuoteResultId  = (SELECT TOP 1 QuoteResultId FROM TPolicyBusinessExt WHERE PolicyBusinessId = @PolicyBusinessId)
	
	DECLARE @QuoteItemId BIGINT = NULL
	SET @QuoteItemId  = (SELECT TOP 1 QuoteItemId FROM TQuoteItem WHERE PolicyBusinessId = @PolicyBusinessId)
	
	
	DECLARE @Valid int = 0

	IF ISNULL(@QuoteResultId, 0) > 0 -- plan is linked to a quote Result
	BEGIN		
		
		SELECT TOP 1 
			@QuoteIllustrationDocVesionId = B.DocVersionId,
			@QuoteIllustrationDate = B.CreatedDate		
		FROM documentmanagement..TDocument A
		INNER JOIN documentmanagement..TDocVersion B ON A.DocumentId = B.DocumentId
		WHERE A.EntityId = @QuoteResultId
		AND A.EntityType = @EntityTypeQuoteResult
		ORDER BY DocVersionId DESC
		
	
	END
	IF ISNULL(@QuoteItemId, 0) > 0 -- plan is linked to a quote Item
	BEGIN
		
		SELECT TOP 1 
			@QuoteIllustrationDocVesionId = B.DocVersionId,
			@QuoteIllustrationDate = B.CreatedDate		
		FROM documentmanagement..TDocument A
		INNER JOIN documentmanagement..TDocVersion B ON A.DocumentId = B.DocumentId
		WHERE A.EntityId = @QuoteItemId
		AND A.EntityType = @EntityTypeQuoteItem
		ORDER BY DocVersionId DESC
	
	END
	ELSE IF ISNULL(@QuoteResultId, 0) = 0 AND  ISNULL(@QuoteItemId, 0) = 0 -- mannually added or unlinked from quote
	BEGIN
	
		DECLARE @EntityTypePlan INT = 2 -- Enum Value of LinkedDocumentEntityType for Plan
	
		SET @QuoteIllustrationDocVesionId = 
		(
			SELECT MAX(B.DocVersionId) FROM documentmanagement..TDocument A
			INNER JOIN documentmanagement..TDocVersion B ON A.DocumentId = B.DocumentId
			INNER JOIN documentmanagement..TCategory C ON A.CategoryId = C.CategoryId
			WHERE A.EntityId = @PolicyBusinessId
			AND A.EntityType = @EntityTypePlan
			AND C.Identifier = 'Quotes'			-- Document must be "Quotes" category !!!
		)				
	
	END 
	
	If ISNULL(@QuoteIllustrationDocVesionId, 0) = 0
	BEGIN
		Set @ErrorMessage = '+NOILLUSTRATION'
	END

	IF (@QuoteIllustrationDate IS NULL AND ISNULL(@QuoteIllustrationDocVesionId, 0) != 0)
	BEGIN
		SELECT @QuoteIllustrationDate=CreatedDate FROM documentmanagement..TDocVersion WHERE DocVersionId=@QuoteIllustrationDocVesionId
	END
	
	
--############################################################
-- Step 3: Check that an open Service Case is linked to the plan
-- From sp: spCustomTransitionRule_AdviceCase
--############################################################
	
	DECLARE @LatestOpenServiceCaseIdLinkedToPlan BIGINT = NULL
	
	SET @LatestOpenServiceCaseIdLinkedToPlan = 
	(	
		SELECT MAX(A.AdviceCaseId) FROM CRM..TAdviceCasePlan A
		INNER JOIN 
		(
			--THis gets the latest status - do not check the autoclsoe here as it might mean picking a status that is not the latest.
			SELECT MAX(AdviceCaseHistoryId) AS AdviceCaseHistoryId, A.AdviceCaseId 
			FROM CRM..TAdviceCaseHistory A
			INNER JOIN CRM..TAdviceCasePlan C ON A.AdviceCaseId = C.AdviceCaseId
			WHERE C.PolicyBusinessId = @PolicyBusinessId
			GROUP BY A.AdviceCaseId 
			
		) B ON A.AdviceCaseId = B.AdviceCaseId
		INNER JOIN CRM..TAdviceCaseHistory C ON B.AdviceCaseHistoryId = C.AdviceCaseHistoryId -- join on latest status primary key
		INNER JOIN CRM..TAdviceCaseStatus D ON C.StatusId = D.AdviceCaseStatusId -- Check the status details
		WHERE PolicyBusinessId = @PolicyBusinessId
		AND D.IsAutoClose = 0 -- must not be autoclosed.
	)
	
	
	IF ISNULL(@LatestOpenServiceCaseIdLinkedToPlan, 0) = 0
	BEGIN
		SELECT @ErrorMessage = @ErrorMessage + '+NOSERVICECASE'  
	END
	
	
--############################################################
-- Step 4: Check that a binder is linked to the Service Case
-- From sp: not really - this is because the existing rule checks any binders and includes statuses 
--############################################################	
	
	
	DECLARE @BinderLinkedToServiceCaseId BIGINT = NULL
	
	SET @BinderLinkedToServiceCaseId = 
	(
		SELECT BinderId FROM CRM..TAdviceCase where AdviceCaseId = @LatestOpenServiceCaseIdLinkedToPlan	
	)
	
	IF ISNULL(@BinderLinkedToServiceCaseId, 0) = 0
	BEGIN
		SELECT @ErrorMessage = @ErrorMessage + '+NOBINDER'  
	END
	
	
	
--############################################################
-- Step 5: Check that the Binder contains a Final Fact Find Document
-- From sp: spCustomTransitionRule_CheckServiceCaseFinalDocument
--############################################################	
	
	
	DECLARE @FinalFactFindDocVersionId BIGINT = NULL
	
	SELECT TOP 1
		@FinalFactFindDocVersionId = DV.DocVersionId,
		@FinalFactFindDocumentDate = FFD.CreatedDate	
	FROM 
		documentmanagement..TBinderDocument BD 
		JOIN DocumentManagement..TDocVersion DV ON DV.DocVersionID=BD.DocVersionID
		JOIN factfind..TFactFindDocument FFD ON DV.DocVersionId = FFD.DocVersionId -- ensures it's a FF Doc
	WHERE 
		BD.BinderId = @BinderLinkedToServiceCaseId 
		AND DV.Status='Final' 
		AND FFD.CrmContactId IN (SELECT CRMContactId FROM @PrimaryFactFindOwners)
	Order BY FFD.CreatedDate DESC -- This ensures the current FINAL FF doc.
		

	IF ISNULL(@FinalFactFindDocVersionId, 0) = 0
	BEGIN
		SELECT @ErrorMessage = @ErrorMessage + '+NOFINALFACTFINDDOCUMENT'  
	END
		

--############################################################
-- Step 6: Check that the Fact Find Document Predates the Plan's Quote Illustration Document !
--############################################################	
		

	IF @QuoteIllustrationDate < @FinalFactFindDocumentDate
	BEGIN
		SELECT @ErrorMessage = @ErrorMessage + '+ILLUSTRATIONPEDATESFINALFACTFINDDOCUMENT'  
	END
	
	--Add Data for side bar link generator
	IF(LEN(ISNULL(@ErrorMessage, '')) > 0)
	BEGIN		
		SET @ErrorMessage = @ErrorMessage 
							+ '_&LatestOpenServiceCaseIdLinkedToPlan=' + CONVERT(varchar(50), ISNULL(@LatestOpenServiceCaseIdLinkedToPlan,''))
							+ '&BinderLinkedToServiceCaseId=' + CONVERT(varchar(50), ISNULL(@BinderLinkedToServiceCaseId,''))
										 

	END	

	
	
	
END

GO
