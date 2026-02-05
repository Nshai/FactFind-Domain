SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE spNCustomRetrieveAtrRefAssetClassForTenant @tenantId bigint

as

declare @tenantguid uniqueidentifier, @activeTemplate uniqueidentifier, @refportfoliotypeid int

select @tenantguid = guid from administration..TIndigoClient where IndigoClientId = @tenantId

select @activeTemplate = case when baseatrtemplate is not null then baseatrtemplate else guid end from TAtrTemplateCombined where @tenantguid = IndigoClientGuid and Active = 1
select @refportfoliotypeid = AtrRefPortfolioTypeId  from TAtrTemplateCombined where @tenantguid = IndigoClientGuid and Active = 1

--select @tenantguid,@activeTemplate

select 
distinct
a.AtrRefAssetClassId,
a.Identifier,
a.ShortName,
a.Ordering,
a.ConcurrencyId
from TAtrRefAssetClass a
inner join TAtrAssetClassCombined b on b.AtrRefAssetClassId = a.AtrRefAssetClassId
inner join TAtrPortfolioCombined c on c.guid = b.AtrPortfolioGuid
where c.AtrTemplateGuid = @activeTemplate and @refportfoliotypeid = AtrRefPortfolioTypeId

