SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_Tenant_UserAccessSummary]
	@TenantId bigint
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @AccessGranted int = 0, @AccessDenied int = 0, @LastLogin datetime

SELECT 
	@AccessGranted = SUM(CASE WHEN [Status] IN ('Access Granted - Not Logged In', 'Access Granted - Logged In', 'Access Granted - Locked') THEN 1 ELSE 0 END),
	@AccessDenied = SUM(CASE WHEN [Status] = ('Access Denied - Not Logged In') THEN 1 ELSE 0 END)
FROM
	TUser
WHERE
	IndigoClientId = @TenantId
	AND RefUserTypeId = 1

SELECT TOP 1 @LastLogin = L.LogonDateTime
FROM 
	TLogon L WITH(NOLOCK)
	JOIN TUser U WITH(NOLOCK) ON U.UserId = L.Userid 
WHERE 
	U.IndigoClientId = @TenantId
	AND L.[Type]='application'
ORDER BY 
	L.LogonId DESC

SELECT
	ISNULL(@AccessGranted, 0) AS AccessGrantedCount,
	ISNULL(@AccessDenied, 0) AS AccessDeniedCount,
	@LastLogin AS LastLogin
GO
