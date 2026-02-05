SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveLogonById]
@LogonId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.LogonId AS [Logon!1!LogonId], 
    T1.UserId AS [Logon!1!UserId], 
    CONVERT(varchar(24), T1.LogonDateTime, 120) AS [Logon!1!LogonDateTime], 
    ISNULL(CONVERT(varchar(24), T1.LogoffDateTime, 120),'') AS [Logon!1!LogoffDateTime], 
    T1.Type AS [Logon!1!Type], 
    ISNULL(T1.SourceAddress, '') AS [Logon!1!SourceAddress], 
    T1.ConcurrencyId AS [Logon!1!ConcurrencyId]
  FROM TLogon T1

  WHERE (T1.LogonId = @LogonId)

  ORDER BY [Logon!1!LogonId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
