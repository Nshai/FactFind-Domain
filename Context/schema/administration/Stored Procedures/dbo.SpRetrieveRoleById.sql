SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRoleById]
	@RoleId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.RoleId AS [Role!1!RoleId], 
	T1.Identifier AS [Role!1!Identifier], 
	T1.GroupingId AS [Role!1!GroupingId], 
	T1.SuperUser AS [Role!1!SuperUser], 
	T1.IndigoClientId AS [Role!1!IndigoClientId], 
	T1.LicensedUserCount AS [Role!1!LicensedUserCount], 
	T1.ConcurrencyId AS [Role!1!ConcurrencyId]
	FROM TRole T1
	
	WHERE T1.RoleId = @RoleId
	ORDER BY [Role!1!RoleId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
