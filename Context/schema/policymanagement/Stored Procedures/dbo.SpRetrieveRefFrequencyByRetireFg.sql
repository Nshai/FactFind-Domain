SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefFrequencyByRetireFg]
@RetireFg tinyint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefFrequencyId AS [RefFrequency!1!RefFrequencyId], 
    ISNULL(T1.FrequencyName, '') AS [RefFrequency!1!FrequencyName], 
    ISNULL(T1.OrigoRef, '') AS [RefFrequency!1!OrigoRef], 
    ISNULL(T1.RetireFg, '') AS [RefFrequency!1!RetireFg], 
    ISNULL(T1.OrderNo, '') AS [RefFrequency!1!OrderNo], 
    T1.ConcurrencyId AS [RefFrequency!1!ConcurrencyId]
  FROM TRefFrequency T1

  WHERE (T1.RetireFg = @RetireFg)

  ORDER BY [RefFrequency!1!RefFrequencyId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
