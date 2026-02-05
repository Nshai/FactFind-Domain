SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveAssetCategories]
AS
SELECT
	T1.AssetCategoryId AS [AssetCategoryId], 
	T1.CategoryName AS [CategoryName], 
	T1.SectorName AS [SectorName]
FROM TAssetCategory T1
WHERE IndigoClientId = 0	
ORDER BY [CategoryName]
FOR XML RAW('AssetCategory')

GO
