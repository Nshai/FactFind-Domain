SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomTransitionRule_AXA_CheckDocuments]
  @PolicyBusinessId bigint,
  @ResponseCode varchar(512) output
AS

Declare @Owner1CrmContactId Bigint
Declare @Owner2CrmContactId Bigint
Declare @IsJointPlan bit
Declare @SubCode varchar(255)= ''

Declare @Owner1RuleFailed bit = 0, @Owner2RuleFailed bit = 0

DECLARE @PlanOwners TABLE
(
  CrmContactId bigint,
  PolicyDetailId bigint,
  PolicyBusinessId bigint,
  OwnershipOrder int
)

SET @IsJointPlan = 0


INSERT INTO @PlanOwners (CrmContactId, PolicyDetailId, PolicyBusinessId,OwnershipOrder)
SELECT   PO.CRMContactId, PO.PolicyDetailId, PB.PolicyBusinessId, ROW_NUMBER() OVER(ORDER BY PO.PolicyOwnerId ) AS OwnershipOrder
FROM PolicyManagement..TPolicyBusiness PB with (nolock)
	INNER JOIN PolicyManagement..TPolicyOwner PO with (nolock) ON PB.PolicyDetailId = PO.PolicyDetailId
where PolicyBusinessId = @PolicyBusinessId

	
SELECT @Owner1CrmContactId =CrmContactId from  @PlanOwners WHERE OwnershipOrder = 1
SELECT @Owner2CrmContactId =CrmContactId from  @PlanOwners WHERE OwnershipOrder = 2

DECLARE @Owner1LatestBinderId BIGINT -- Id of the latest binder that belongs to Plan Owner 1 (as the Owner1 or Owner2 of the binder)
DECLARE @Owner2LatestBinderId BIGINT -- Id of the latest binder that belongs to Plan Owner 2 (as the Owner1 or Owner2 of the binder)
		
SELECT @Owner1LatestBinderId = max(A.BinderId)
FROM
(
	Select MAX(BinderId) AS BinderId From documentmanagement..TBinder with (nolock) Where CRMContactId = @Owner1CrmContactId
	UNION ALL
	Select MAX(BinderId) AS BinderId From documentmanagement..TBinder with (nolock) Where Owner2PartyId = @Owner1CrmContactId
) A


IF(@Owner1LatestBinderId > 0) -- This checks if the Owner has any binders at all
	BEGIN		
	
		if
		(	
			Select COUNT(1) from documentmanagement..TBinderDocument A with (nolock)
			Inner join documentmanagement..TDocVersion B with (nolock) ON A.DocVersionId = B.DocVersionId
			Where A.BinderId = @Owner1LatestBinderId
			AND B.OriginalFileName Like 'Fact Find%'
		) = 0
		Begin
			Select @SubCode = @SubCode + 'FF1-'
			select @Owner1RuleFailed = 1
		End		
		
		if
		(	
			Select COUNT(1) from documentmanagement..TBinderDocument A with (nolock)
			Inner join documentmanagement..TDocVersion B with (nolock) ON A.DocVersionId = B.DocVersionId
			Where A.BinderId = @Owner1LatestBinderId
			AND  B.OriginalFileName Like 'CIDQUOTE%'
		) = 0
		Begin
			Select @SubCode = @SubCode + 'CID1-'
			select @Owner1RuleFailed = 1
		End
		
		if
		(	
			Select COUNT(1) from documentmanagement..TBinderDocument A with (nolock)
			Inner join documentmanagement..TDocVersion B with (nolock) ON A.DocVersionId = B.DocVersionId
			Where A.BinderId = @Owner1LatestBinderId
			AND  B.OriginalFileName Like 'Suitability Report%'
		) = 0
		Begin
			Select @SubCode = @SubCode + 'SR1-'
			select @Owner1RuleFailed = 1
		End	
	
	END
ELSE
	BEGIN
		Select @SubCode = @SubCode + 'FF1-CID1-SR1-' -- Owner1 does not have any binders at all
		select @Owner1RuleFailed = 1
	END


IF(@Owner2CrmContactId IS NOT NULL)
BEGIN
	
	SELECT @Owner2LatestBinderId = max(A.BinderId)
	FROM
	(
		Select MAX(BinderId) AS BinderId From documentmanagement..TBinder with (nolock) Where CRMContactId = @Owner2CrmContactId
		UNION ALL
		Select MAX(BinderId) AS BinderId From documentmanagement..TBinder with (nolock) Where Owner2PartyId = @Owner2CrmContactId
	) A	
	
	
	IF(@Owner2LatestBinderId > 0) -- This checks if the Owner has any binders at all
		BEGIN
		
			if
			(	
				Select COUNT(1) from documentmanagement..TBinderDocument A with (nolock)
				Inner join documentmanagement..TDocVersion B with (nolock) ON A.DocVersionId = B.DocVersionId
				Where A.BinderId = @Owner2LatestBinderId
				AND B.OriginalFileName Like 'Fact Find%'
			) = 0
			Begin
				Select @SubCode = @SubCode + 'FF2-'
				select @Owner2RuleFailed = 1
			End

			if
			(	
				Select COUNT(1) from documentmanagement..TBinderDocument A with (nolock)
				Inner join documentmanagement..TDocVersion B with (nolock) ON A.DocVersionId = B.DocVersionId
				Where A.BinderId = @Owner2LatestBinderId
				AND  B.OriginalFileName Like 'CIDQUOTE%'
			) = 0
			Begin
				Select @SubCode = @SubCode + 'CID2-'
				select @Owner2RuleFailed = 1
			End
			
			if
			(	
				Select COUNT(1) from documentmanagement..TBinderDocument A with (nolock)
				Inner join documentmanagement..TDocVersion B with (nolock) ON A.DocVersionId = B.DocVersionId
				Where A.BinderId = @Owner2LatestBinderId
				AND  B.OriginalFileName Like 'Suitability Report%'
			) = 0
			Begin
				Select @SubCode = @SubCode + 'SR2-'
				select @Owner2RuleFailed = 1
			End	
		
		END
	ELSE
		BEGIN
			Select @SubCode = @SubCode + 'FF2-CID2-SR2-' -- Owner2 does not have any binders at all
			select @Owner2RuleFailed = 1
		END

END


 If(@SubCode != '')
 Begin    
	
	Select @ResponseCode = @SubCode + '_'
	
	IF(@Owner1RuleFailed = 1)
	BEGIN

		Select @ResponseCode = @ResponseCode + '&Owner1Id=' + CONVERT(varchar(255), ISNULL(@Owner1CrmContactId, ''))
									+ '&Owner1BinderId=' + CONVERT(varchar(255), ISNULL(@Owner1LatestBinderId, ''))
	END
	
	IF(@Owner2RuleFailed = 1)
	BEGIN

		Select @ResponseCode = @ResponseCode + '&Owner2Id=' + CONVERT(varchar(255), ISNULL(@Owner2CrmContactId, ''))
									+ '&Owner2BinderId=' + CONVERT(varchar(255), ISNULL(@Owner2LatestBinderId, ''))
	END								
									
 End


GO
