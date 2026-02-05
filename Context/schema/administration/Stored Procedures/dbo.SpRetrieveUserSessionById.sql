SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveUserSessionById]
@UserSessionId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.UserSessionId AS [UserSession!1!UserSessionId], 
    T1.UserId AS [UserSession!1!UserId], 
    ISNULL(T1.SessionId, '') AS [UserSession!1!SessionId], 
    ISNULL(T1.DelegateSessionId, '') AS [UserSession!1!DelegateSessionId], 
    T1.Sequence AS [UserSession!1!Sequence], 
    ISNULL(T1.IP, '') AS [UserSession!1!IP], 
    ISNULL(CONVERT(varchar(24), T1.LastAccess, 120),'') AS [UserSession!1!LastAccess], 
    ISNULL(T1.Search, '') AS [UserSession!1!Search], 
    ISNULL(T1.Recent, '') AS [UserSession!1!Recent], 
    ISNULL(T1.RecentWork, '') AS [UserSession!1!RecentWork], 
    T1.ConcurrencyId AS [UserSession!1!ConcurrencyId]
  FROM TUserSession T1

  WHERE (T1.UserSessionId = @UserSessionId)

  ORDER BY [UserSession!1!UserSessionId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
