SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnRetrievePlanOwnerList](@PolicyDetailId bigint, @PolicyBusinessId bigint)
RETURNS varchar(1000)
AS
BEGIN
	DECLARE @PrimaryOwnersList varchar(1000)
	DECLARE @SecondaryOwnersList varchar(1000)
	
	SELECT	@PrimaryOwnersList = isnull(@PrimaryOwnersList+', ','') + IsNull(FirstName, '') + ' ' + IsNull(LastName, '') + isNull(CorporateName, '')
	FROM	PolicyManagement.dbo.TPolicyOwner A
	INNER JOIN Crm.dbo.TCrmContact B
		On A.CrmContactId = B.CrmContactId
	WHERE	PolicyDetailId = @PolicyDetailId

    SELECT	@SecondaryOwnersList = isnull(@SecondaryOwnersList+', ','') + IsNull(FirstName, '') + ' ' + IsNull(LastName, '') + isNull(CorporateName, '')
	FROM	PolicyManagement.dbo.TAdditionalOwner A
	INNER JOIN Crm.dbo.TCrmContact B
		On A.CrmContactId = B.CrmContactId
	WHERE	PolicyBusinessId = @PolicyBusinessId

    IF (@SecondaryOwnersList != '')
		RETURN (@PrimaryOwnersList + ',' + @SecondaryOwnersList)
    
	RETURN (@PrimaryOwnersList)
END



GO
