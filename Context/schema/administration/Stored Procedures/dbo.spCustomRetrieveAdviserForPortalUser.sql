SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[spCustomRetrieveAdviserForPortalUser]
	@PortalUserId bigint
AS

BEGIN
	SELECT
		1 AS Tag,
		NULL AS Parent,
		
		T1.UserId AS [User!1!UserId], 
		T1.Identifier AS [User!1!Identifier], 
		T1.Status AS [User!1!Status], 
		T1.Email AS [User!1!Email],
		ISNULL(T2.CurrentAdviserName,'') AS [User!1!AdviserName],	
		ISNULL(T1.CRMContactId, '') AS [User!1!CRMContactId], 		


/*	MT - Don't need rest for now but un-comment as required

		T1.Email AS [User!1!Email], 
		ISNULL(T1.Telephone, '') AS [User!1!Telephone], 
		
		T1.GroupId AS [User!1!GroupId], 
		ISNULL(T1.SyncPassword, '') AS [User!1!SyncPassword], 
		ISNULL(CONVERT(varchar(24), T1.ExpirePasswordOn, 120), '') AS [User!1!ExpirePasswordOn], 
		T1.SuperUser AS [User!1!SuperUser], 
		T1.SuperViewer AS [User!1!SuperViewer], 
		T1.FailedAccessAttempts AS [User!1!FailedAccessAttempts], 
		T1.WelcomePage AS [User!1!WelcomePage], 		
		ISNULL(T1.CRMContactId, '') AS [User!1!CRMContactId], 		
		ISNULL(T1.IndigoClientId, '') AS [User!1!IndigoClientId], 
		T1.SupportUserFg AS [User!1!SupportUserFg], 
		ISNULL(T1.ActiveRole, '') AS [User!1!ActiveRole], 
		T1.CanLogCases AS [User!1!CanLogCases], 
		T1.RefUserTypeId AS [User!1!RefUserTypeId], 
*/
		T1.ConcurrencyId AS [User!1!ConcurrencyId]
	
	FROM TUser T3 with (nolock)
	INNER JOIN CRM..TCRMContact T2 with (nolock) ON T2.CRMContactId = T3.CRMContactId
	INNER JOIN TUser T1 with (nolock) ON T2.CurrentAdviserCRMId = T1.CRMContactId
	
	WHERE T3.UserId = @PortalUserId
	ORDER BY [User!1!UserId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
