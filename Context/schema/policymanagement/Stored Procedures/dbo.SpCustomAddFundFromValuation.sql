SET ANSI_NULLS ON
GO
create PROCEDURE dbo.SpCustomAddFundFromValuation
@UserId bigint,
@PolicyBusinessId bigint,
@FundCode varchar(50),
@FundCodeType varchar(50),
@FundName varchar(255),
@Units money,
@UnitPrice money,
@UnitCurrency varchar(10) = null,
@UnitPriceDate datetime,
@DFMName varchar(2000) = null,
@ModelPortfolioName varchar (2000) = null,
@PlanUnitPrice decimal(18,4) = null,
@RegionalUnitPrice decimal(18,4) = null,
@RegionalCurrency varchar(3) = null

as

--04/03/2008 - Mod to hande @UnitPriceDate
--05/02/2010 - handle funds in different currencies (ajf)
--01/10/2010 - handle fund transactions
--14/01/2011 - handle fund attributes
--23/02/2012 - read unit currency from provider @FundCurrency
--26/09/2013 - ### PLEASE NOTE: ### This procedure is being called from a wrapper stored procedure, SpCustomAddFundFromValuation_NIOWrapper. Please ensure that any change made to this sp does not negatively impact the wrapper SP
--20/11/2014 - KK - Optimized as it was causing locks in Production, i.e.
			 -- Added with lock hint
			 -- replaced 2 calls with one call into FnCustomRetrievePolicyBusinessFundWithAttributes
			 -- constantize magic strings
			 -- replaced audit inserts with output clause
			 -- NOTE : size of it be cut into half if we use dyanamic sql however chose not to as that could result into recompiling and I thought which will adversly affect the performance in this context.
