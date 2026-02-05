SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnRetrievePlanOwnerListForAuthor](@PolicyBusinessId bigint)
RETURNS varchar(1000)
AS
BEGIN
	DECLARE @PrimaryOwnersList varchar(1000)
	DECLARE @SecondaryOwnersList varchar(1000)
	
	DECLARE @PrimaryOwnerCount int, @AdditionalOwnerCount int, @Delimiter varchar(3)
	
	SET @PrimaryOwnerCount = (
		SELECT COUNT(1) FROM TPolicyOwner po
		JOIN TPolicyBusiness pb on pb.PolicyDetailId = po.PolicyDetailId
		WHERE pb.PolicyBusinessId = @PolicyBusinessId
	)
	
	SET @AdditionalOwnerCount = (
		SELECT COUNT(1) FROM TAdditionalOwner
		WHERE PolicyBusinessId = @PolicyBusinessId
	)
		
	if @PrimaryOwnerCount + @AdditionalOwnerCount > 2 
		set @Delimiter = ', '
	else
		set @Delimiter = ' & '
		
	SELECT	@PrimaryOwnersList = isnull(@PrimaryOwnersList + @Delimiter,'') + IsNull(FirstName, '') + ' ' + IsNull(LastName, '') + isNull(CorporateName, '')
	FROM	PolicyManagement.dbo.TPolicyOwner A
	JOIN Crm.dbo.TCrmContact B On A.CrmContactId = B.CrmContactId
	JOIN TPolicyBusiness pb on pb.PolicyDetailId = a.PolicyDetailId
	WHERE	pb.PolicyBusinessId = @PolicyBusinessId

    SELECT	@SecondaryOwnersList = isnull(@SecondaryOwnersList+', ','') + IsNull(FirstName, '') + ' ' + IsNull(LastName, '') + isNull(CorporateName, '')
	FROM	PolicyManagement.dbo.TAdditionalOwner A
	INNER JOIN Crm.dbo.TCrmContact B On A.CrmContactId = B.CrmContactId
	WHERE	a.PolicyBusinessId = @PolicyBusinessId

    IF (@SecondaryOwnersList != '')
		RETURN (@PrimaryOwnersList + ', ' + @SecondaryOwnersList)
    
	RETURN (@PrimaryOwnersList)
END





GO
