SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--[spCustomRetrieveActiveATRRefAssetClass] 99
create procedure [dbo].[spCustomRetrieveActiveATRRefAssetClass]

@indigoclientid bigint

as

declare @atrRefPortfolioTypeId bigint

select	@atrRefPortfolioTypeId = b.atrrefportfoliotypeid
from factfind..TATRTemplate a
inner join factfind..TATRRefPortfolioType b on b.atrrefportfoliotypeid = a.atrrefportfoliotypeid
where indigoclientid = @IndigoClientId and active = 1


select distinct 
1 AS Tag,
NULL AS Parent,
d.atrrefassetclassid AS [AssetClass!1!id], 
d.identifier AS [AssetClass!1!desc]
from TAtrrefPortfolioType a
inner join dbo.TAtrRefPortfolioTypeAssetClass b on b.AtrRefPortfolioTypeId = a.AtrRefPortfolioTypeId
inner join TAtrRefAssetClass d on d.AtrRefAssetClassId = b.AtrRefAssetClassId
inner join TATRPortfolioCombined c on c.atrrefportfoliotypeid = a.atrrefportfoliotypeid
where atrtemplateguid = (SELECT case when a.BaseAtrTemplate is null then a.guid else a.BaseAtrTemplate end
							FROM  
							 TAtrTemplate A  
							 JOIN TAtrTemplateSetting S ON S.AtrTemplateId = A.AtrTemplateId  
							 JOIN TAtrRefProfilePreference PP ON PP.AtrRefProfilePreferenceId = S.AtrRefProfilePreferenceId  
							 LEFT JOIN TAtrTemplateCombined C ON C.Guid = A.BaseAtrTemplate -- the base template for this template  
							 LEFT JOIN Administration..TIndigoClientCombined I ON I.Guid = C.IndigoClientGuid  
							 LEFT JOIN ( -- to see if the template is in use  
							  SELECT DISTINCT  
							   BaseAtrTemplate  
							  FROM  
							   TAtrTemplateCombined  
							  ) AS InUse ON InUse.BaseAtrTemplate = A.Guid       
							WHERE  
							 A.IndigoClientId = @indigoclientid  and a.active  = 1)
	and a.atrRefPortfolioTypeId = @atrRefPortfolioTypeId

for xml explicit

GO
