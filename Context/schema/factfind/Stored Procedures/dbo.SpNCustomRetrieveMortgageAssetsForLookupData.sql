SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue       Description
----        ---------       -------     -------------
20211207   Nick Fairway     TIM-1275    Performance tune - split statement and simplify WHERE(s) for optimisation
*/
CREATE PROCEDURE [dbo].[SpNCustomRetrieveMortgageAssetsForLookupData]
	@CRMContactId int = 0,
	@CRMContactId2 int = 0
AS      

IF @CRMContactId = 0 OR @CRMContactId2 = 0
BEGIN
	SELECT 
	   A.AssetsId AS [MortgageAssetsId],
	   ISNULL(A.Description,B.CategoryName) AS [Description]
	FROM 
		dbo.TAssets A         
		JOIN dbo.TAssetCategory B ON A.AssetCategoryId = B.AssetCategoryId
	WHERE
		A.CRMContactId IN (@CRMContactId, @CRMContactId2)
		AND A.CRMContactId != 0 -- bad data
		AND B.SectorName IN ('Property', 'Non-Income Producing Real Estate', 'Buy to Let Property') -- no index on B.SectorName (16 rows)
	UNION
	SELECT 
	   A.AssetsId AS [MortgageAssetsId],
	   ISNULL(A.Description,B.CategoryName) AS [Description]
	FROM 
		dbo.TAssets A            
		JOIN dbo.TAssetCategory B ON A.AssetCategoryId = B.AssetCategoryId
	WHERE
		A.CRMContactId2 IN (@CRMContactId, @CRMContactId2)
		AND A.CRMContactId != 0 -- bad data
		AND B.SectorName IN ('Property', 'Non-Income Producing Real Estate', 'Buy to Let Property') -- no index on B.SectorName (16 rows)

	ORDER BY 
		[MortgageAssetsId]    
	FOR XML RAW('MortgageAsset')
END
ELSE
BEGIN
	SELECT 
	   A.AssetsId AS [MortgageAssetsId],
	   ISNULL(A.Description,B.CategoryName) AS [Description]
	FROM 
		dbo.TAssets A           
		JOIN dbo.TAssetCategory B ON A.AssetCategoryId = B.AssetCategoryId
	WHERE 
		(
			(A.CRMContactId = @CRMContactId AND A.CRMContactId2 = @CRMContactId2) 
			OR
			(A.CRMContactId = @CRMContactId2 AND A.CRMContactId2 = @CRMContactId)
		)
		AND A.CRMContactId != 0 -- bad data
		AND B.SectorName IN ('Property', 'Non-Income Producing Real Estate', 'Buy to Let Property') -- no index on B.SectorName (16 rows)
	ORDER BY 
		[MortgageAssetsId]    
	FOR XML RAW('MortgageAsset')
END
GO