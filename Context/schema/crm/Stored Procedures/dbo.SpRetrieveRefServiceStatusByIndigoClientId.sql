SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefServiceStatusByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefServiceStatusId AS [RefServiceStatus!1!RefServiceStatusId], 
    T1.ServiceStatusName AS [RefServiceStatus!1!ServiceStatusName], 
    T1.IndigoClientId AS [RefServiceStatus!1!IndigoClientId], 
    T1.ConcurrencyId AS [RefServiceStatus!1!ConcurrencyId]
  FROM TRefServiceStatus T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [RefServiceStatus!1!RefServiceStatusId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
