CREATE PROCEDURE [dbo].[nio_SpCustomAddEquityFromValuation]
@UserId bigint,
@PolicyBusinessId bigint,
@FundCode varchar(50),
@FundCodeType varchar(50),
@FundName varchar(255),
@Units money,
@UnitPrice money,
@UnitCurrency varchar(10) = null,
@UnitPriceDate datetime = null,
@PlanUnitPrice decimal(18,4) = null,
@RegionalUnitPrice decimal(18,4) = null,
@RegionalCurrency varchar(3) = null
as

--24/07/2018 -- selective update to Policybusinessfund and rafactoring  - KK

set nocount on
SET XACT_ABORT ON
set transaction isolation level read uncommitted
SET QUOTED_IDENTIFIER ON

declare @PolicyBusinessFundId bigint = 0;

Begin
	if not exists (select 1 from TValPotentialPlan with (nolock) where PolicyBusinessId = @PolicyBusinessId)
	begin
		select PolicyBusinessFundId =  @PolicyBusinessFundId;
		return;
	end

	DECLARE @FundId bigint, @EquityTypeId bigint, @FoundFundName varchar(255), @FundCurrency varchar(10)
	DECLARE @CategoryName varchar(255)
	DECLARE @FromFeedFg bit, @IndigoClientId bigint
	DECLARE @SequentialRef varchar(50)
	DECLARE @valuationProviderid int, @policyProviderid int
	DECLARE @SumUnitQuantity money
	DECLARE @Purchase_RefFundTransactionTypeId bigint, @Sale_RefFundTransactionTypeId bigint
	DECLARE @RefFundTransactionTypeId bigint
	declare @StampDateTime datetime2 = getdate(), @StampUser bigint = @UserId
	declare @SedolFundCode varchar(50), @MexFundCode varchar(50), @IsinFundCode varchar(50), @CitiFundCode varchar(50), @ProviderFundCode varchar(50)
	declare @Sedol varchar(10) = 'sedol', @Mex varchar(10) = 'mex', @Isin varchar(10) = 'isin', @Citi varchar(10) = 'citicode', @Provider varchar(10)
    declare @Equities varchar(10) = 'Equities', @ElectronicValuation varchar(25) = 'Electronic Valuation', @currentunitQty money, @currentPrice money

	declare @currentNonfeedUnitPrice money

	declare @Purchase varchar(10) = 'Purchase'
	declare @Sale varchar(10) = 'Sale'
	declare @planCurrency varchar(3);
	
	Select @Purchase_RefFundTransactionTypeId = RefFundTransactionTypeId FROM TRefFundTransactionType with (nolock) WHERE Description = @Purchase
	Select @Sale_RefFundTransactionTypeId = RefFundTransactionTypeId FROM TRefFundTransactionType with (nolock) WHERE Description = @Sale
	Select @IndigoClientId = IndigoClientId, @valuationProviderid = valuationproviderid, @SequentialRef = sequentialref,  @policyProviderid = policyproviderid
		FROM TValpotentialplan with (nolock) WHERE PolicyBusinessId = @PolicyBusinessId
	
	--Default date
	If @UnitPriceDate is null
	 SET @UnitPriceDate = @StampDateTime

	-- Get Regional Currency if not supplied
	IF ISNULL(@RegionalCurrency,'') = '' 
		Select @regionalCurrency = administration.dbo.FnGetRegionalCurrency()

	-- default the fund currency if not supplied
	If ISNULL(@UnitCurrency,'') = ''
		SET @FundCurrency = @regionalCurrency
	else
		SET @FundCurrency = @UnitCurrency

	-- get the price in plan currency if not supplied
	IF @PlanUnitPrice IS NULL
	BEGIN
		-- get the plan currency
		Select @PlanCurrency = pb.BaseCurrency FROM	TPolicyBusiness pb WITH (NOLOCK) WHERE PolicyBusinessId = @PolicyBusinessId
		IF @FundCurrency <> @PlanCurrency
				SET @PlanUnitPrice = policymanagement.dbo.FnConvertCurrency(@unitPrice, @FundCurrency, @PlanCurrency)
		ELSE
				SET @PlanUnitPrice = @UnitPrice
		END

	-- watch out as sometimes we get a SEDOL or MEX code type, but no code!
	if @FundCode is null set @FundCode = ''

	IF @FundCode = ''
		set @FundCodeType  = ''
	else
		set @FundCodeType = replace(Lower(@FundCodeType),' ', '')

	if @FundCodeType = @Isin
	begin

		SELECT top 1 @FundId = eq.EquityId, @FoundFundName = eq.EquityName
		FROM Fund2..TEquity eq
		WHERE IsInCode = @FundCode AND eq.UpdatedFg = 1
		order by EquityId desc

		set @IsinFundCode = @FundCode
	end

	select @EquityTypeId = RefFundTypeId, @CategoryName = [Type] from Fund2..TRefFundType where FundTypeName = @Equities

	If (@FundId <> 0) --it is a feedequity
		begin
			set @FromFeedFg = 1

			select top 1 @PolicyBusinessFundId = PolicyBusinessFundId, @currentunitQty = CurrentUnitQuantity, @currentPrice = CurrentPrice From TPolicyBusinessFund with (nolock)
						Where PolicyBusinessId = @PolicyBusinessId and FundId = @FundId and FromFeedFg = 1 and EquityFg = 1 order by PolicyBusinessFundId asc

			if ( coalesce(@PolicyBusinessFundId,0) <> 0)  --Fund exists and we may want to update
			begin
				if (@currentunitQty = @Units)
					GOTO LEAVEHOLDINGANDRETURN;
				else
					GOTO UPDATEHOLDING;
			end
			else  -- Fund doesnot exist and therefore will add new one
			begin
				GOTO ADDHOLDING;
			end
		end
	else --it is a non feedfund
	begin
		set @FromFeedFg = 0
		set @FundName = replace(@FundName,'&amp;', '&') -- didn't find the fund. Need to add one. (correct the fund name so it doesn't contain the '&amp;' code in it)

		if (@FundCodeType = @Sedol)
			begin
				select top 1 @FundId = NonFeedFundId, @currentNonfeedUnitPrice = CurrentPrice from TNonFeedFund with (nolock)
						where IndigoClientId = @IndigoClientId and coalesce(Sedol,'') = @FundCode and coalesce(FundName,'') = @FundName and FundTypeId = @EquityTypeId
				set @SedolFundCode = @FundCode
			end
		else if (@FundCodeType = @Mex)
			begin
				select Top 1 @FundId = NonFeedFundId, @currentNonfeedUnitPrice = CurrentPrice from TNonFeedFund with (nolock)
							where  IndigoClientId = @IndigoClientId and coalesce(MexId,'') = @FundCode and coalesce(FundName,'') = @FundName and FundTypeId = @EquityTypeId
				set @MexFundCode = @FundCode
			end
		else if (@FundCodeType = @Citi)
			begin
				select Top 1 @FundId = NonFeedFundId, @currentNonfeedUnitPrice = CurrentPrice from TNonFeedFund with (nolock)
							where  IndigoClientId = @IndigoClientId and coalesce(Citi,'') = @FundCode and coalesce(FundName,'') = @FundName and FundTypeId = @EquityTypeId
				set @CitiFundCode = @FundCode
			end
		else if (@FundCodeType = @Isin)
			begin
				select Top 1 @FundId = NonFeedFundId, @currentNonfeedUnitPrice = CurrentPrice from TNonFeedFund with (nolock)
							where  IndigoClientId = @IndigoClientId and coalesce(isin ,'') = @FundCode and coalesce(FundName,'') = @FundName and FundTypeId = @EquityTypeId
			end
		else if (@FundCodeType NOT IN (@Isin, @Mex, @Sedol, @Citi ))
		begin
				select Top 1 @FundId = NonFeedFundId, @currentNonfeedUnitPrice = CurrentPrice from TNonFeedFund with (nolock)
							where  IndigoClientId = @IndigoClientId and coalesce(ProviderFundCode ,'') = @FundCode and coalesce(FundName,'') = @FundName and FundTypeId = @EquityTypeId
				set @ProviderFundCode = @FundCode
		end

		if (coalesce(@FundId,0) <> 0)
		begin
			select top 1 @PolicyBusinessFundId = PolicyBusinessFundId, @currentunitQty = CurrentUnitQuantity, @currentPrice = CurrentPrice From TPolicyBusinessFund with (nolock)
					Where PolicyBusinessId = @PolicyBusinessId  and FundId = @FundId and FromFeedFg = 0 and EquityFg = 1 order by PolicyBusinessFundId asc

			if (coalesce(@PolicyBusinessFundId,0) <> 0)
			begin
				if (@currentunitQty <> @Units OR @currentPrice <> @PlanUnitPrice)
					GOTO UPDATEHOLDING;
				else
					GOTO LEAVEHOLDINGANDRETURN;
			end
			else
			begin
				GOTO ADDHOLDING;
			end
		end
		else  -- Fund doesnot exist and therefore will add new non feed fund
		begin
			GOTO ADDHOLDING;
		end
	end

