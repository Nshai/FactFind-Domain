SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveServer]
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ServerId AS [Server!1!ServerId], 
    T1.Identifier AS [Server!1!Identifier], 
    T1.Protocol AS [Server!1!Protocol], 
    T1.IPAddress AS [Server!1!IPAddress], 
    ISNULL(T1.Description, '') AS [Server!1!Description], 
    T1.ConcurrencyId AS [Server!1!ConcurrencyId]
  FROM TServer T1

  ORDER BY [Server!1!ServerId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
