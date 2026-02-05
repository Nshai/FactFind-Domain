SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure dbo.SpCustomUpdateHoldingToZero
    @policybusinessfundid int, @StampUserId bigint
as

set nocount on
set xact_abort on
set transaction isolation level read uncommitted

	declare @Equity tinyint = 1, @Fund tinyint = 0, @HoldingType tinyint

	declare @StampDateTime datetime2 = getdate()

	declare @UnitPrice money, @UnitPriceDate datetime2, @SumUnitQuantity money, @fundId int

	declare @Purchase_RefFundTransactionTypeId int , @Sale_RefFundTransactionTypeId int
	declare @Purchase varchar(10) = 'Purchase'
	declare @Sale varchar(10) = 'Sale'
	declare @TenantId int
	declare @PolicyBusinessId int
	declare @FundCurrency VARCHAR(3)
	declare @PlanCurrency VARCHAR(3)
	declare @RegionalCurrency VARCHAR(3)

	if exists(select 1 from TPolicyBusinessFund where CurrentUnitQuantity = 0 and PolicyBusinessFundId = @PolicyBusinessFundId ) 
	return

	Select @SumUnitQuantity = IsNull(sum(UnitQuantity),0) from TPolicyBusinessFundTransaction Where PolicyBusinessFundId = @PolicyBusinessFundId
	if coalesce(@SumUnitQuantity,0) = 0 
		return

	select @Purchase_RefFundTransactionTypeId = RefFundTransactionTypeId from TRefFundTransactionType WITH (nolock) where Description = @Purchase
	select @Sale_RefFundTransactionTypeId = RefFundTransactionTypeId from TRefFundTransactionType WITH (nolock) where Description = @Sale
	select @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

	declare @FromFeedFg tinyint

	select 
		 @FromFeedFg = FromFeedFg
		,@HoldingType = EquityFg
		,@fundId = FundId
		,@TenantId = b.IndigoClientId
		,@PolicyBusinessId = b.PolicyBusinessId 
		,@PlanCurrency = b.BaseCurrency
	from 
		TPolicyBusinessFund f
		JOIN TPolicyBusiness b
			ON b.PolicyBusinessId = f.PolicyBusinessId
	where PolicyBusinessFundId = @PolicyBusinessFundId

	if @FromFeedFg = 1
	begin
		if @HoldingType = @Fund  --Read from TFundUnit
		begin
			select @UnitPrice = case
									when isnull(fup.MidPrice,0) > 0 then fup.MidPrice
									when isnull(fup.BidPrice,0) > 0 then fup.BidPrice
									else fup.OfferPrice
								end
				   ,@UnitPriceDate = fup.PriceDate
				   ,@FundCurrency = fu.Currency
			from tpolicybusinessfund tpbf
			Join fund2..TFundUnit fu on fu.FundUnitId = tpbf.fundId and tpbf.FromFeedFg = 1 and tpbf.EquityFg = 0
			Join fund2..TFundUnitPrice fup on fup.FundUnitId = fu.FundUnitId
			left join Administration..TCurrencyRate cr  on cr.CurrencyCode = fu.currency And cr.indigoclientid = 0
			where tpbf.PolicyBusinessFundId = @policybusinessfundid
		end
		else if @HoldingType = @Equity   --Read from TEquity
		begin
		/*the order bid then mid (omission of offer) is to be consistent with a legacy code in the fund price update job - This got to be separately revisited as there could be other places as well - KK*/
			select @UnitPrice = case
									when isnull(ep.Bid,0) > 0 then ep.Bid
									else ep.Mid
								end
								,@UnitPriceDate = ep.PriceDate
								,@FundCurrency = e.Currency
			from TPolicyBusinessFund tpbf
				Join fund2..TEquity e on e.EquityId = tpbf.fundId and tpbf.FromFeedFg = 1 and tpbf.EquityFg = 1
				Join fund2..TEquityPrice ep on ep.EquityId = e.EquityId
				left join administration..tcurrencyrate cr on cr.currencycode = e.currency and cr.indigoclientid = 0
			where tpbf.PolicyBusinessFundId = @policybusinessfundid
		end
	end
	else --Read from TNonFeedFund
	begin
		-- NFF Prices are in regional currency
		SET @FundCurrency = @RegionalCurrency
		select @UnitPrice = CurrentPrice
		from TNonFeedFund 
		where NonFeedFundId = @fundId
	end

	-- convert price to plan currency
	IF @FundCurrency <> @PlanCurrency
		SET @UnitPrice = policymanagement.dbo.FnConvertCurrency(@UnitPrice,@FundCurrency, @PlanCurrency)

	if (coalesce(@UnitPrice,0) = 0)
	begin
		select top 1 @UnitPrice = UnitPrice 
		from TPolicyBusinessFundTransaction 
		where 
			PolicyBusinessFundId =  @policybusinessfundid 
		and TenantId = @TenantId
		order by TransactionDate desc
	end

    if (coalesce(@UnitPriceDate,'') = '')
    begin
        select @UnitPriceDate = max(LastPriceChangeDate) from TPolicyBusinessFund
        where PolicyBusinessId in (select top 1 PolicyBusinessId from TPolicyBusinessFund where PolicyBusinessFundId = @policybusinessfundid)
    end

	begin tran

		update tpolicybusinessfund set currentUnitQuantity = 0,  Cost = 0, LastUnitChangeDate = @UnitPriceDate,
				CurrentPrice = @UnitPrice, LastPriceChangeDate = @UnitPriceDate, ConcurrencyId = ConcurrencyId + 1
			output deleted.PolicyBusinessId, deleted.FundId, deleted.FundTypeId, deleted.FundName, deleted.CategoryId, deleted.CategoryName, 
				deleted.CurrentUnitQuantity, deleted.LastUnitChangeDate, deleted.CurrentPrice, deleted.LastPriceChangeDate, deleted.PriceUpdatedByUser, 
				deleted.FromFeedFg, deleted.FundIndigoClientId, deleted.InvestmentTypeId, deleted.RiskRating, deleted.EquityFg, deleted.ConcurrencyId, 
				deleted.PolicyBusinessFundId, 'U', @StampDateTime, @StampUserId, deleted.Cost, deleted.LastTransactionChangeDate, deleted.RegularContributionPercentage, 
				deleted.UpdatedByReplicatedProc, deleted.PortfolioName, deleted.ModelPortfolioName, deleted.DFMName, deleted.MigrationReference
			into tpolicybusinessfundAudit
				(PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, 
				CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice, LastPriceChangeDate, PriceUpdatedByUser, 
				FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, ConcurrencyId, 
				PolicyBusinessFundId, StampAction, StampDateTime, StampUser, Cost, LastTransactionChangeDate, RegularContributionPercentage, 
				UpdatedByReplicatedProc, PortfolioName, ModelPortfolioName, DFMName, MigrationReference)
		where policybusinessfundid =  @policybusinessfundid

		if @SumUnitQuantity <> 0
		begin 
			insert into TPolicyBusinessFundTransaction
				(PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, Gross, Cost, UnitPrice, UnitQuantity, ConcurrencyId, IsFromTransactionHistory,
				 TenantId, PolicyBusinessId, Category1Text, CreatedByUserId, UpdatedByUserId)
				output
					inserted.PolicyBusinessFundId, inserted.TransactionDate, inserted.RefFundTransactionTypeId, inserted.Gross, inserted.Cost, inserted.UnitPrice, inserted.UnitQuantity, 
					inserted.ConcurrencyId, inserted.PolicyBusinessFundTransactionId, 'C', @StampDateTime, @StampUserId, inserted.IsFromTransactionHistory
				into [TPolicyBusinessFundTransactionAudit]
					(PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, Gross, Cost, UnitPrice, UnitQuantity, ConcurrencyId, PolicyBusinessFundTransactionId, StampAction, StampDateTime, StampUser, IsFromTransactionHistory)
			values (@PolicyBusinessFundId, @UnitPriceDate,
					case when @SumUnitQuantity > 0 then @Sale_RefFundTransactionTypeId else @Purchase_RefFundTransactionTypeId end, 
					0, 0, @UnitPrice, 0 - isnull(@SumUnitQuantity,0) - 0 , 1, 0,
					@TenantId, @PolicyBusinessId, 
					case when @SumUnitQuantity > 0 then @Sale else @Purchase end, 
					@StampUserId, @StampUserId)
		end

	commit tran

return 0 
