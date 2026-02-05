SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create procedure [dbo].[spNio_CustomGetFundPrices]

@FundUnitIds varchar(8000) = '',
@EquityIds  varchar(8000) = ''

as

DECLARE @RegionalCurrency VARCHAR(3);
SELECT @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

select distinct
fu.FundUnitId as ID,
convert(bit, 1) as IsFund,
policymanagement.dbo.FnConvertCurrency(fup.BidPrice, fu.Currency, @regionalcurrency) as [BidPrice],  
policymanagement.dbo.FnConvertCurrency(fup.MidPrice, fu.Currency, @regionalcurrency) as [MidPrice],  
policymanagement.dbo.FnConvertCurrency(fup.OfferPrice, fu.Currency, @regionalcurrency) as [OfferPrice],   
PriceDate
from	fund2..TFundUnitPrice fup
JOIN fund2..TfundUnit fu ON fu.FundUnitId = fup.FundUnitId

Where charindex(','+cast(fu.FundUnitId as varchar)+',' , @FundUnitIds)>0


union

select distinct
e.EquityId,
convert(bit, 0) as IsFund,
-- fixed the order of the fields.
isnull(policymanagement.dbo.FnConvertCurrency(ep.Bid, e.Currency, @regionalcurrency), 0) as [BidPrice],  
isnull(policymanagement.dbo.FnConvertCurrency(ep.Mid, e.Currency, @regionalcurrency), 0) as [MidPrice],
isnull(policymanagement.dbo.FnConvertCurrency(ep.Ask, e.Currency, @regionalcurrency), 0) as [AskPrice],  
PriceDate
from	fund2..TEquityPrice ep
JOIN fund2..TEquity e ON e.EquityId = ep.EquityId

Where charindex(','+cast(e.EquityId as varchar)+',' , @EquityIds)>0


GO