select PolicyBusinessFundId = @PolicyBusinessFundId
return;

	LEAVEHOLDINGANDRETURN:
		select PolicyBusinessFundId =  @PolicyBusinessFundId;
		return

	UPDATEHOLDING:
		Update TPolicyBusinessFund
		Set CurrentUnitQuantity = case when (CurrentUnitQuantity <> @Units) then @Units else CurrentUnitQuantity end,
				LastUnitChangeDate = case when (CurrentUnitQuantity <> @Units) then @UnitPriceDate else LastUnitChangeDate end,
				CurrentPrice = case when (@FromFeedFg = 0 AND CurrentPrice <> @PlanUnitPrice) then @PlanUnitPrice else CurrentPrice end,
				LastPriceChangeDate = case when (@FromFeedFg = 0 AND CurrentPrice <> @PlanUnitPrice) then @UnitPriceDate else LastPriceChangeDate end,
				PriceUpdatedByUser = case when (@FromFeedFg = 0 AND CurrentPrice <> @PlanUnitPrice) then @ElectronicValuation else PriceUpdatedByUser end,
				ConcurrencyId = ConcurrencyId + 1
			output
				deleted.PolicyBusinessId, deleted.FundId, deleted.FundTypeId, deleted.FundName, deleted.CategoryId, deleted.CategoryName,
				deleted.CurrentUnitQuantity, deleted.LastUnitChangeDate, deleted.CurrentPrice, deleted.LastPriceChangeDate,
				deleted.PriceUpdatedByUser, deleted.FromFeedFg, deleted.FundIndigoClientId, deleted.InvestmentTypeId, deleted.RiskRating,
				deleted.EquityFg, deleted.ConcurrencyId, deleted.PolicyBusinessFundId, 'U', @StampDateTime, @StampUser, deleted.Cost,
				deleted.LastTransactionChangeDate, deleted.RegularContributionPercentage, deleted.UpdatedByReplicatedProc, deleted.PortfolioName,
				deleted.ModelPortfolioName, deleted.DFMName
			into TPolicyBusinessFundAudit
				(PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName,
				CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice, LastPriceChangeDate,
				PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating,
				EquityFg, ConcurrencyId, PolicyBusinessFundId, StampAction, StampDateTime, StampUser, Cost,
				LastTransactionChangeDate, RegularContributionPercentage, UpdatedByReplicatedProc, PortfolioName,
				ModelPortfolioName, DFMName)
		Where PolicyBusinessFundId = @PolicyBusinessFundId

		if (@FromFeedFg = 0)
		begin
			-- And for non feed fund get the unit price in regional currency
			IF @RegionalUnitPrice IS NULL
				IF @FundCurrency <> @RegionalCurrency
					SET @RegionalUnitPrice = policymanagement.dbo.FnConvertCurrency(@unitPrice, @FundCurrency, @RegionalCurrency)
				ELSE
					SET @RegionalUnitPrice = @UnitPrice

			if (@currentNonfeedUnitPrice <> @RegionalUnitPrice)
				begin
					update TNonFeedFund
						set CurrentPrice = @RegionalUnitPrice, PriceDate = @UnitPriceDate, PriceUpdatedByUser = @UserId,LastUpdatedByPlan = @SequentialRef, ConcurrencyId = ConcurrencyId + 1
						output
							deleted.FundTypeId, deleted.FundTypeName, deleted.FundName, deleted.CompanyId, deleted.CompanyName, deleted.CategoryId,
							deleted.CategoryName, deleted.Sedol, deleted.MexId, deleted.IndigoClientId, deleted.CurrentPrice, deleted.PriceDate, deleted.PriceUpdatedByUser,
							deleted.IsClosed, deleted.IsArchived, deleted.IncomeYield, deleted.ConcurrencyId, deleted.NonFeedFundId, 'U', @StampDateTime, @StampUser,
							deleted.ISIN, deleted.Citi, deleted.ProviderFundCode, deleted.RefProdProviderId, deleted.LastUpdatedByPlan
						into [TNonFeedFundAudit]
							(FundTypeId, FundTypeName, FundName, CompanyId, CompanyName, CategoryId,
							CategoryName, Sedol, MexId, IndigoClientId, CurrentPrice, PriceDate, PriceUpdatedByUser,
							IsClosed, IsArchived, IncomeYield, ConcurrencyId, NonFeedFundId, StampAction, StampDateTime, StampUser,
							ISIN, Citi, ProviderFundCode, RefProdProviderId, LastUpdatedByPlan)
					where NonFeedFundId = @FundId
				end
		end
	GOTO ADDTXNIFREQUIREDANDRETURN;

	ADDHOLDING:
		
		if (@FoundFundName is not null)
			set @FundName = @FoundFundName

		if (@FromFeedFg = 0 and coalesce(@FundId,0) = 0 )
		begin
			-- store non feed fund prices in regional currency
			insert into TNonFeedFund (FundTypeId, FundTypeName, FundName, CompanyId, CompanyName, CategoryId, CategoryName, Sedol, MexId, ISIN, Citi, ProviderFundCode, IndigoClientId, CurrentPrice, PriceDate,
				PriceUpdatedByUser, ConcurrencyId, LastUpdatedByPlan )
			values (@EquityTypeId, @Equities, @FundName, null, null, null, null, @SedolFundCode, @MexFundCode, @IsinFundCode, @CitiFundCode, @ProviderFundCode, @IndigoClientId, @RegionalUnitPrice, @UnitPriceDate, @StampUser, 1, @SequentialRef)

			select @FundId = scope_identity()

			insert into [TNonFeedFundAudit]
					(FundTypeId, FundTypeName, FundName, CompanyId, CompanyName, CategoryId, CategoryName, Sedol,
					MexId, IndigoClientId, CurrentPrice, PriceDate, PriceUpdatedByUser, IsClosed, IsArchived,
					IncomeYield, ConcurrencyId, NonFeedFundId, StampAction, StampDateTime, StampUser, ISIN, Citi,
					ProviderFundCode, RefProdProviderId, LastUpdatedByPlan)
			select	FundTypeId, FundTypeName, FundName, CompanyId, CompanyName, CategoryId, CategoryName, Sedol,
					MexId, IndigoClientId, CurrentPrice, PriceDate, PriceUpdatedByUser, IsClosed, IsArchived,
					IncomeYield, ConcurrencyId, NonFeedFundId, 'C', @StampDateTime, @StampUser, ISIN, Citi,
					ProviderFundCode, RefProdProviderId, LastUpdatedByPlan
			from TNonFeedFund with (nolock)
			where NonFeedFundId = @FundId
		end

		-- holding price in plan currency
		insert into TPolicyBusinessFund
		(PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
			LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, EquityFg, FundIndigoClientId, InvestmentTypeId, RiskRating, ModelPortfolioName, DFMName, ConcurrencyId)
		values (@PolicyBusinessId, @FundId, @EquityTypeId, @FundName, null, @CategoryName, @Units, @UnitPriceDate, @PlanUnitPrice,
				@UnitPriceDate, @ElectronicValuation, @FromFeedFg, 1, @IndigoClientId, null, null, null, null, 1)

		select @PolicyBusinessFundId  = scope_identity()

		insert into TPolicyBusinessFundAudit
				(PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName,CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
				LastPriceChangeDate,PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating,EquityFg, ConcurrencyId, PolicyBusinessFundId,
				StampAction, StampDateTime, StampUser, Cost,LastTransactionChangeDate, RegularContributionPercentage, UpdatedByReplicatedProc, PortfolioName,ModelPortfolioName, DFMName)
		select
				PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName,CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
				LastPriceChangeDate,PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating,EquityFg, ConcurrencyId, PolicyBusinessFundId,
				'C', @StampDateTime, @StampUser, Cost,LastTransactionChangeDate, RegularContributionPercentage, UpdatedByReplicatedProc, PortfolioName,ModelPortfolioName, DFMName
		from TPolicyBusinessFund with (nolock)
		where PolicyBusinessFundId = @PolicyBusinessFundId

	GOTO ADDTXNIFREQUIREDANDRETURN;

	ADDTXNIFREQUIREDANDRETURN:
		Select @SumUnitQuantity = IsNull(sum(UnitQuantity),0) 
		From TPolicyBusinessFundTransaction with (nolock)  
		Where 
			TenantId = @IndigoClientId
		AND PolicyBusinessFundId = @PolicyBusinessFundId

		if @SumUnitQuantity <> @Units
		begin
			insert into TPolicyBusinessFundTransaction
				(PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, Gross, Cost, UnitPrice, UnitQuantity, ConcurrencyId, IsFromTransactionHistory,
				 TenantId, PolicyBusinessId, Category1Text, CreatedByUserId, UpdatedByUserId)
				output
					inserted.PolicyBusinessFundId, inserted.TransactionDate, inserted.RefFundTransactionTypeId, inserted.Gross, inserted.Cost, inserted.UnitPrice, inserted.UnitQuantity,
					inserted.ConcurrencyId, inserted.PolicyBusinessFundTransactionId, 'C', @StampDateTime, @StampUser, inserted.IsFromTransactionHistory
				into [TPolicyBusinessFundTransactionAudit]
					(PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, Gross, Cost, UnitPrice, UnitQuantity, ConcurrencyId, PolicyBusinessFundTransactionId, StampAction, StampDateTime, StampUser, IsFromTransactionHistory)
			values (
				@PolicyBusinessFundId, @UnitPriceDate,
				case when @SumUnitQuantity < @Units then @Purchase_RefFundTransactionTypeId else @Sale_RefFundTransactionTypeId end, 
				0, 0, @PlanUnitPrice, (@Units - @SumUnitQuantity), 1, 0,
				@IndigoClientId, @PolicyBusinessId, 
				case when @SumUnitQuantity < @Units then @Purchase else @Sale end, 
				@StampUser, @StampUser
			)

			declare @newCost money
			set @newCost = dbo.FnCustomCalculateFundCost(@IndigoClientId,@PolicyBusinessFundId)
			update TPolicyBusinessFund set Cost = @newCost where PolicyBusinessFundId = @PolicyBusinessFundId and (cost is null or cost <> @newCost)
		end

		select PolicyBusinessFundId =  @PolicyBusinessFundId;
		return;
end;