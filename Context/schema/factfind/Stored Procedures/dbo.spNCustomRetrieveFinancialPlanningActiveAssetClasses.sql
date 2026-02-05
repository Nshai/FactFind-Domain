SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveFinancialPlanningActiveAssetClasses] @indigoclientid bigint  
  
as  
  
SELECT      
  distinct d.identifier,e.Identifier as AssetModelType,Custom   
FROM      
 TAtrTemplate A      
inner join  TAtrTemplateCombined B on b.guid = case when a.baseatrtemplate is null then a.guid else a.baseatrtemplate end    
inner join  TAtrPortfolioCombined C on c.AtrTemplateGuid = b.guid    
inner join  TAtrAssetClassCombined d  on  d.AtrPortfolioGuid = C.guid   
inner join  TATRRefPortfolioType e on e.ATRRefPortfolioTypeId = a.ATRRefPortfolioTypeId  
and  c.ATRRefPortfolioTypeId = e.ATRRefPortfolioTypeId
WHERE      
 A.IndigoClientId = @indigoclientid  and a.active = 1 and c.active = 1  
order by d.Identifier 
GO
