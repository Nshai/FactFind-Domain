SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveAssetCategoryById]
	@AssetCategoryId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.AssetCategoryId AS [AssetCategory!1!AssetCategoryId], 
	T1.CategoryName AS [AssetCategory!1!CategoryName], 
	T1.SectorName AS [AssetCategory!1!SectorName], 
	ISNULL(T1.IndigoClientId, '') AS [AssetCategory!1!IndigoClientId], 
	T1.ConcurrencyId AS [AssetCategory!1!ConcurrencyId]
	FROM TAssetCategory T1
	
	WHERE T1.AssetCategoryId = @AssetCategoryId
	ORDER BY [AssetCategory!1!AssetCategoryId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
