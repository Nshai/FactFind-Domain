SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  dbo.FnCustomFFRetrievePlanOwners(@PolicyDetailId bigint)
RETURNS varchar(1000)
AS
BEGIN
	DECLARE @OwnersList	varchar(1000)
	
	SELECT	@OwnersList = isnull(@OwnersList+', ','') + IsNull(FirstName, '') + ' ' + IsNull(LastName, '') + isNull(CorporateName, '')
	FROM	PolicyManagement.dbo.TPolicyOwner A
	INNER JOIN Crm.dbo.TCrmContact B
		On A.CrmContactId = B.CrmContactId
	WHERE	PolicyDetailId = @PolicyDetailId

	RETURN (@OwnersList)
END



GO