--24/07/2018 -- selective update to Policybusinessfund and rafactoring  - KK
--23/06/2020 -- Holding prices now in Plan Currency, Non Feed Fund Prices in regional currency - LH

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

	DECLARE @FundId bigint, @FundTypeId bigint, @FoundFundName varchar(255), @FundCurrency varchar(10)
	DECLARE @CategoryId bigint, @CategoryName varchar(255)
	DECLARE @FromFeedFg bit, @IndigoClientId bigint
	DECLARE @SequentialRef varchar(50)
	DECLARE @valuationProviderid int, @policyProviderid int
	DECLARE @SumUnitQuantity money
	DECLARE @Purchase_RefFundTransactionTypeId bigint, @Sale_RefFundTransactionTypeId bigint
	DECLARE @RefFundTransactionTypeId bigint
	declare @StampDateTime datetime2 = getdate(), @StampUser bigint = @UserId
	declare @SedolFundCode varchar(50), @MexFundCode varchar(50), @IsinFundCode varchar(50), @CitiFundCode varchar(50), @ProviderFundCode varchar(50)
	declare @Sedol varchar(10) = 'sedol', @Mex varchar(10) = 'mex', @Isin varchar(10) = 'isin', @Citi varchar(10) = 'citicode', @Provider varchar(10)
    declare @Unknown varchar(10) = 'Unknown', @ElectronicValuation varchar(25) = 'Electronic Valuation', @currentunitQty money, @currentPrice money
	declare @currentNonfeedUnitPrice money
	declare @Purchase varchar(10) = 'Purchase'
	declare @Sale varchar(10) = 'Sale'

	declare @Equities varchar(10) = 'Equities', @EquityTypeId int, @EquityTypeName varchar(255) = ''
	SELECT @EquityTypeId = RefFundTypeId, @EquityTypeName = [Type] FROM Fund2..TRefFundType WHERE FundTypeName = @Equities

	Select @Purchase_RefFundTransactionTypeId = RefFundTransactionTypeId FROM TRefFundTransactionType with (nolock) WHERE Description = @Purchase
	Select @Sale_RefFundTransactionTypeId = RefFundTransactionTypeId FROM TRefFundTransactionType with (nolock) WHERE Description = @Sale
	Select @IndigoClientId = IndigoClientId, @valuationProviderid = valuationproviderid, @SequentialRef = sequentialref,  @policyProviderid = policyproviderid
		FROM TValpotentialplan with (nolock) WHERE PolicyBusinessId = @PolicyBusinessId

	DECLARE @planCurrency VARCHAR(3)
	
	-- Get the regional currency if it is not supplied
	IF ISNULL(@RegionalCurrency,'') = ''
		Select @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

	-- default fund currency if not supplied
	If ISNULL(@UnitCurrency,'') = ''
		SET @FundCurrency = @regionalCurrency
	else
		SET @FundCurrency = @UnitCurrency

	-- get the price in plan currency if it is not supplied
	IF @PlanUnitPrice IS NULL
	BEGIN
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

	if (@FundCodeType = @Sedol)
	begin
		-- make sure the sedol is the correct length (7), pad with zeros otherwise
		SET @FundCode = REPLICATE('0', 7 - len(@FundCode)) + @FundCode
		SELECT top 1 @FundId = fu.FundUnitId,@FundTypeId = f.RefFundTypeId,@FoundFundName = fu.UnitLongName,@CategoryId = fs.FundSectorId,@CategoryName = fs.FundSectorName
		FROM Fund2..TFundUnit fu with (nolock)
				JOIN fund2..TFund f with (nolock) ON f.FundId = fu.FundId
				JOIN fund2..TFundSector fs with (nolock) ON fs.FundSectorId = f.FundSectorId
		WHERE fu.SedolCode = @FundCode AND fu.UpdatedFg = 1 -- make sure we're pulling a current fund, not an old one
		set @SedolFundCode = @FundCode
	end
	else if (@FundCodeType = @Mex)
	begin
		SELECT top 1 @FundId = fu.FundUnitId,@FundTypeId = f.RefFundTypeId,@FoundFundName = fu.UnitLongName,@CategoryId = fs.FundSectorId,@CategoryName = fs.FundSectorName
		FROM Fund2..TFundUnit fu  with (nolock)
			JOIN fund2..TFund f with (nolock) ON f.FundId = fu.FundId
			JOIN fund2..TFundSector fs with (nolock) ON fs.FundSectorId = f.FundSectorId
		WHERE MexCode = @FundCode AND fu.UpdatedFg = 1 -- make sure we're pulling a current fund, not an old one

		set @MexFundCode = @FundCode
	end
	else if (@FundCodeType = @Isin)
	begin
		SELECT top 1 @FundId = fu.FundUnitId,@FundTypeId = f.RefFundTypeId,@FoundFundName = fu.UnitLongName,@CategoryId = fs.FundSectorId,@CategoryName = fs.FundSectorName
		FROM Fund2..TFundUnit fu with (nolock)
			JOIN fund2..TFund f with (nolock) ON f.FundId = fu.FundId
			JOIN fund2..TFundSector fs with (nolock) ON fs.FundSectorId = f.FundSectorId
		WHERE IsInCode = @FundCode AND fu.UpdatedFg = 1 -- make sure we're pulling a current fund, not an old one

		set @IsinFundCode  = @FundCode
	end
	else if (@FundCodeType = @Citi)
	begin
		SELECT top 1 @FundId = fu.FundUnitId,@FundTypeId = f.RefFundTypeId,@FoundFundName = fu.UnitLongName,@CategoryId = fs.FundSectorId,@CategoryName = fs.FundSectorName
		FROM Fund2..TFundUnit fu with (nolock)
			JOIN fund2..TFund f with (nolock) ON f.FundId = fu.FundId
			JOIN fund2..TFundSector fs with (nolock) ON fs.FundSectorId = f.FundSectorId
		WHERE CitiCode = @FundCode AND fu.UpdatedFg = 1 -- make sure we're pulling a current fund, not an old one

		set @CitiFundCode  = @FundCode
	end
	-- provider specific?
	else if (@FundCodeType not in (@Isin, @Mex, @Sedol, @Citi))
	begin
		SELECT top 1 @FundId = fu.FundUnitId, @FundTypeId = f.RefFundTypeId, @FoundFundName = fu.UnitLongName, @CategoryId = fs.FundSectorId, @CategoryName = fs.FundSectorName
		FROM Fund2..TFundUnit fu with (nolock)
			JOIN fund2..TFund f  with (nolock) ON f.FundId = fu.FundId
			JOIN fund2..TFundSector fs  with (nolock) ON fs.FundSectorId = f.FundSectorId
			JOIN TProviderFundCode pfc  with (nolock) ON pfc.FundId = fu.fundUnitId and pfc.FundTypeId = f.RefFundTypeId
		WHERE pfc.RefProdproviderId = @policyProviderid AND pfc.ProviderFundCode = @FundCode

		set @ProviderFundCode = @FundCode
	end

	If (@FundId <> 0) --it is a feedfund
		begin
			set @FromFeedFg = 1

			select top 1 @PolicyBusinessFundId = PolicyBusinessFundId, @currentunitQty = CurrentUnitQuantity, @currentPrice = CurrentPrice From TPolicyBusinessFund with (nolock)
						Where PolicyBusinessId = @PolicyBusinessId and FundId = @FundId and FromFeedFg = 1 and EquityFg = 0 order by PolicyBusinessFundId asc

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

		-- don't know the fund type, so get the Unknown one
		select @FundTypeId = RefFundTypeId FROM Fund2..TRefFundType with (nolock) WHERE FundTypeName = @Unknown

		if (@FundCodeType = @Sedol)
			select top 1 @FundId = NonFeedFundId, @currentNonfeedUnitPrice = CurrentPrice from TNonFeedFund with (nolock)
						where IndigoClientId = @IndigoClientId and coalesce(Sedol,'') = @FundCode and coalesce(FundName,'') = @FundName and fundtypeid <> @EquityTypeId
		else if (@FundCodeType = @Mex)
				select Top 1 @FundId = NonFeedFundId, @currentNonfeedUnitPrice = CurrentPrice from TNonFeedFund with (nolock)
							where  IndigoClientId = @IndigoClientId and coalesce(MexId,'') = @FundCode and coalesce(FundName,'') = @FundName and fundtypeid <> @EquityTypeId
		else if (@FundCodeType = @Citi)
				select Top 1 @FundId = NonFeedFundId, @currentNonfeedUnitPrice = CurrentPrice from TNonFeedFund with (nolock)
							where  IndigoClientId = @IndigoClientId and coalesce(Citi,'') = @FundCode and coalesce(FundName,'') = @FundName and fundtypeid <> @EquityTypeId
		else if (@FundCodeType = @Isin)
				select Top 1 @FundId = NonFeedFundId, @currentNonfeedUnitPrice = CurrentPrice from TNonFeedFund with (nolock)
							where  IndigoClientId = @IndigoClientId and coalesce(isin ,'') = @FundCode and coalesce(FundName,'') = @FundName and fundtypeid <> @EquityTypeId
		else if (@FundCodeType NOT IN (@Isin, @Mex, @Sedol, @Citi ))
		begin
				select Top 1 @FundId = NonFeedFundId, @currentNonfeedUnitPrice = CurrentPrice from TNonFeedFund with (nolock)
							where  IndigoClientId = @IndigoClientId and coalesce(ProviderFundCode ,'') = @FundCode and coalesce(FundName,'') = @FundName and fundtypeid <> @EquityTypeId
		end

		if (coalesce(@FundId,0) <> 0)
		begin
			select top 1 @PolicyBusinessFundId = PolicyBusinessFundId, @currentunitQty = CurrentUnitQuantity, @currentPrice = CurrentPrice From TPolicyBusinessFund with (nolock)
					Where PolicyBusinessId = @PolicyBusinessId  and FundId = @FundId and FromFeedFg = 0 and EquityFg = 0 order by PolicyBusinessFundId asc

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
		select PolicyBusinessFundId = @PolicyBusinessFundId;
		return;

	UPDATEHOLDING:
		
		Update TPolicyBusinessFund
		Set CurrentUnitQuantity = case when (CurrentUnitQuantity <> @Units) then @Units else CurrentUnitQuantity end,
				LastUnitChangeDate = case when (CurrentUnitQuantity <> @Units) then @UnitPriceDate else LastUnitChangeDate end,
				CurrentPrice = case when (@FromFeedFg = 0 AND CurrentPrice <> @PlanUnitPrice) then @PlanUnitPrice else CurrentPrice end,
				LastPriceChangeDate = case when (@FromFeedFg = 0 AND CurrentPrice <> @PlanUnitPrice) then @UnitPriceDate else LastPriceChangeDate end,
				PriceUpdatedByUser = case when (@FromFeedFg = 0 AND CurrentPrice <> @PlanUnitPrice) then @ElectronicValuation else PriceUpdatedByUser end,
			ModelPortfolioName = @ModelPortfolioName, DFMName = @DFMName,
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
			-- get the price in regional currency if it is not supplied
			IF @RegionalUnitPrice IS NULL
			BEGIN
				IF @FundCurrency <> @RegionalCurrency
					SET @RegionalUnitPrice = policymanagement.dbo.FnConvertCurrency(@unitPrice, @FundCurrency, @RegionalCurrency)
				ELSE
					SET @RegionalUnitPrice = @UnitPrice
			END

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
			-- store non feed fund price in regional currency
			insert into TNonFeedFund (FundTypeId, FundTypeName, FundName, CompanyId, CompanyName, CategoryId, CategoryName, Sedol, MexId, ISIN, Citi, ProviderFundCode, IndigoClientId, CurrentPrice, PriceDate,
				PriceUpdatedByUser, ConcurrencyId, LastUpdatedByPlan )
			values (@FundTypeId, @Unknown, @FundName, null, null, null, null, @SedolFundCode, @MexFundCode, @IsinFundCode, @CitiFundCode, @ProviderFundCode, @IndigoClientId, @RegionalUnitPrice, @UnitPriceDate, @StampUser, 1, @SequentialRef)

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

		insert into TPolicyBusinessFund
		(PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,
			LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, ModelPortfolioName, DFMName, ConcurrencyId)
		values (@PolicyBusinessId, @FundId, @FundTypeId, @FundName, @CategoryId, @CategoryName, @Units, @UnitPriceDate, @PlanUnitPrice,
				@UnitPriceDate, @ElectronicValuation, @FromFeedFg, @IndigoClientId, null, null, @ModelPortfolioName, @DFMName, 1)

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
		Select @SumUnitQuantity = IsNull(sum(UnitQuantity),0) From TPolicyBusinessFundTransaction with (nolock)  
		Where TenantId = @IndigoClientId
		And PolicyBusinessFundId = @PolicyBusinessFundId

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
			values (@PolicyBusinessFundId, @UnitPriceDate,
					case when @SumUnitQuantity < @Units
						then @Purchase_RefFundTransactionTypeId
						else @Sale_RefFundTransactionTypeId
					 end, 0, 0, @PlanUnitPrice, (@Units - @SumUnitQuantity), 1, 0,
					@IndigoClientId, @PolicyBusinessId,
					case when @SumUnitQuantity < @Units
						then @Purchase
						else @Sale
					end,
					@StampUser, @StampUser)

			declare @newCost money
			set @newCost = dbo.FnCustomCalculateFundCost(@IndigoClientId, @PolicyBusinessFundId)
			update TPolicyBusinessFund set Cost = @newCost where PolicyBusinessFundId = @PolicyBusinessFundId and (cost is null or cost <> @newCost)
		end

	select PolicyBusinessFundId =  @PolicyBusinessFundId;
	return;

end;