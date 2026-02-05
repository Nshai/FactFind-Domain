SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckPlanLinkedToQuoteIllustration]
  @PolicyBusinessId BIGINT,
  @ErrorMessage VARCHAR(512) OUTPUT
AS

BEGIN

--############################################################
--############################################################
--
--	NOTE: This rule only works for new integrations with L&G in mind
--        Not all legacy quote systems use quote results - and hence no document will exist.
--
--############################################################
--############################################################


	DECLARE @QuoteResultId BIGINT = NULL
	SET @QuoteResultId  = (SELECT TOP 1 QuoteResultId FROM TPolicyBusinessExt WHERE PolicyBusinessId = @PolicyBusinessId)

	--This applies to legacy quotes such as mortgages
	DECLARE @QuoteItemId BIGINT
	SELECT @QuoteItemId=QuoteItemId FROM TQuoteItem WHERE PolicyBusinessId=@PolicyBusinessId
	
	DECLARE @Valid int = 0

	IF ISNULL(@QuoteItemId,0)>0
	BEGIN

		DECLARE @EntityTypeQuoteItem INT = 14 -- Enum Value of LinkedDocumentEntityType for QuoteItem
		SET @Valid = 
		(
			SELECT COUNT(1) FROM documentmanagement..TDocument A
			WHERE A.EntityId = @QuoteItemId
			AND A.EntityType = @EntityTypeQuoteItem
		)		
		If @Valid = 0
		BEGIN
			Set @ErrorMessage = 'PLANLINKEDTOQUOTENOILLUSTRATION'
		END

	END
	ELSE IF ISNULL(@QuoteResultId, 0) > 0 -- plan is linked to a quote
	BEGIN	
		
		DECLARE @EntityTypeQuoteResult INT = 20 -- Enum Value of LinkedDocumentEntityType for Quote result
		
		SET @Valid = 
		(
			SELECT COUNT(1) FROM documentmanagement..TDocument A
			WHERE A.EntityId = @QuoteResultId
			AND A.EntityType = @EntityTypeQuoteResult
		)
		
		If @Valid = 0
		BEGIN
			Set @ErrorMessage = 'PLANLINKEDTOQUOTENOILLUSTRATION'
		END
	
	END
	ELSE if ISNULL(@QuoteResultId, 0) = 0 -- mannually added or unlinked from quote
	BEGIN
	
		DECLARE @EntityTypePlan INT = 2 -- Enum Value of LinkedDocumentEntityType for Plan
	
		SET @Valid = 
			(
				SELECT COUNT(1) FROM documentmanagement..TDocument A
				INNER JOIN documentmanagement..TCategory B ON A.CategoryId = B.CategoryId
				WHERE A.EntityId = @PolicyBusinessId
				AND A.EntityType = @EntityTypePlan
				AND B.Identifier = 'Quotes'			-- Document must be "Quotes" category !!!
			)
			
		If @Valid = 0
		BEGIN
			Set @ErrorMessage = 'PLANNOTLINKEDTOQUOTENOILLUSTRATION'
		END
	
	END
	
	
END







GO
