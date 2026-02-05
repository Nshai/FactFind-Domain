SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNCustomRetrieveMortgageAssetsForCRMContact] @CRMContactId bigint  
AS      
      
   SELECT 1 AS TAG,  
   NULL AS Parent,  
   A.AssetsId AS [MortgageAsset!1!MortgageAssetsId],
   ISNULL(A.Description,B.CategoryName) AS [MortgageAsset!1!Description],
   A.ConcurrencyId AS [MortgageAsset!1!ConcurrencyId]
       
FROM TAssets A  
JOIN TAssetCategory B ON A.AssetCategoryId=B.AssetCategoryId
WHERE A.CRMContactId=@CRMContactId  
AND B.CategoryName IN ('Main Residence','Non-Income Producing Real Estate','Rental Property', 'Rental Property/Other Property')
ORDER BY [MortgageAsset!1!MortgageAssetsId]  
  
FOR XML EXPLICIT
GO
