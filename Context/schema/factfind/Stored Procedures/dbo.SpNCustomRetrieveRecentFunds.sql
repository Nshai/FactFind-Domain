SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomRetrieveRecentFunds] @UserId bigint

as

SELECT TOP 50
fu.FundUnitId,
fu.UnitLongName,        
fu.ISINCode,        
case         
 when fup.BidPrice = 0 and fup.OfferPrice = 0 then fup.MidPrice        
 else fup.BidPrice        
end as Price,        
convert(varchar(10),fup.PriceDate,103) as PriceDate,
fu.Currency,
fs.FundSectorName as Sector 
FROM fund2..TFund f        
JOIN fund2..TFundUnit fu ON fu.FundId = f.FundId           
JOIN fund2..TFundSector fs ON fs.FundSectorId = f.FundSectorId        
JOIN fund2..TFundUnitPrice fup ON fup.FundUnitId = fu.FundUnitId        
join TFinancialPlanningRecentFund r on r.fundunitid = fu.fundunitid
join administration..TUser u on u.crmcontactid = r.crmcontactid
where	@UserId = UserId
order by DataAdded desc
GO
