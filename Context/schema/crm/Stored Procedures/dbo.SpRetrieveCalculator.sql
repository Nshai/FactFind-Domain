SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveCalculator]
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.CalculatorId AS [Calculator!1!CalculatorId], 
    T1.Identifier AS [Calculator!1!Identifier], 
    ISNULL(T1.Definition, '') AS [Calculator!1!Definition], 
    T1.ConcurrencyId AS [Calculator!1!ConcurrencyId]
  FROM TCalculator T1

  ORDER BY [Calculator!1!CalculatorId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
