SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION dbo.FnCustomGetPolicyOwnerPartyIds
(
 @PolicyDetailId BIgInt
)
RETURNS Varchar(250)
AS
BEGIN
    DECLARE @OwnerPartyList	varchar(1000)
	
	SELECT	@OwnerPartyList = isnull(@OwnerPartyList+', ','') + Convert(Varchar(25), B.CrmContactId)
	FROM	PolicyManagement.dbo.TPolicyOwner A
	INNER JOIN Crm.dbo.TCrmContact B
		On A.CrmContactId = B.CrmContactId
	WHERE	PolicyDetailId = @PolicyDetailId

	RETURN (@OwnerPartyList)
END
GO
