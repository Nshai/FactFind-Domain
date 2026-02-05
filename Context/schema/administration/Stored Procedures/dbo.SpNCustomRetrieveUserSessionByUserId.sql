SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveUserSessionByUserId]
@UserId bigint
AS

SELECT T1.UserSessionId ,
T1.UserId ,
ISNULL(T1.SessionId, '') As SessionId,
ISNULL(T1.DelegateSessionId, '') As DelegateSessionId,
T1.Sequence , 
ISNULL(T1.IP, '') As IP,
ISNULL(CONVERT(varchar(24), T1.LastAccess, 120),'') As LastAcces,
ISNULL(T1.Search, '')  As Search,
ISNULL(T1.Recent, '') As Recent,
ISNULL(T1.RecentWork, '')  As RecentWork,
T1.ConcurrencyId 
FROM TUserSession T1

WHERE (T1.UserId = @UserId)

ORDER BY UserSessionId
GO
