SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveGroupingByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.GroupingId AS [Grouping!1!GroupingId], 
    T1.Identifier AS [Grouping!1!Identifier], 
    ISNULL(T1.ParentId, '') AS [Grouping!1!ParentId], 
    T1.IsPayable AS [Grouping!1!IsPayable], 
    T1.IndigoClientId AS [Grouping!1!IndigoClientId], 
    T1.ConcurrencyId AS [Grouping!1!ConcurrencyId]
  FROM TGrouping T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [Grouping!1!GroupingId]

  FOR XML EXPLICIT

END
RETURN (0)






GO
