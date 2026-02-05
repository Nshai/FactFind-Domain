SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveValuationXSL]

AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.ValuationXSLId AS [ValuationXSL!1!ValuationXSLId], 
	ISNULL(T1.Description, '') AS [ValuationXSL!1!Description], 
	T1.XSL AS [ValuationXSL!1!XSL], 
	T1.ConcurrencyId AS [ValuationXSL!1!ConcurrencyId]
	FROM TValuationXSL T1
	ORDER BY [ValuationXSL!1!ValuationXSLId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
