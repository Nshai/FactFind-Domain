SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveValGatingById]
	@ValGatingId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.ValGatingId AS [ValGating!1!ValGatingId], 
	T1.RefProdProviderId AS [ValGating!1!RefProdProviderId], 
	T1.RefPlanTypeId AS [ValGating!1!RefPlanTypeId], 
	ISNULL(T1.ProdSubTypeId, '') AS [ValGating!1!ProdSubTypeId], 
	ISNULL(T1.OrigoProductType, '') AS [ValGating!1!OrigoProductType], 
	ISNULL(T1.OrigoProductVersion, '') AS [ValGating!1!OrigoProductVersion], 
	ISNULL(T1.ValuationXSLId, '') AS [ValGating!1!ValuationXSLId], 
	ISNULL(T1.ProviderPlanTypeName, '') AS [ValGating!1!ProviderPlanTypeName], 
	T1.ConcurrencyId AS [ValGating!1!ConcurrencyId]
	FROM TValGating T1
	
	WHERE T1.ValGatingId = @ValGatingId
	ORDER BY [ValGating!1!ValGatingId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
