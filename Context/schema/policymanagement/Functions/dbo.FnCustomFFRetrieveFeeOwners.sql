SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  dbo.FnCustomFFRetrieveFeeOwners(@FeeId bigint)
RETURNS varchar(1000)
AS
BEGIN
	DECLARE @OwnersList	varchar(1000)
	
	SELECT	@OwnersList = isnull(@OwnersList+', ','') + FirstName + ' ' + LastName
	FROM	PolicyManagement.dbo.TFeeRetainerOwner A
	INNER JOIN Crm.dbo.TCrmContact B
		On A.CrmContactId = B.CrmContactId
	WHERE	FeeId = @FeeId

	RETURN (@OwnersList)
END


GO
