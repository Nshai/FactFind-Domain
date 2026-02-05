SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveUserWithName]
	@UserId bigint,
	@TenantId bigint
AS
SELECT
	U.UserId,
	U.Identifier,
	U.SuperUser,
	U.SuperViewer,
	ISNULL(C.FirstName + ' ' + C.LastName, C.CorporateName) AS [Name],
	U.Timezone
FROM 
	TUser U
	JOIN CRM..TCRMContact C ON C.CRMContactId = U.CRMContactId
WHERE 
	U.UserId = @UserId
	AND U.IndigoClientId = @TenantId
GO
