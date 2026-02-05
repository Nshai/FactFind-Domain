SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveValResponseByValRequestId]
@ValRequestId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ValResponseId AS [ValResponse!1!ValResponseId], 
    T1.ValRequestId AS [ValResponse!1!ValRequestId], 
    ISNULL(T1.ResponseXML, '') AS [ValResponse!1!ResponseXML], 
    ISNULL(CONVERT(varchar(24), T1.ResponseDate, 120),'') AS [ValResponse!1!ResponseDate], 
    ISNULL(T1.ResponseStatus, '') AS [ValResponse!1!ResponseStatus], 
    ISNULL(T1.ErrorDescription, '') AS [ValResponse!1!ErrorDescription], 
    ISNULL(T1.IsAnalysed, '') AS [ValResponse!1!IsAnalysed], 
    T1.ConcurrencyId AS [ValResponse!1!ConcurrencyId]
  FROM TValResponse T1

  WHERE (T1.ValRequestId = @ValRequestId)

  ORDER BY [ValResponse!1!ValResponseId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
