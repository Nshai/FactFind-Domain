SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefPriorityByIndClientId]
@IndClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefPriorityId AS [RefPriority!1!RefPriorityId], 
    T1.PriorityName AS [RefPriority!1!PriorityName], 
    T1.IndClientId AS [RefPriority!1!IndClientId], 
    T1.ConcurrencyId AS [RefPriority!1!ConcurrencyId]
  FROM TRefPriority T1

  WHERE (T1.IndClientId = @IndClientId)

  ORDER BY [RefPriority!1!RefPriorityId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
