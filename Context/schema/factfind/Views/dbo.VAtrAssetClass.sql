SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VAtrAssetClass]  
  
AS  
  
SELECT  
 A.Guid,  
 A.AtrAssetClassId,  
 A.Identifier,  
 A.Allocation,  
 A.Ordering,  
 A.AtrRefAssetClassId,  
 A.AtrPortfolioGuid,  
 A.ConcurrencyId    
FROM  
 dbo.TAtrAssetClassCombined A  
 --left JOIN dbo.TAtrAssetClass B ON A.Guid=B.Guid  
GO
