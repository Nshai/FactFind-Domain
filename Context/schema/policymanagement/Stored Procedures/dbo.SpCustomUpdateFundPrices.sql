SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.SpCustomUpdateFundPrices
(
	@IndigoClientId INT,
	@BatchSize		INT = 50000
)
AS	

	SET NOCOUNT ON
	
	DECLARE @StampDateTime DATETIME2 = getdate()
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF OBJECT_ID('tempdb..#TmpFundUpdateBatch') IS NOT NULL
		DROP TABLE #TmpFundUpdateBatch
	
	IF OBJECT_ID('tempdb..#TmpEquityUpdateBatch') IS NOT NULL
		DROP TABLE #TmpEquityUpdateBatch

	IF OBJECT_ID('tempdb..#TmpExRate') IS NOT NULL
		DROP TABLE #TmpExRate

	CREATE TABLE #CTE_PolicyBusiness  (PolicyBusinessId INT PRIMARY KEY)

	INSERT #CTE_PolicyBusiness
		SELECT PolicyBusinessId 
			FROM policymanagement.dbo.TPolicyBusiness 
			WHERE IndigoClientId = @IndigoClientId;

	-- |-------------------------------------------------------------- 
	-- | make sure that everyone has the current version of each fund
	-- |-------------------------------------------------------------- 
	UPDATE 
		pbf
	SET 
		 pbf.FundId		= fu2.FundUnitId
		,ConcurrencyId	= pbf.ConcurrencyId + 1
	OUTPUT
		 deleted.PolicyBusinessId, deleted.FundId, deleted.FundTypeId, deleted.FundName, deleted.CategoryId, deleted.CategoryName
		,deleted.CurrentUnitQuantity, deleted.LastUnitChangeDate, deleted.CurrentPrice, deleted.LastPriceChangeDate, deleted.PriceUpdatedByUser
		,deleted.FromFeedFg, deleted.FundIndigoClientId, deleted.InvestmentTypeId, deleted.RiskRating, deleted.EquityFg, deleted.ConcurrencyId
		,deleted.PolicyBusinessFundId, 'U', @StampDateTime, 1, deleted.Cost
		,deleted.LastTransactionChangeDate, deleted.RegularContributionPercentage, deleted.UpdatedByReplicatedProc, deleted.PortfolioName
		,deleted.ModelPortfolioName, deleted.DFMName, deleted.MigrationReference
	INTO dbo.TPolicyBusinessFundAudit
	(
		 PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName
		,CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice, LastPriceChangeDate, PriceUpdatedByUser
		,FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, ConcurrencyId
		,PolicyBusinessFundId, StampAction, StampDateTime, StampUser, Cost
		,LastTransactionChangeDate, RegularContributionPercentage, UpdatedByReplicatedProc, PortfolioName
		,ModelPortfolioName, DFMName, MigrationReference
	)
	FROM policymanagement..TPolicyBusinessFund AS pbf
		JOIN #CTE_PolicyBusiness cpb ON  cpb.PolicyBusinessId = pbf.PolicyBusinessId
		JOIN TPolicyBusiness AS pb ON pb.PolicyBusinessId = cpb.PolicyBusinessId
		JOIN fund2..TFundUnit AS fu ON fu.FundUnitId = pbf.FundId
		JOIN fund2..TFundUnit AS fu2 ON fu2.FeedFundCode = fu.FeedFundCode
			AND fu2.UpdatedFg = 1
	WHERE
		pbf.FromFeedFg	= 1
	AND pbf.EquityFg	= 0
	AND pbf.FundId		<> fu2.FundUnitId

	-- |-----------------------------------------------------------------------
	-- | Cache Exchange Rates for all combos of FundCurrency vs PlanCurrency
	-- | this is to avoid calling the Currency Conversion function for each
	-- | holding
	-- |-----------------------------------------------------------------------
	CREATE TABLE #TmpExRate
	(
		 SourceCurrency		VARCHAR(3) 
		,TargetCurrency		VARCHAR(3)
		,CrRate				DECIMAL(18,10)
	)
	CREATE INDEX IX_#TmpExRate ON #TmpExRate (SourceCurrency)

	CREATE TABLE #ctePlanCurrencies (
	BaseCurrency varchar(50), PolicyBusinessId int, UsePriceFeed bit
	)

	CREATE UNIQUE INDEX IX_TEMP_EXRATE ON #TmpExRate(SourceCurrency, TargetCurrency);

	WITH ctePlanCurrencies AS
	(
		SELECT pb.BaseCurrency, pb.PolicyBusinessId, pb.UsePriceFeed
		FROM #CTE_PolicyBusiness c 
		INNER JOIN  policymanagement.dbo.TPolicyBusiness pb ON c.PolicyBusinessId= pb.PolicyBusinessId
	)
	INSERT #ctePlanCurrencies SELECT * FROM ctePlanCurrencies;

	WITH cteFundCurrencies AS
	(
		SELECT 
				fu.Currency			AS SourceCurrency
		FROM
			fund2.dbo.TFundUnit fu
		UNION 
		SELECT eq.Currency
		FROM fund2..TEquity eq
	), ctePlanCurrencies AS
	(
		SELECT DISTINCT BaseCurrency AS TargetCurrency
		FROM #ctePlanCurrencies
	)
	INSERT INTO #TmpExRate 
	SELECT cte1.SourceCurrency, cte2.TargetCurrency, ISNULL(dbo.FnGetCurrencyRate(cte1.SourceCurrency, cte2.TargetCurrency), 1.0)
	FROM cteFundCurrencies cte1 
	JOIN ctePlanCurrencies cte2
	ON cte1.SourceCurrency <> cte2.TargetCurrency


	-- |-----------------------------------------------------------------------
	-- | Create and Load Temp Table for Fund Update Batches
	-- |-----------------------------------------------------------------------
	DECLARE @MaxRow INT;
		
	CREATE TABLE #TmpFundUpdateBatch
	(
		 RowNo					INT IDENTITY(1,1) PRIMARY KEY
		,PolicyBusinessId		INT
		,PlanCurrency			VARCHAR(3)
	)

	INSERT INTO #TmpFundUpdateBatch
	(
		 PolicyBusinessId
		,PlanCurrency
	)
	SELECT DISTINCT
		 pbf.PolicyBusinessId
		,pb.BaseCurrency
	FROM
		#ctePlanCurrencies PB
	JOIN policymanagement..TPolicyBusinessFund AS pbf
		ON pbf.PolicyBusinessId = pb.PolicyBusinessId
	WHERE
		pb.UsePriceFeed = 1
	AND pbf.FromFeedFg = 1
	AND pbf.EquityFg = 0
	AND pbf.CurrentUnitQuantity IS NOT NULL
	AND pbf.CurrentUnitQuantity <> 0

	SELECT @MaxRow = @@rowcount;

	-- |-----------------------------------------------------------------------
	-- | Finally Process the Batches
	-- |-----------------------------------------------------------------------
	DECLARE @StartRow	INT = 1;
	DECLARE @EndRow		INT = @StartRow + @BatchSize - 1;
	
	WHILE(1=1)
	BEGIN

		-- All Batches Processed
		IF @StartRow > @MaxRow 
			BREAK;
		
		-- |--------------------------------------------------------------------
		-- | Update Fund Prices in Plan Currency 
		-- |--------------------------------------------------------------------
		UPDATE tpbf  
		SET 
			 tpbf.CurrentPrice = ROUND( CASE 
											WHEN ISNULL(fup.MidPrice,0) > 0 THEN fup.MidPrice 
											WHEN ISNULL(fup.BidPrice,0) > 0 THEN fup.BidPrice 
											ELSE fup.OfferPrice 
										END * ISNULL(cr.CrRate, 1.0), 4 )
			,tpbf.LastPriceChangeDate = fup.PriceDate
			,tpbf.PriceUpdatedByUser = 'Price Feed'
			,tpbf.FundName = fu.UnitLongName
			,tpbf.CategoryId = f.FundSectorId
			,tpbf.CategoryName = fs.FundSectorName
			,tpbf.ConcurrencyId = tpbf.ConcurrencyId + 1
		OUTPUT
			 deleted.PolicyBusinessId, deleted.FundId, deleted.FundTypeId, deleted.FundName, deleted.CategoryId, deleted.CategoryName
			,deleted.CurrentUnitQuantity, deleted.LastUnitChangeDate, deleted.CurrentPrice, deleted.LastPriceChangeDate, deleted.PriceUpdatedByUser
			,deleted.FromFeedFg, deleted.FundIndigoClientId, deleted.InvestmentTypeId, deleted.RiskRating, deleted.EquityFg, deleted.ConcurrencyId
			,deleted.PolicyBusinessFundId, 'U', @StampDateTime, 0, deleted.Cost
			,deleted.LastTransactionChangeDate, deleted.RegularContributionPercentage, deleted.UpdatedByReplicatedProc, deleted.PortfolioName
			,deleted.ModelPortfolioName, deleted.DFMName, deleted.MigrationReference
		INTO dbo.TPolicyBusinessFundAudit
		(
			 PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName
			,CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice, LastPriceChangeDate, PriceUpdatedByUser
			,FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, ConcurrencyId
			,PolicyBusinessFundId, StampAction, StampDateTime, StampUser, Cost
			,LastTransactionChangeDate, RegularContributionPercentage, UpdatedByReplicatedProc, PortfolioName
			,ModelPortfolioName, DFMName, MigrationReference
		)
		FROM 
			#TmpFundUpdateBatch AS batch

			JOIN TPolicyBusinessFund AS tpbf
				ON tpbf.PolicyBusinessId = batch.PolicyBusinessId
			
			JOIN fund2..TFundUnit AS fu 
				ON fu.FundUnitId = tpbf.fundId
	
			JOIN fund2..TFundUnitPrice AS fup 
				ON fup.FundUnitId = fu.FundUnitId

			JOIN fund2..TFund AS f 
				ON f.fundid = fu.fundid

			JOIN fund2..TFundSector AS fs 
				ON fs.FundSectorId = f.fundsectorid

			LEFT JOIN #TmpExRate cr
				ON cr.SourceCurrency = fu.Currency
				AND cr.TargetCurrency = batch.PlanCurrency
		WHERE
			batch.RowNo BETWEEN @startRow AND @endRow
		AND tpbf.FromFeedFg = 1 
		AND tpbf.EquityFg = 0
		AND tpbf.CurrentUnitQuantity IS NOT NULL
		AND tpbf.CurrentUnitQuantity <> 0

		SET @StartRow = @EndRow + 1;
		SET @EndRow = @StartRow + @BatchSize - 1;

	END -- Batch LOOP

	IF OBJECT_ID('tempdb..#TmpFundUpdateBatch') IS NOT NULL
		DROP TABLE #TmpFundUpdateBatch

	-- |------------------------------------------------------------
	-- | Update Equity Prices 
	-- |------------------------------------------------------------
	CREATE TABLE #TmpEquityUpdateBatch
	(
		 RowNo					INT IDENTITY(1,1) PRIMARY KEY
		,PolicyBusinessId		INT
		,PlanCurrency			VARCHAR(3)
	)

	INSERT INTO #TmpEquityUpdateBatch
	(
		PolicyBusinessId
		,PlanCurrency
	)
	SELECT DISTINCT
		 pbf.PolicyBusinessId
		,pb.BaseCurrency
	FROM
		#ctePlanCurrencies PB
		JOIN policymanagement..TPolicyBusinessFund AS pbf
			ON pbf.PolicyBusinessId = pb.PolicyBusinessId

	WHERE
		pb.UsePriceFeed = 1
	AND pbf.FromFeedFg = 1
	AND pbf.EquityFg = 1
	AND pbf.CurrentUnitQuantity IS NOT NULL
	AND pbf.CurrentUnitQuantity <> 0

	SELECT @MaxRow = @@rowcount

	SET @StartRow	= 1;
	SET @EndRow		= @StartRow + @BatchSize - 1;
	
	-- |------------------------------------------------------------
	-- | Update Equity Prices
	-- |------------------------------------------------------------
	WHILE(1=1)
	BEGIN
		
		-- All Batches Processed
		IF @StartRow > @MaxRow 
			BREAK;

	    -- Update Equity prices in Plan Currency
		UPDATE tpbf  
		SET
			 tpbf.CurrentPrice = ROUND( CASE	
											WHEN ISNULL(ep.Bid, 0) > 0 THEN ep.Bid
											ELSE ep.Mid
										END * ISNULL(cr.CrRate, 1.0), 4 )								
			,tpbf.LastPriceChangeDate = ep.PriceDate
			,tpbf.PriceUpdatedByUser = 'Price Feed'
			,tpbf.FundName = e.EquityName
			,ConcurrencyId = tpbf.ConcurrencyId + 1
		OUTPUT
			 deleted.PolicyBusinessId, deleted.FundId, deleted.FundTypeId, deleted.FundName, deleted.CategoryId, deleted.CategoryName
			,deleted.CurrentUnitQuantity, deleted.LastUnitChangeDate, deleted.CurrentPrice, deleted.LastPriceChangeDate, deleted.PriceUpdatedByUser
			,deleted.FromFeedFg, deleted.FundIndigoClientId, deleted.InvestmentTypeId, deleted.RiskRating, deleted.EquityFg, deleted.ConcurrencyId
			,deleted.PolicyBusinessFundId, 'U', @StampDateTime, 0, deleted.Cost
			,deleted.LastTransactionChangeDate, deleted.RegularContributionPercentage, deleted.UpdatedByReplicatedProc, deleted.PortfolioName
			,deleted.ModelPortfolioName, deleted.DFMName, deleted.MigrationReference
		INTO dbo.TPolicyBusinessFundAudit
		(
			 PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity
			,LastUnitChangeDate, CurrentPrice, LastPriceChangeDate, PriceUpdatedByUser
			,FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg, ConcurrencyId
			,PolicyBusinessFundId, StampAction, StampDateTime, StampUser, Cost
			,LastTransactionChangeDate, RegularContributionPercentage, UpdatedByReplicatedProc, PortfolioName
			,ModelPortfolioName, DFMName, MigrationReference
		)
		FROM 
			#TmpEquityUpdateBatch batch 

			JOIN TPolicyBusinessFund tpbf
				ON tpbf.PolicyBusinessId = batch.PolicyBusinessId 

			JOIN fund2..TEquity AS e 
				ON e.EquityId = tpbf.fundId 

			JOIN fund2..TEquityPrice AS ep 
				ON ep.EquityId = e.EquityId

			LEFT JOIN #TmpExRate cr		
				ON cr.SourceCurrency = e.Currency
				AND cr.TargetCurrency = batch.PlanCurrency
			
		WHERE
			batch.RowNo BETWEEN @startRow and @EndRow
		AND tpbf.CurrentUnitQuantity IS NOT NULL
		AND tpbf.CurrentUnitQuantity <> 0
		AND tpbf.FromFeedFg = 1 
		AND tpbf.EquityFg = 1

		SET @StartRow = @EndRow + 1;
		SET @EndRow = @StartRow + @BatchSize - 1;

	END; -- End of Equities batches


	IF OBJECT_ID('tempdb..#TmpEquityUpdateBatch') IS NOT NULL
		DROP TABLE #TmpEquityUpdateBatch

	IF OBJECT_ID('tempdb..#TmpExRate') IS NOT NULL
		DROP TABLE #TmpExRate
		
	SET NOCOUNT OFF
	
GO
