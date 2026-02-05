SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
Modification History (most recent first)
Date        Modifier        Issue       Description
----        ---------       -------     -------------
20211124    Nick Fairway    DEF-6517    wait put in place to wait limit number of parallel instance sof this procedure
20211119    Nick Fairway    DEF-6453    temporary wait put in place to wait until cpu is at a certain threshold
20201217    Nick Fairway    DEF-667     Performance improvement

*/
CREATE PROCEDURE dbo.SpCustomValuationBulkUpdate
@ValScheduleId bigint, @batch bigint = 100, @CurrentUserDate datetime
as
begin
    SET NOCOUNT ON;
	
	EXEC dba.dbo.p_WaitForCPU -- waits for CPU to go below a specific threshold before continuing
		@ConfigMaxCPU	= 'BulkValuationMaxCPU'
	,	@ConfigRetryS	= 'BulkValuationCPURetryS'
	,	@ConfigTimeOutM = 'BulkValuationCPUTimeoutM'
	,	@ConfigDOP		= 'SpCustomValuationBulkUpdateDOP';

	declare @MatchedItems BIGINT,@MatchingMask  BIGINT, @Purchase_RefFundTransactionTypeId BIGINT, @Sale_RefFundTransactionTypeId BIGINT, @TotalItems BIGINT, @ItemId BIGINT, @BulkValuationSystemUser smallint = 111, @UPDATE_PORTALREFERENCE INT = 32768, @UPDATE_PORTFOLIOREFERENCE INT = 16384, @UPDATE_DFMANDMPFLAG INT = 65536
	declare @bvcount real, @printtime sysname, @timekeeper datetime2, @tmprowcount sysname, @ErrorString varchar(Max), @StampDateTime DATETIME2 = GETDATE(), @statsxml xml, @ValScheduleItemId  bigint, @timekeeper2 datetime
	declare @TransactionSubscriptionEnabled bit = 0
	DECLARE @Sale varchar(10) = 'Sale'
	DECLARE @Purchase varchar(10) = 'Purchase'
	DECLARE @RegionalCurrency VARCHAR(3)
        DECLARE @Debug int = 0, @Rowcount int, @Now datetime2, @Duration int;
        DECLARE @TRANCOUNT int = @@TRANCOUNT;

	SELECT @Purchase_RefFundTransactionTypeId = RefFundTransactionTypeId FROM TRefFundTransactionType with (nolock) WHERE Description = @Purchase
	SELECT @Sale_RefFundTransactionTypeId = RefFundTransactionTypeId FROM TRefFundTransactionType with (nolock)  WHERE Description = @Sale
	SELECT @MatchingMask =  MatchingMask FROM TValMatchingCriteria MC with (nolock) INNER JOIN TValSchedule S with (nolock) on MC.ValuationProviderId = S.RefProdProviderid AND S.ValScheduleId = @ValScheduleId
	SELECT @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

	If Object_Id('tempdb..#TValBulkQ') Is Not Null Drop Table #TValBulkQ
	If Object_Id('tempdb..#PlansTobeUpdated') Is Not Null Drop Table #PlansTobeUpdated
	IF OBJECT_ID('tempdb..#FundsToBeSetUnitsToZero') IS NOT NULL DROP TABLE #FundsToBeSetUnitsToZero
	IF OBJECT_ID('tempdb..#FundsTobeUpdated') IS NOT NULL DROP TABLE #FundsTobeUpdated
	IF OBJECT_ID('tempdb..#FundsTobeUpdatedButSubscribedToPriceFeed') IS NOT NULL DROP TABLE #FundsTobeUpdatedButSubscribedToPriceFeed
	IF OBJECT_ID('tempdb..#TPolicyBusinessFundOrderedBy') IS NOT NULL DROP TABLE #TPolicyBusinessFundOrderedBy
	IF OBJECT_ID('tempdb..#NewFundSet') IS NOT NULL DROP TABLE #NewFundSet
	IF OBJECT_ID('tempdb..#NewUnits') IS NOT NULL DROP TABLE #NewUnits
	IF OBJECT_ID('tempdb..#CurrentTxnUnits') IS NOT NULL DROP TABLE #CurrentTxnUnits
	if object_id('tempdb..#tmpCost') is not null drop table #tmpCost
	if object_id('tempdb..#tmpPlanswithAllZeroValueFunds') is not null drop table #tmpPlanswithAllZeroValueFunds
	if object_id('tempdb..#tmpZeroValueFunds') is not null drop table #tmpZeroValueFunds
	if object_id('tempdb..#TmpExRate') is not null drop table #TmpExRate

	create table #TValBulkQ ([CustomerReference] [varchar](100) NULL,[PortfolioReference] [varchar](100) NULL,[CustomerSubType] [varchar](100) NULL,[Title] [varchar](100) NULL,[CustomerFirstName] [varchar](100) NULL,[CustomerLastName] [varchar](100) NULL,[CustomerDoB] [varchar](50) NULL,[CustomerNINumber] [varchar](50) NULL,[ClientAddressLine1] [varchar](255) NULL,[ClientAddressLine2] [varchar](255) NULL,[ClientAddressLine3] [varchar](255) NULL,[ClientAddressLine4] [varchar](255) NULL,[ClientPostCode] [varchar](20) NULL,[AdviserReference] [varchar](100) NULL,[AdviserFirstName] [varchar](100) NULL,[AdviserLastName] [varchar](100) NULL,[AdviserCompanyName] [varchar](255) NULL,[AdviserOfficePostCode] [varchar](20) NULL,[PortfolioId] [varchar](255) NULL,[HoldingId] [varchar](255) NULL,[PortfolioType] [varchar](255) NULL,[Designation] [varchar](255) NULL,[FundProviderName] [varchar](255) NULL,[_FundName] [varchar](255) NULL,[ISIN] [varchar](50) NULL,[MexId] [varchar](50) NULL,[Sedol] [varchar](50) NULL,[FundQuantity] [varchar](50) NULL,[EffectiveDate] [varchar](50) NULL,[Price] [varchar](50) NULL,[FundPriceDate] [varchar](50) NULL,[HoldingValue] [varchar](100) NULL,[Currency] [varchar](50) NULL,[WorkInProgressIndicator] [varchar](10) NULL,[EpicCode] [varchar](50) NULL,[CitiCode] [varchar](50) NULL,[GBPBalance] [varchar](50) NULL,[ForeignBalance] [varchar](50) NULL,[AvailableCash] [varchar](50) NULL,[AccountName] [varchar](255) NULL,[AccountReference] [varchar](255) NULL,[BalanceDate] [varchar](50) NULL,[SubPlanReference] [varchar](255) NULL,[SubPlanType] [varchar](255) NULL,[PolicyProviderName] [varchar](255) NULL,[ProviderFundCode] [varchar](50) NULL,[FundDeleteBreaker] [bit] NULL,[FundUpdateBreaker] [bit] NULL,[PlanMatched] [bit] NULL,[PolicyBusinessId] [bigint] NULL,[FundMatched] [bit] NULL,[PolicyBusinessFundId] [bigint] NULL,[ValuationUpdated] [bit] NULL,[PlanValuationId] [bigint] NULL,[PlanInEligibilityMask] [int] NULL,[PlanUpdateBreaker] [bit] NULL,[CreatedDateTime] [datetime] NULL,[Remarks] [varchar](1000) NULL,[ConcurrencyId] [bigint] NULL,[ValScheduleId] [bigint] NULL,[FormattedPolicyNumber] [varchar](60) NULL,[IndigoClientId] [bigint] NULL,[FundID] [bigint] NULL,[FundTypeID] [bigint] NULL,[CategoryId] [bigint] NULL,[CategoryName] [varchar](255) NULL,[FundUnitPrice] [money] NULL,[Feed] [bit] NULL,[Equity] [bit] NULL, [ValBulkHoldingId] [bigint] NULL,[ValBulkHoldingResultId] [bigint] NULL,[ValScheduleItemId] [bigint] NULL,[FundName] [varchar](255) NULL,PolicyStartDate datetime null, [Qtimestamp] [datetime2](7) NULL,[xflag] [tinyint] NULL,[ModelPortfolioName] [varchar] (2000) null, [DFMName] [varchar] (2000) null )
	create table #tmpZeroValueFunds ([CustomerReference] [varchar](100) NULL,[PortfolioReference] [varchar](100) NULL,[CustomerSubType] [varchar](100) NULL,[Title] [varchar](100) NULL,[CustomerFirstName] [varchar](100) NULL,[CustomerLastName] [varchar](100) NULL,[CustomerDoB] [varchar](50) NULL,[CustomerNINumber] [varchar](50) NULL,[ClientAddressLine1] [varchar](255) NULL,[ClientAddressLine2] [varchar](255) NULL,[ClientAddressLine3] [varchar](255) NULL,[ClientAddressLine4] [varchar](255) NULL,[ClientPostCode] [varchar](20) NULL,[AdviserReference] [varchar](100) NULL,[AdviserFirstName] [varchar](100) NULL,[AdviserLastName] [varchar](100) NULL,[AdviserCompanyName] [varchar](255) NULL,[AdviserOfficePostCode] [varchar](20) NULL,[PortfolioId] [varchar](255) NULL,[HoldingId] [varchar](255) NULL,[PortfolioType] [varchar](255) NULL,[Designation] [varchar](255) NULL,[FundProviderName] [varchar](255) NULL,[_FundName] [varchar](255) NULL,[ISIN] [varchar](50) NULL,[MexId] [varchar](50) NULL,[Sedol] [varchar](50) NULL,[FundQuantity] [varchar](50) NULL,[EffectiveDate] [varchar](50) NULL,[Price] [varchar](50) NULL,[FundPriceDate] [varchar](50) NULL,[HoldingValue] [varchar](100) NULL,[Currency] [varchar](50) NULL,[WorkInProgressIndicator] [varchar](10) NULL,[EpicCode] [varchar](50) NULL,[CitiCode] [varchar](50) NULL,[GBPBalance] [varchar](50) NULL,[ForeignBalance] [varchar](50) NULL,[AvailableCash] [varchar](50) NULL,[AccountName] [varchar](255) NULL,[AccountReference] [varchar](255) NULL,[BalanceDate] [varchar](50) NULL,[SubPlanReference] [varchar](255) NULL,[SubPlanType] [varchar](255) NULL,[PolicyProviderName] [varchar](255) NULL,[ProviderFundCode] [varchar](50) NULL,[FundDeleteBreaker] [bit] NULL,[FundUpdateBreaker] [bit] NULL,[PlanMatched] [bit] NULL,[PolicyBusinessId] [bigint] NULL,[FundMatched] [bit] NULL,[PolicyBusinessFundId] [bigint] NULL,[ValuationUpdated] [bit] NULL,[PlanValuationId] [bigint] NULL,[PlanInEligibilityMask] [int] NULL,[PlanUpdateBreaker] [bit] NULL,[CreatedDateTime] [datetime] NULL,[Remarks] [varchar](1000) NULL,[ConcurrencyId] [bigint] NULL,[ValScheduleId] [bigint] NULL,[FormattedPolicyNumber] [varchar](60) NULL,[IndigoClientId] [bigint] NULL,[FundID] [bigint] NULL,[FundTypeID] [bigint] NULL,[CategoryId] [bigint] NULL,[CategoryName] [varchar](255) NULL,[FundUnitPrice] [money] NULL,[Feed] [bit] NULL,[ValBulkHoldingId] [bigint] NULL,[ValBulkHoldingResultId] [bigint] NULL,[ValScheduleItemId] [bigint] NULL,[FundName] [varchar](255) NULL,PolicyStartDate datetime null, [Qtimestamp] [datetime2](7) NULL,[xflag] [tinyint] NULL,[ModelPortfolioName] [varchar] (2000) null, [DFMName] [varchar] (2000) null)
	create table #PlansTobeUpdated (PolicyBusinessId int primary key, PlanCurrency varchar(3))
	create table #tmpPlanswithAllZeroValueFunds (PolicyBusinessId int null, [CustomerReference] [varchar](100) NULL,[PortfolioReference] [varchar](100) NULL, PlanvaluationId bigint null)
	create table #FundsToBeSetUnitsToZero (PolicyBusinessId int null, PlanCurrency VARCHAR(3) NULL, FundCurrency VARCHAR(3), PolicyBusinessFundId int null, fundId int null, fromFeedFg bit null, EquityFg bit null, units money null, unitPrice money null, unitPriceDate datetime2 null)
	create table #FundsTobeUpdated (PolicyBusinessFundId int primary key)
	create table #FundsTobeUpdatedButSubscribedToPriceFeed (PolicyBusinessFundId int primary key)
	create table #TPolicyBusinessFundOrderedBy (PolicyBusinessFundId int null, PolicyBusinessId int null, FundID int null, CurrentUnitQuantity money null, FromFeedFg bit null, EquityFg bit null, currentPrice money null)
	create table #NewFundSet (PolicyBusinessID int null, FundID int null, Feed bit default 0, Equity bit default 0)
	create table #NewUnits (PolicyBusinessId int null, PolicyBusinessFundId int null, Units money null, UnitPrice money null, policyStartDate datetime2 null)
	create table #CurrentTxnUnits (PolicyBusinessFundId int null, Units money null)
	create table #tmpCost (policybusinessfundid int null, cost money null)
	create table #TmpExRate(SourceCurrency varchar(3), TargetCurrency varchar(3), ExRate DECIMAL(18,10))
	create unique index ix_tmpexrate on #TmpExRate(SourceCurrency,TargetCurrency)

	declare @stats table (sequence int identity, StatsMessage varchar(1000), EffectedRows bigint null, ElapsedSeconds bigint)
	declare @indigoclientid int
	declare @Equities varchar(10) = 'Equities', @EquityTypeId int

    create clustered index CIX_TValBulkQ_ValScheduleItemId_PolicyBusinessId on #TValBulkQ (ValScheduleId, PolicyBusinessId) 
    create nonclustered index IX_TValBulkQ_PolicyBusinessFundId_ValScheduleItemId on #TValBulkQ (PolicyBusinessFundId, ValScheduleId)

	select @printtime  = 'Bulk valuation Parameters | ValScheduleId='+convert(varchar,isnull(@ValScheduleId,0))+' | BatchSize='+convert(varchar,@batch)+' | ProcessingTimeStamp='+convert(varchar(24),@StampDateTime,121)+' |'
	insert into @stats values (@printtime,0,0)

	select @printtime = 'Preparing core database update '+convert(varchar(24),@StampDateTime,121)
	insert into @stats values (@printtime,0,0)
	select @timekeeper = getdate()

	select @bvcount = count(1) from TValBulkQ with (nolock) where xflag = 0 and ValScheduleId = @ValScheduleId

	select @EquityTypeId = RefFundTypeId from Fund2..TRefFundType with (nolock) where FundTypeName = @Equities

	select @ValScheduleItemId = valscheduleitemid from TValScheduleItem with (nolock) where ValScheduleId = @ValScheduleId
	select @indigoclientid  = IndigoClientId from TValSchedule with (nolock) where valscheduleid = @ValScheduleId

    -- Batched
    DECLARE @Loopcounter int = 0
	
    while exists (select top 1  1 from TValBulkQ with (nolock) where xflag = 0 and ValScheduleId = @ValScheduleId and PlanMatched = 1)
	begin
        IF @Debug > 0
        BEGIN
            SET @Loopcounter+=1;
            IF @Loopcounter > 1
            raiserror ('@Loopcounter = %d',1,1,@Loopcounter) with nowait;
        END

		insert #PlansTobeUpdated (PolicyBusinessId, PlanCurrency)
		SELECT DISTINCT top (@batch) 
 			 v.PolicyBusinessId
			,pb.BaseCurrency
		FROM 
			TValBulkQ v with (nolock) 
			JOIN TPolicyBusiness pb with (nolock)
				ON pb.PolicyBusinessId = v.PolicyBusinessId
		WHERE 
			xflag = 0 
		and ValScheduleId = @ValScheduleId 
		and PlanMatched = 1 
		AND PlanUpdateBreaker = 0
		
		insert into @stats values ('PlansToBeUpdated',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		insert #TValBulkQ (CustomerReference,PortfolioReference,CustomerSubType,Title,CustomerFirstName,CustomerLastName,CustomerDoB,CustomerNINumber,ClientAddressLine1,ClientAddressLine2,ClientAddressLine3,ClientAddressLine4,ClientPostCode,AdviserReference,AdviserFirstName,AdviserLastName,AdviserCompanyName,AdviserOfficePostCode,PortfolioId,HoldingId,PortfolioType,Designation,FundProviderName,_FundName,ISIN,MexId,Sedol,FundQuantity,EffectiveDate,Price,FundPriceDate,HoldingValue,Currency,WorkInProgressIndicator,EpicCode,CitiCode,GBPBalance,ForeignBalance,AvailableCash,AccountName,AccountReference,BalanceDate,SubPlanReference,SubPlanType,PolicyProviderName,ProviderFundCode,FundDeleteBreaker,FundUpdateBreaker,PlanMatched,PolicyBusinessId,FundMatched,PolicyBusinessFundId,ValuationUpdated,PlanValuationId,PlanInEligibilityMask,PlanUpdateBreaker,CreatedDateTime,Remarks,ConcurrencyId,ValScheduleId,FormattedPolicyNumber,IndigoClientId,FundID,FundTypeID,CategoryId,CategoryName,FundUnitPrice,Feed,Equity,ValBulkHoldingId,ValBulkHoldingResultId,ValScheduleItemId,FundName,PolicyStartDate,Qtimestamp,xflag, [ModelPortfolioName], [DFMName])
		select A.CustomerReference,A.PortfolioReference,A.CustomerSubType,A.Title,A.CustomerFirstName,A.CustomerLastName,A.CustomerDoB,A.CustomerNINumber,A.ClientAddressLine1,A.ClientAddressLine2,A.ClientAddressLine3,A.ClientAddressLine4,A.ClientPostCode,A.AdviserReference,A.AdviserFirstName,A.AdviserLastName,A.AdviserCompanyName,A.AdviserOfficePostCode,A.PortfolioId,A.HoldingId,A.PortfolioType,A.Designation,A.FundProviderName,A._FundName,A.ISIN,A.MexId,A.Sedol,A.FundQuantity,A.EffectiveDate,A.Price,A.FundPriceDate,A.HoldingValue,A.Currency,A.WorkInProgressIndicator,A.EpicCode,A.CitiCode,A.GBPBalance,A.ForeignBalance,A.AvailableCash,A.AccountName,A.AccountReference,A.BalanceDate,A.SubPlanReference,A.SubPlanType,A.PolicyProviderName,A.ProviderFundCode,A.FundDeleteBreaker,A.FundUpdateBreaker,A.PlanMatched,A.PolicyBusinessId,A.FundMatched,A.PolicyBusinessFundId,A.ValuationUpdated,A.PlanValuationId,A.PlanInEligibilityMask,A.PlanUpdateBreaker,A.CreatedDateTime,A.Remarks,A.ConcurrencyId,A.ValScheduleId,A.FormattedPolicyNumber,A.IndigoClientId,A.FundID,A.FundTypeID,A.CategoryId,A.CategoryName,A.FundUnitPrice,A.Feed,Case when A.FundTypeId = @EquityTypeId then 1 else 0 end, A.ValBulkHoldingId,A.ValBulkHoldingResultId,A.ValScheduleItemId,A.FundName,A.PolicyStartDate,A.Qtimestamp,A.xflag, A.[ModelPortfolioName], A.[DFMName]
		from TValBulkQ A with (nolock)
		join #PlansTobeUpdated B on (A.PolicyBusinessId = B.PolicyBusinessId)
		where A.xflag = 0 and A.ValScheduleId = @ValScheduleId and A.PlanMatched = 1 and CASE WHEN ISNUMERIC(A.FundQuantity)= 1 THEN CAST(A.FundQuantity AS decimal(24, 6)) ELSE 0 END <> 0.000000

		insert into @stats values ('Copying FundLineItemsToBeProcessed',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		insert #tmpZeroValueFunds (CustomerReference,PortfolioReference,CustomerSubType,Title,CustomerFirstName,CustomerLastName,CustomerDoB,CustomerNINumber,ClientAddressLine1,ClientAddressLine2,ClientAddressLine3,ClientAddressLine4,ClientPostCode,AdviserReference,AdviserFirstName,AdviserLastName,AdviserCompanyName,AdviserOfficePostCode,PortfolioId,HoldingId,PortfolioType,Designation,FundProviderName,_FundName,ISIN,MexId,Sedol,FundQuantity,EffectiveDate,Price,FundPriceDate,HoldingValue,Currency,WorkInProgressIndicator,EpicCode,CitiCode,GBPBalance,ForeignBalance,AvailableCash,AccountName,AccountReference,BalanceDate,SubPlanReference,SubPlanType,PolicyProviderName,ProviderFundCode,FundDeleteBreaker,FundUpdateBreaker,PlanMatched,PolicyBusinessId,FundMatched,PolicyBusinessFundId,ValuationUpdated,PlanValuationId,PlanInEligibilityMask,PlanUpdateBreaker,CreatedDateTime,Remarks,ConcurrencyId,ValScheduleId,FormattedPolicyNumber,IndigoClientId,FundID,FundTypeID,CategoryId,CategoryName,FundUnitPrice,Feed,ValBulkHoldingId,ValBulkHoldingResultId,ValScheduleItemId,FundName,PolicyStartDate,Qtimestamp,xflag, [ModelPortfolioName], [DFMName])
		select A.CustomerReference,A.PortfolioReference,A.CustomerSubType,A.Title,A.CustomerFirstName,A.CustomerLastName,A.CustomerDoB,A.CustomerNINumber,A.ClientAddressLine1,A.ClientAddressLine2,A.ClientAddressLine3,A.ClientAddressLine4,A.ClientPostCode,A.AdviserReference,A.AdviserFirstName,A.AdviserLastName,A.AdviserCompanyName,A.AdviserOfficePostCode,A.PortfolioId,A.HoldingId,A.PortfolioType,A.Designation,A.FundProviderName,A._FundName,A.ISIN,A.MexId,A.Sedol,A.FundQuantity,A.EffectiveDate,A.Price,A.FundPriceDate,A.HoldingValue,A.Currency,A.WorkInProgressIndicator,A.EpicCode,A.CitiCode,A.GBPBalance,A.ForeignBalance,A.AvailableCash,A.AccountName,A.AccountReference,A.BalanceDate,A.SubPlanReference,A.SubPlanType,A.PolicyProviderName,A.ProviderFundCode,A.FundDeleteBreaker,A.FundUpdateBreaker,A.PlanMatched,A.PolicyBusinessId,A.FundMatched,A.PolicyBusinessFundId,A.ValuationUpdated,A.PlanValuationId,A.PlanInEligibilityMask,A.PlanUpdateBreaker,A.CreatedDateTime,A.Remarks,A.ConcurrencyId,A.ValScheduleId,A.FormattedPolicyNumber,A.IndigoClientId,A.FundID,A.FundTypeID,A.CategoryId,A.CategoryName,A.FundUnitPrice,A.Feed,A.ValBulkHoldingId,A.ValBulkHoldingResultId,A.ValScheduleItemId,A.FundName,A.PolicyStartDate,A.Qtimestamp,A.xflag, A.[ModelPortfolioName], A.[DFMName]
		from TValBulkQ A with (nolock)
		join #PlansTobeUpdated B on (A.PolicyBusinessId = B.PolicyBusinessId)
		where A.xflag = 0 and A.ValScheduleId = @ValScheduleId and A.PlanMatched = 1 and CASE WHEN ISNUMERIC(A.FundQuantity)= 1 THEN CAST(A.FundQuantity AS decimal(24, 6)) ELSE 0 END = 0.000000

		insert into @stats values ('finding out funds with zero values',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		insert into #tmpPlanswithAllZeroValueFunds(PolicyBusinessId, CustomerReference, PortfolioReference) 
		select distinct t.Policybusinessid, t.CustomerReference, t.PortfolioReference from #tmpZeroValueFunds t left join #TValBulkQ t1 on t.PolicyBusinessId = t1.PolicyBusinessId 
		where t.xflag = 0 and t.ValScheduleId = @ValScheduleId and t.PlanMatched = 1 and t1.PolicyBusinessId is null

		insert into @stats values ('finding out the plans with all zero value funds',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		insert into #TPolicyBusinessFundOrderedBy(PolicyBusinessFundId, PolicyBusinessId, FundId, FromFeedFg, EquityFg, CurrentUnitQuantity, CurrentPrice)
		select PolicyBusinessFundId, PolicyBusinessId, FundId, FromFeedFg, EquityFg, CurrentUnitQuantity, CurrentPrice from
		(
			select PolicyBusinessFundId, fund.PolicyBusinessId, FundId, FromFeedFg, EquityFg, CurrentUnitQuantity, CurrentPrice,
					ROW_NUMBER() Over(Partition by fund.policybusinessid, fundid, FromFeedFg, EquityFg order by policybusinessfundid asc) orderNumber
				from TPolicyBusinessFund fund join #PlansTobeUpdated Plans on fund.PolicyBusinessId = Plans.PolicyBusinessId
		) a where orderNumber = 1

		insert into @stats values ('retrieving only the first fund by policybusinessid and fundid',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		insert #FundsToBeSetUnitsToZero (PolicyBusinessId, PolicyBusinessFundId, PlanCurrency, fundId, fromFeedFg, EquityFg)
		SELECT Fund.PolicyBusinessId, PolicyBusinessFundId, Plans.PlanCurrency, FundId, FromFeedFg, EquityFg
		FROM TPolicyBusinessFund Fund  -- We want to set any (including duplicate fund) to zero unit
		JOIN #PlansTobeUpdated Plans on Plans.PolicyBusinessId = Fund.PolicyBusinessId
		WHERE 1=1
		AND NOT EXISTS (SELECT 1 FROM #TValBulkQ R  WHERE R.PolicyBusinessFundId = Fund.PolicyBusinessfundId and ValScheduleId = @ValScheduleId )
		AND NOT EXISTS (SELECT 1 FROM #TValBulkQ D  WHERE Plans.PolicyBusinessId = D.policybusinessid  and FundDeleteBreaker = 1 and ValScheduleId = @ValScheduleId)
		and Fund.CurrentUnitQuantity <> 0  -- we do not want to update the sold fund again if the currentunitquantity is already set to 0  (? check with Max)

		insert into @stats values ('finding out funds to be set to zero units',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		-- Set the unit price in fund currency 
		UPDATE t 
		SET 
			unitPrice = CASE
							WHEN ISNULL(fup.MidPrice,0) > 0 THEN fup.MidPrice 
							WHEN ISNULL(fup.BidPrice,0) > 0 THEN fup.BidPrice
							ELSE fup.OfferPrice
						 END
			,unitPriceDate = fup.PriceDate
			,FundCurrency = fu.Currency
		FROM 
			#FundsToBeSetUnitsToZero t
			JOIN fund2..TFundUnit fu WITH (NOLOCK)
				ON fu.FundUnitId = t.fundId 
			JOIN fund2..TFundUnitPrice fup WITH (NOLOCK)
				ON fup.FundUnitId = fu.FundUnitId
		WHERE 
			FromFeedFg = 1 
		AND EquityFg = 0

		insert into @stats values ('finding the price from tfundUnitPrice',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		/*the order bid then mid (omission of offer) is to be consistent with a legacy code in the fund price update job - This got to be separately revisited as there could be other places as well - KK*/

		-- Set the equity price and fund currency for equities
		UPDATE t 
		SET 
			unitPrice = CASE
							WHEN ISNULL(ep.Bid,0) > 0 THEN ep.Bid
							ELSE ISNULL(ep.Mid,0)
						 END
			,unitPriceDate = ep.PriceDate
			,FundCurrency = e.Currency
		FROM 
			#FundsToBeSetUnitsToZero t
			JOIN fund2..TEquity e WITH (NOLOCK)
				ON e.EquityId = t.fundId
			JOIN fund2..TEquityPrice ep WITH (NOLOCK)
				ON ep.EquityId = e.EquityId
		WHERE 
			t.FromFeedFg = 1 
		AND t.EquityFg = 1

		insert into @stats values ('finding the price from tequityPrice',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		--NFF - convert current price to plan currency
		update t 
		set 
			 unitPrice = CurrentPrice
			,unitPriceDate = @CurrentUserDate
			,FundCurrency = @RegionalCurrency
		from 
			#FundsToBeSetUnitsToZero t
			Join TNonFeedFund f on t.fundId = f.NonFeedFundId
		where 
			t.fromFeedFg = 0

		insert into @stats values ('finding the price from nonfeedfund',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		-- cache exchange rate conversions that we don;t already have
		;with cte_CcyConversions AS
		(
			SELECT DISTINCT
				 FundCurrency AS SourceCurrency
				,PlanCurrency AS TargetCurrency
			FROM
				#FundsToBeSetUnitsToZero t
			WHERE
				FundCurrency <> PlanCurrency
			AND NOT EXISTS (SELECT 1 FROM #TmpExRate cr
							WHERE cr.SourceCurrency = FundCurrency
							AND cr.TargetCurrency = PlanCurrency)
		)
		INSERT INTO #TmpExRate
		SELECT
			 SourceCurrency
			,TargetCurrency
			,ISNULL(policymanagement.dbo.FnGetCurrencyRate(SourceCurrency,TargetCurrency), 1.0)
		FROM
			cte_CcyConversions

		insert into @stats values ('loading missing rates to exchange rate cache',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()
		
		-- now convert the unit price to plan currency where it is different to fund currency
		update t 
		set 
			 unitPrice = ROUND(unitPrice * ISNULL(cr.ExRate, 1.0), 4)
		from 
			#FundsToBeSetUnitsToZero t
			LEFT JOIN #TmpExRate cr ON cr.SourceCurrency = t.FundCurrency AND cr.TargetCurrency = t.PlanCurrency
		where 
			t.PlanCurrency <> t.FundCurrency

		insert into @stats values ('converting fund prices to plan currency',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		
		update t set t.unitPrice = grp.UnitPrice, unitPriceDate = grp.transactiondate
		from #FundsToBeSetUnitsToZero t
			join (  SELECT txn.policybusinessfundid, txn.unitprice, txn.transactiondate, row_number() 
                        over(partition by txn.policybusinessfundid  order by transactiondate desc) r_number
				    FROM dbo.TPolicyBusinessFundTransaction txn with (nolock) 
                    JOIN #FundsToBeSetUnitsToZero z on txn.PolicyBusinessFundId = z.PolicyBusinessFundId
                    AND txn.TenantId = @indigoclientid) grp
									on t.PolicyBusinessFundId = grp.PolicyBusinessFundId and r_number = 1
		where t.unitPrice is null
		
		insert into @stats values ('finding the price from last tranaction',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		if exists(select 1 from TTransactionSubscriptionCache c with (nolock) join tvalschedule s with (nolock) on
						c.transactionserviceproviderid = s.refprodproviderid and c.indigoclientid = s.indigoclientid
						and c.refgroupid = s.refgroupid and s.ValScheduleId =  @ValScheduleId)
		begin
			set @TransactionSubscriptionEnabled = 1
		end

		if (@TransactionSubscriptionEnabled = 0)
		begin
			update t set units = grp1.totalUnits  --it was decided that we will negate the total in tpolicybusinessfundtransaction
			from #FundsToBeSetUnitsToZero t
				join (select txn.policybusinessfundid, sum(txn.UnitQuantity) totalUnits
								from dbo.TPolicyBusinessFundTransaction txn with (nolock) 
								join #FundsToBeSetUnitsToZero z 
									on txn.TenantId = @IndigoClientId
									and txn.PolicyBusinessFundId = z.PolicyBusinessFundId
								group by txn.policybusinessfundid) grp1
										on t.policybusinessfundid = grp1.PolicyBusinessFundId

			insert into @stats values ('updating the number of units to negate',@@rowcount,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()
		end

		update t set unitPriceDate = @CurrentUserDate
		from #FundsToBeSetUnitsToZero t
		where unitPriceDate is null

		insert into @stats values ('updating any pricedate remains as null',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		insert #FundsTobeUpdated (PolicyBusinessFundId)
		SELECT distinct Fund.PolicyBusinessFundId
		FROM #TPolicyBusinessFundOrderedBy Fund
		JOIN #PlansTobeUpdated Plans ON Plans.PolicyBusinessId = Fund.PolicyBusinessId
		JOIN #TValBulkQ R  ON Fund.PolicyBusinessFundId = R.PolicyBusinessFundId AND FundUpdateBreaker = 0 AND R.ValScheduleId = @ValScheduleId
		insert into @stats values ('FundLineItemsToBeUpdated',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		delete u
			output deleted.PolicyBusinessFundId
			into #FundsTobeUpdatedButSubscribedToPriceFeed (policybusinessfundid)
		from  #FundsTobeUpdated u
			join #TValBulkQ q on u.PolicyBusinessFundId = q.PolicyBusinessFundId
			join #TPolicyBusinessFundOrderedBy t on u.policybusinessfundid = t.policybusinessfundid
		where q.Feed = 1 and t.CurrentUnitQuantity = q.FundQuantity

		insert into @stats values ('remove from FundLineItemsToBeUpdated - feed fund subscribed to price feed and units not changed',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		delete u
			output deleted.PolicyBusinessFundId
			into #FundsTobeUpdatedButSubscribedToPriceFeed (policybusinessfundid)
		from #FundsTobeUpdated u
			join #TValBulkQ q on u.PolicyBusinessFundId = q.PolicyBusinessFundId
			join #TPolicyBusinessFundOrderedBy t on u.policybusinessfundid = t.policybusinessfundid
		where t.CurrentUnitQuantity = q.FundQuantity and t.CurrentPrice = q.FundUnitPrice

		insert into @stats values ('remove from FundLineItemsToBeUpdated - units / price not changed',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		insert #NewFundSet (PolicyBusinessID, FundID, Feed, Equity)
		SELECT R.PolicyBusinessID, R.FundID, R.Feed, R.Equity
		FROM #TValBulkQ R
		JOIN #PlansTobeUpdated Plans on Plans.PolicyBusinessId = R.PolicyBusinessId
		WHERE R.FundUpdateBreaker = 0 AND R.ValScheduleId = @ValScheduleId
		insert into @stats values ('NewFundSet',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		insert into @stats values ('Start core database update',0,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		BEGIN TRANSACTION coredbupdate

		select @timekeeper2 = getdate()

			BEGIN TRY

			update Fund
			set Fund.CurrentUnitQuantity = 0, Fund.Cost = 0, Fund.LastUnitChangeDate = @CurrentUserDate, Fund.CurrentPrice = U.unitPrice,Fund.LastPriceChangeDate = u.unitPriceDate, Fund.PriceUpdatedByUser = 'Electronic Valuation', Fund.ConcurrencyId = Fund.ConcurrencyId + 1
				OUTPUT deleted.Policybusinessid,deleted.FundId,deleted.FundTypeId,deleted.FundName,deleted.CategoryId,deleted.CategoryName,deleted.CurrentUnitQuantity,deleted.LastUnitChangeDate,deleted.CurrentPrice,deleted.LastPriceChangeDate,deleted.PriceUpdatedByUser,deleted.FromFeedFg,deleted.EquityFg,deleted.FundIndigoClientId,deleted.InvestmentTypeId,deleted.RiskRating,deleted.ConcurrencyId,deleted.PolicyBusinessFundId,deleted.Cost,deleted.LastTransactionChangeDate,deleted.UpdatedByReplicatedProc,'U',@StampDateTime, @BulkValuationSystemUser, deleted.ModelPortfolioName, deleted.DFMName
				INTO TPolicyBusinessFundAudit(PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity,LastUnitChangeDate, CurrentPrice, LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, EquityFg, FundIndigoClientId, InvestmentTypeId,RiskRating, ConcurrencyId, PolicyBusinessFundId, Cost, LastTransactionChangeDate, UpdatedByReplicatedProc, StampAction, StampDateTime, StampUser, ModelPortfolioName, DFMName)
			FROM #FundsToBeSetUnitsToZero U
			JOIN TPolicyBusinessFund Fund with (forceseek) ON (FUND.PolicyBusinessFundId = U.PolicyBusinessFundId)
			insert into @stats values ('Update funds to zero units',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()

			UPDATE Fund
			SET Fund.CurrentUnitQuantity = case when (Fund.CurrentUnitQuantity <> R.FundQuantity) then R.FundQuantity else fund.CurrentUnitQuantity end,
				Fund.LastUnitChangeDate = case when (Fund.CurrentUnitQuantity <> R.FundQuantity) then R.EffectiveDate else Fund.LastUnitChangeDate end,
				Fund.CurrentPrice = case when (Fund.FromFeedFg = 0 AND Fund.CurrentPrice <> R.FundUnitPrice) then R.FundUnitPrice else Fund.CurrentPrice end,
				Fund.LastPriceChangeDate =  case when (Fund.FromFeedFg = 0 AND Fund.CurrentPrice <> R.FundUnitPrice) then R.FundPriceDate else Fund.LastPriceChangeDate end,
				Fund.PriceUpdatedByUser = case when (Fund.FromFeedFg = 0 AND Fund.CurrentPrice <> R.FundUnitPrice)  then 'Electronic Valuation' else fund.PriceUpdatedByUser end,
				Fund.ConcurrencyId = Fund.ConcurrencyId + 1, ModelPortfolioName = r.ModelPortfolioName, DFMName = r.DFMName
				OUTPUT deleted.Policybusinessid,deleted.FundId,deleted.FundTypeId,INSERTED.FundName,deleted.CategoryId,deleted.CategoryName,deleted.CurrentUnitQuantity,deleted.LastUnitChangeDate,deleted.CurrentPrice,deleted.LastPriceChangeDate,deleted.PriceUpdatedByUser,deleted.FromFeedFg,deleted.EquityFg,deleted.FundIndigoClientId,deleted.InvestmentTypeId,deleted.RiskRating,deleted.ConcurrencyId,deleted.PolicyBusinessFundId,deleted.Cost,deleted.LastTransactionChangeDate,deleted.UpdatedByReplicatedProc,'U',@StampDateTime,@BulkValuationSystemUser,deleted.ModelPortfolioName,deleted.DFMName
				INTO TPolicyBusinessFundAudit(PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity,LastUnitChangeDate, CurrentPrice, LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, EquityFg, FundIndigoClientId, InvestmentTypeId,RiskRating, ConcurrencyId, PolicyBusinessFundId, Cost, LastTransactionChangeDate, UpdatedByReplicatedProc, StampAction, StampDateTime, StampUser, ModelPortfolioName, DFMName)
			FROM #FundsToBeUpdated U
			JOIN TPolicyBusinessFund Fund WITH (forceseek) ON (FUND.PolicyBusinessFundId = U.PolicyBusinessFundId)
			JOIN #TValBulkQ R ON (Fund.PolicyBusinessId = R.PolicyBusinessId AND Fund.FundId = R.FundId AND fund.FromFeedFg = R.Feed AND fund.EquityFg = R.Equity)
			JOIN #PlansTobeUpdated P ON (R.PolicyBusinessId = P.PolicyBusinessId AND FundUpdateBreaker = 0)

			insert into @stats values ('Update funds',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()

			INSERT TPolicyBusinessFund(PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName,CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice,LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, EquityFg, FundIndigoClientId, InvestmentTypeId, RiskRating, Cost, ConcurrencyId, ModelPortfolioName, DFMName) 
				OUTPUT INSERTED.Policybusinessid,INSERTED.FundId,INSERTED.FundTypeId,INSERTED.FundName,INSERTED.CategoryId,INSERTED.CategoryName,INSERTED.CurrentUnitQuantity,INSERTED.LastUnitChangeDate,INSERTED.CurrentPrice,INSERTED.LastPriceChangeDate,INSERTED.PriceUpdatedByUser,INSERTED.FromFeedFg,INSERTED.EquityFg,INSERTED.FundIndigoClientId,INSERTED.InvestmentTypeId,INSERTED.RiskRating,INSERTED.ConcurrencyId,INSERTED.PolicyBusinessFundId,INSERTED.Cost,INSERTED.LastTransactionChangeDate,INSERTED.UpdatedByReplicatedProc,'C',@StampDateTime, @BulkValuationSystemUser, inserted.ModelPortfolioName, inserted.DFMName
				INTO TPolicyBusinessFundAudit(PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity,LastUnitChangeDate, CurrentPrice, LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, EquityFg, FundIndigoClientId, InvestmentTypeId,RiskRating, ConcurrencyId, PolicyBusinessFundId, Cost, LastTransactionChangeDate, UpdatedByReplicatedProc, StampAction, StampDateTime, StampUser, ModelPortfolioName, DFMName)
			select R.PolicyBusinessID, R.FundId, R.FundTypeId , R.[FundName], R.CategoryId, R.CategoryName, R.FundQuantity, R.EffectiveDate, R.[FundUnitPrice], R.[FundPriceDate], 'Electronic Valuation', R.[Feed], R.[Equity], R.[IndigoClientId],NULL, NULL,R.FundQuantity * R.FundUnitPrice, 1, r.ModelPortfolioName, r.DFMName
			from #TValBulkQ R  
			left join #TPolicyBusinessFundOrderedBy Fund on (Fund.PolicyBusinessId  = R.PolicyBusinessId and Fund.FundId = R.FundId and Fund.FromFeedFg = R.Feed AND Fund.EquityFg = R.Equity)
			left join (select PolicyBusinessFundId from #FundsToBeUpdated
						union
					   select PolicyBusinessFundId from #FundsTobeUpdatedButSubscribedToPriceFeed) U
					on (FUND.PolicyBusinessFundId = U.PolicyBusinessFundId)
			JOIN #PlansTobeUpdated P ON (R.PolicyBusinessId = P.PolicyBusinessId AND FundUpdateBreaker = 0)
			WHERE R.ValScheduleId = @ValScheduleId
			and U.PolicyBusinessFundId is null

			insert into @stats values ('Create funds',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()
          
			IF (@TransactionSubscriptionEnabled = 0)
			BEGIN
				INSERT INTO TPolicyBusinessFundTransaction(PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, Gross, Cost, UnitPrice, UnitQuantity, ConcurrencyId,IsFromTransactionHistory,
															TenantId, PolicyBusinessId, Category1Text, CreatedByUserId, UpdatedByUserId)
				OUTPUT INSERTED.PolicyBusinessFundId, INSERTED.TransactionDate, INSERTED.RefFundTransactionTypeId, INSERTED.Gross, INSERTED.Cost, INSERTED.UnitPrice, INSERTED.UnitQuantity, INSERTED.ConcurrencyId, INSERTED.PolicyBusinessFundTransactionId, 'C', @StampDateTime, @BulkValuationSystemUser, INSERTED.IsFromTransactionHistory
				INTO TPolicyBusinessFundTransactionAudit (PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, Gross, Cost, UnitPrice, UnitQuantity, ConcurrencyId,PolicyBusinessFundTransactionId, StampAction, StampDateTime, StampUser, IsFromTransactionHistory)
				SELECT  
					NU.PolicyBusinessFundId, @CurrentUserDate, 
					case when units > 0 then @Sale_RefFundTransactionTypeId else @Purchase_RefFundTransactionTypeId end,
					0,0,NU.UnitPrice, 0 - ISNULL(NU.Units,0), 1,0,
					@indigoclientid, NU.PolicyBusinessId, 
					case when units > 0 then @Sale else @Purchase end, 
					@BulkValuationSystemUser,
					@BulkValuationSystemUser
				FROM #FundsToBeSetUnitsToZero NU
				WHERE  NU.Units  <> 0

				insert into @stats values ('Create adjusting fund transactions for sold funds',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()

				insert #NewUnits (PolicyBusinessId, PolicyBusinessFundId, Units, UnitPrice, policyStartDate)
				SELECT FUND.PolicyBusinessId, FUND.PolicyBusinessFundId, FUND.CurrentUnitQuantity, CurrentPrice, @StampDateTime 
				FROM TPolicyBusinessFund Fund 
					JOIN #NewFundSet U 
					ON Fund.PolicyBusinessID = U.PolicyBusinessID 
					AND Fund.FundId = U.FundId 
					AND Fund.FromFeedFg = U.Feed 
					AND Fund.EquityFg = U.Equity

				insert #CurrentTxnUnits (PolicyBusinessFundId, Units)
				SELECT Txn.PolicyBusinessFundId PolicyBusinessFundId, SUM(Txn.UnitQuantity) Units 
				FROM TPolicyBusinessFundTransaction Txn 
					JOIN #NewUnits NU 
					ON Txn.TenantId = @IndigoClientId
					AND Txn.PolicyBusinessFundId = NU.PolicyBusinessFundId 
				GROUP BY Txn.PolicyBusinessFundId
                  
				INSERT INTO TPolicyBusinessFundTransaction(PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, Gross, Cost, UnitPrice, UnitQuantity, ConcurrencyId,IsFromTransactionHistory,
						TenantId, PolicyBusinessId, Category1Text, CreatedByUserId, UpdatedByUserId)
				OUTPUT INSERTED.PolicyBusinessFundId, INSERTED.TransactionDate, INSERTED.RefFundTransactionTypeId, INSERTED.Gross, INSERTED.Cost, INSERTED.UnitPrice, INSERTED.UnitQuantity, INSERTED.ConcurrencyId, INSERTED.PolicyBusinessFundTransactionId, 'C', @StampDateTime, @BulkValuationSystemUser, INSERTED.IsFromTransactionHistory
				INTO TPolicyBusinessFundTransactionAudit (PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, Gross, Cost, UnitPrice, UnitQuantity, ConcurrencyId,PolicyBusinessFundTransactionId, StampAction, StampDateTime, StampUser, IsFromTransactionHistory)
				SELECT NU.PolicyBusinessFundId, NU.policyStartDate, 
					CASE WHEN ISNULL(CU.Units,0) >  NU.Units THEN @Sale_RefFundTransactionTypeId ELSE @Purchase_RefFundTransactionTypeId END,
					0,0,NU.UnitPrice, ISNULL(NU.Units,0) - isnull(CU.Units,0), 1,0,
					@indigoclientid, NU.PolicyBusinessId, 
					CASE WHEN ISNULL(CU.Units,0) >  NU.Units THEN @Sale ELSE @Purchase END,
					@BulkValuationSystemUser,
					@BulkValuationSystemUser
				FROM #NewUnits NU LEFT JOIN #CurrentTxnUnits CU ON NU.PolicyBusinessFundId = CU.PolicyBusinessFundId WHERE  NU.Units  <> ISNULL(CU.Units,0)
				insert into @stats values ('Create fund transactions',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()
			END
			ELSE
			BEGIN
				insert into @stats values ('No transactions would be added as the transaction history is enabled for this schedule',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()
			END

			------------------------------------------------------------------------------------------------------------------
			-- Re/Compute Cost for funds
			------------------------------------------------------------------------------------------------------------------
			INSERT #tmpCost (policybusinessfundid, cost)
			SELECT 
				F.PolicyBusinessFundId,
				PolicyManagement.dbo.FnCustomCalculateFundCost(@IndigoClientId, F.PolicyBusinessFundId)
			FROM 
				#FundsTobeUpdated F

			-- Update funds where the cost has changed - Removed outputting into Audit by design (to avoid double entries)
			update fund
			set fund.cost = C.cost
			from 
				tpolicybusinessfund fund 
				join #tmpCost C ON C.policybusinessfundid = fund.PolicyBusinessFundId
			where fund.cost <> C.cost

			insert into @stats values ('Recalculate cost for funds ',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()

			INSERT TPlanValuation (PolicyBusinessId, PlanValue, PlanValueDate, RefPlanValueTypeId, WhoUpdatedValue, WhoUpdatedDateTime, SurrenderTransferValue, ConcurrencyId)
				output 
					inserted.PolicyBusinessId, inserted.PlanValue, inserted.PlanValueDate, inserted.RefPlanValueTypeId, inserted.WhoUpdatedValue, 
					inserted.WhoUpdatedDateTime, inserted.SurrenderTransferValue, inserted.ConcurrencyId, inserted.PlanValuationId, 'C', @StampDateTime, @BulkValuationSystemUser
				into [TPlanValuationAudit]
					(PolicyBusinessId, PlanValue, PlanValueDate, RefPlanValueTypeId, WhoUpdatedValue, WhoUpdatedDateTime, 
					SurrenderTransferValue, ConcurrencyId, PlanValuationId, StampAction, StampDateTime, StampUser)
			SELECT U.PolicyBusinessId, SUM(FundQuantity * FundUnitPrice),  @CurrentUserDate, 2, @BulkValuationSystemUser, @StampDateTime, NULL, 1
			FROM  #PlansTobeUpdated U
			INNER JOIN  #TValBulkQ R ON U.PolicyBusinessId = R.PolicyBusinessID  
			WHERE R.ValScheduleId = @ValScheduleId
			GROUP BY U.PolicyBusinessId
			insert into @stats values ('Creating valuation records',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()

			INSERT TPlanValuation (PolicyBusinessId, PlanValue, PlanValueDate, RefPlanValueTypeId, WhoUpdatedValue, WhoUpdatedDateTime, SurrenderTransferValue, ConcurrencyId)
				output 
					inserted.PolicyBusinessId, inserted.PlanValue, inserted.PlanValueDate, inserted.RefPlanValueTypeId, inserted.WhoUpdatedValue, 
					inserted.WhoUpdatedDateTime, inserted.SurrenderTransferValue, inserted.ConcurrencyId, inserted.PlanValuationId, 'C', @StampDateTime, @BulkValuationSystemUser
				into [TPlanValuationAudit]
					(PolicyBusinessId, PlanValue, PlanValueDate, RefPlanValueTypeId, WhoUpdatedValue, WhoUpdatedDateTime, 
					SurrenderTransferValue, ConcurrencyId, PlanValuationId, StampAction, StampDateTime, StampUser)
			SELECT U.PolicyBusinessId, 0,  @CurrentUserDate, 2, @BulkValuationSystemUser, @StampDateTime, NULL, 1
			FROM  #tmpPlanswithAllZeroValueFunds U
			GROUP BY U.PolicyBusinessId
			insert into @stats values ('Creating valuation records for all zero value funds',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()

			update t set PlanvaluationId =  p.PlanValuationId from #tmpPlanswithAllZeroValueFunds t join TPlanValuation p on t.PolicyBusinessId = p.PolicyBusinessId and p.PlanValueDate = @CurrentUserDate and RefPlanValueTypeId = 2

			--Write back new policybusinessfund ID & Plan Valuation Id
			UPDATE R SET R.PolicyBusinessFundId = Fund.PolicyBusinessFundId
			FROM #TValBulkQ R JOIN TPolicyBusinessFund Fund 
                        ON R.PolicyBusinessId = Fund.PolicyBusinessId  AND Fund.FundId = R.FundId AND Fund.FromFeedFg = R.Feed AND Fund.EquityFg = R.Equity 
                        JOIN #PlansTobeUpdated U ON Fund.PolicyBusinessId = U.PolicyBusinessID 
                        WHERE R.PolicyBusinessFundId IS NULL AND R.ValScheduleId = @ValScheduleId
			
			insert into @stats values ('Retrieve New PolicyBusinessFundId',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()

			UPDATE R SET R.ValuationUpdated = 1, R.PlanValuationId = P.PlanValuationId
			FROM #TValBulkQ R JOIN TPlanvaluation P 
                        ON P.PolicyBusinessId = R.PolicyBusinessId 
                        JOIN #PlansTobeUpdated U ON R.PolicyBusinessId = U.PolicyBusinessId  
                        WHERE P.PlanValueDate = @CurrentUserDate AND R.ValScheduleId = @ValScheduleId
			
			insert into @stats values ('Retrieve New PlanValuationId',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()

			insert into @stats values ('Wrote back the policybusinssfundid and planvaluationid',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()

			--Update the main plan attributes - special requests from providers such as L&G and Cofunds for now
			IF @MatchingMask & @UPDATE_PORTALREFERENCE = @UPDATE_PORTALREFERENCE
			BEGIN
				UPDATE T1 SET T1.PortalReference = MatchedPlans.CustomerReference, T1.SystemPortalReference = MatchedPlans.CustomerReference, T1.ConcurrencyId = T1.ConcurrencyId + 1
				OUTPUT INSERTED.PolicyBusinessId, INSERTED.BandingTemplateId, INSERTED.MigrationRef, INSERTED.PortalReference, INSERTED.ConcurrencyId, INSERTED.PolicyBusinessExtId, INSERTED.IsVisibleToClient, INSERTED.IsVisibilityUpdatedByStatusChange, INSERTED.WhoCreatedUserId,
				 'U', @StampDateTime, @BulkValuationSystemUser, INSERTED.QuoteId
				INTO TPolicyBusinessExtAudit (PolicyBusinessId, BandingTemplateId, MigrationRef, PortalReference, ConcurrencyId, PolicyBusinessExtId, IsVisibleToClient, IsVisibilityUpdatedByStatusChange, WhoCreatedUserId, StampAction, StampDateTime, StampUser, QuoteId)
				FROM TPolicyBusinessExt T1
				JOIN ( 
						SELECT PolicyBusinessId, CustomerReference 
                        FROM #TValBulkQ WHERE ValScheduleId = @ValScheduleId AND PlanMatched = 1 AND  IsNull(CustomerReference,'') <> '' GROUP BY PolicyBusinessId, CustomerReference
						union
						SELECT PolicyBusinessId, CustomerReference 
                        FROM #tmpPlanswithAllZeroValueFunds where IsNull(CustomerReference,'') <> '' GROUP BY PolicyBusinessId, CustomerReference
					  ) MatchedPlans ON T1.PolicyBusinessId = MatchedPlans.PolicyBusinessId AND (COALESCE(T1.PortalReference,'') <> COALESCE(MatchedPlans.CustomerReference,'') OR COALESCE(T1.SystemPortalReference,'') <> COALESCE(MatchedPlans.CustomerReference,''))

				insert into @stats values ('Update PortalReference',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()
			END

			IF @MatchingMask & @UPDATE_PORTFOLIOREFERENCE = @UPDATE_PORTFOLIOREFERENCE
			BEGIN
				UPDATE T1 SET T1.PolicyNumber = MatchedPlans.PortfolioReference, T1.ConcurrencyId = T1.ConcurrencyId + 1
				OUTPUT INSERTED.PolicyDetailId,INSERTED.PolicyNumber,INSERTED.PractitionerId,INSERTED.ReplaceNotes,INSERTED.TnCCoachId,INSERTED.AdviceTypeId,INSERTED.BestAdvicePanelUsedFG, INSERTED.WaiverDefermentPeriod,INSERTED.IndigoClientId,INSERTED.SwitchFG,INSERTED.TotalRegularPremium,INSERTED.TotalLumpSum,INSERTED.MaturityDate,INSERTED.LifeCycleId,INSERTED.PolicyStartDate,INSERTED.PremiumType,INSERTED.AgencyNumber,INSERTED.ProviderAddress,INSERTED.OffPanelFg,INSERTED.BaseCurrency,INSERTED.ExpectedPaymentDate, INSERTED.ProductName,INSERTED.InvestmentTypeId,INSERTED.RiskRating,INSERTED.SequentialRef,INSERTED.ConcurrencyId,INSERTED.PolicyBusinessId,'U',@StampDateTime,@BulkValuationSystemUser
				INTO TPolicyBusinessAudit (PolicyDetailId,PolicyNumber,PractitionerId,ReplaceNotes,TnCCoachId,AdviceTypeId,BestAdvicePanelUsedFG,WaiverDefermentPeriod,IndigoClientId,SwitchFG,TotalRegularPremium,TotalLumpSum,MaturityDate,LifeCycleId,PolicyStartDate,PremiumType,AgencyNumber,ProviderAddress,OffPanelFg,BaseCurrency,ExpectedPaymentDate,ProductName,InvestmentTypeId,RiskRating,SequentialRef,ConcurrencyId,PolicyBusinessId,StampAction,StampDateTime,StampUser)
				FROM TPolicyBusiness T1
				JOIN ( 
						SELECT PolicyBusinessId, PortfolioReference FROM #TValBulkQ WHERE ValScheduleId = @ValScheduleId AND PlanMatched = 1 AND IsNull(PortfolioReference,'') <> '' GROUP BY PolicyBusinessId, PortfolioReference
						union 
						select PolicyBusinessId, PortfolioReference from #tmpPlanswithAllZeroValueFunds where IsNull(PortfolioReference,'') <> '' GROUP BY PolicyBusinessId, PortfolioReference
					  ) MatchedPlans ON T1.PolicyBusinessId = MatchedPlans.PolicyBusinessId AND COALESCE(T1.PolicyNumber,'') <> COALESCE(MatchedPlans.PortfolioReference,'') 
				insert into @stats values ('Update PortfolioReference',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()
			END

			IF @MatchingMask & @UPDATE_DFMANDMPFLAG = @UPDATE_DFMANDMPFLAG
			BEGIN
				If Object_Id('tempdb..#matchedPlansWithDfmAndMp') Is Not Null Drop Table #matchedPlansWithDfmAndMp
				SELECT Distinct PolicyBusinessId, 0 hasDfm, 0 hasMP into #matchedPlansWithDfmAndMp FROM #TValBulkQ WHERE ValScheduleId = @ValScheduleId AND PlanMatched = 1

				update m set hasDfm = 1
				from #matchedPlansWithDfmAndMp m join #TValBulkQ q on m.PolicyBusinessId = q.PolicyBusinessId and len(DFMName) > 0

				update m set hasMP = 1
				from #matchedPlansWithDfmAndMp m join #TValBulkQ q on m.PolicyBusinessId = q.PolicyBusinessId and len(ModelPortfolioName) > 0

				update t set HasDfm = dfm.hasDfm, HasModelPortfolio = dfm.hasMP, ConcurrencyId = ConcurrencyId + 1  
					output inserted.policybusinessid, inserted.bandingtemplateid, inserted.migrationref, inserted.portalreference, inserted.concurrencyid, inserted.policybusinessextid, inserted.isvisibletoclient, inserted.isvisibilityupdatedbystatuschange,'U', @stampdatetime, @bulkvaluationsystemuser, inserted.QuoteId
					into tpolicybusinessextaudit (policybusinessid, bandingtemplateid, migrationref, portalreference, concurrencyid, policybusinessextid, isvisibletoclient, isvisibilityupdatedbystatuschange, stampaction, stampdatetime, stampuser, QuoteId)
				from TPolicyBusinessExt t join #matchedPlansWithDfmAndMp dfm on t.PolicyBusinessId = dfm.PolicyBusinessId
				where (t.hasdfm <> dfm.hasdfm) or (t.hasmodelportfolio <> dfm.hasMP)

				insert into @stats values ('Update HasDfm and HasMp flag',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()
			END

			END TRY

			BEGIN CATCH
				SELECT @ErrorString = 'Number: '+convert(varchar,ERROR_NUMBER())+'Severity:'+convert(varchar,ERROR_SEVERITY())+'State: '+convert(varchar,ERROR_STATE())+'Procedure: '+convert(varchar,ERROR_PROCEDURE())+'Line: '+convert(varchar,ERROR_LINE()) +'Message: '+convert(varchar,ERROR_MESSAGE())
				insert into @stats values (@ErrorString,0,datediff(ms,@timekeeper,getdate()))
				RAISERROR (@ErrorString, 16,1)
				WHILE (@@TRANCOUNT > 0) ROLLBACK TRANSACTION coredbupdate
				goto errorhandler
				END CATCH;

		insert into @stats values ('Transaction Duration',0,datediff(ms,@timekeeper2,getdate()))

		commit TRANSACTION coredbupdate
        IF @Debug > 0
        BEGIN
            SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @@ROWCOUNT, @Now = getdate()
            RAISERROR ('Duration = %d, @Rowcount = %d : Commit', 0,0, @Duration, @Rowcount) WITH NOWAIT;
        END

        UPDATE A 
        SET A.xflag             = 1
        , A.ValuationUpdated    = B.ValuationUpdated
        , A.PlanValuationId     = B.PlanValuationId 
        FROM                dbo.TValBulkQ   A 
        INNER JOIN    #TValBulkQ      B
      --INNER HASH JOIN    #TValBulkQ      B -- Protect against bad stats on TValBulkQ. Can take 10 mins + doing nested loop instead of hash join even with option recompile!
        ON  A.ValScheduleId         = B.ValScheduleId 
        AND A.PolicyBusinessId      = B.PolicyBusinessId 
        AND A.PolicyBusinessFundId  = B.PolicyBusinessFundId 
        AND A.FundId                = B.FundId
		WHERE 
            A.xflag = 0 
        AND A.ValScheduleId = @ValScheduleId 
        AND A.PlanMatched = 1

        IF @Debug > 0
        BEGIN
            SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @@ROWCOUNT, @Now = getdate()
            RAISERROR ('Duration = %d, @Rowcount = %d : Slow Step', 0,0, @Duration, @Rowcount) WITH NOWAIT;
        END

		update A set A.xflag = 1, A.ValuationUpdated =  B.ValuationUpdated, A.PlanValuationId = B.PlanValuationId from TValBulkQ A
		join #tmpZeroValueFunds B on (A.ValScheduleId = B.ValScheduleId and A.PolicyBusinessId = B.PolicyBusinessId and A.PolicyBusinessFundId = B.PolicyBusinessFundId and A.FundId = B.FundId)
		where A.xflag = 0 and A.ValScheduleId = @ValScheduleId and A.PlanMatched = 1
        IF @Debug > 0
        BEGIN
            SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @@ROWCOUNT, @Now = getdate()
            RAISERROR ('Duration = %d, @Rowcount = %d : Other Slow Step', 0,0, @Duration, @Rowcount) WITH NOWAIT;
        END

		insert into @stats values ('Core database update committed',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		truncate table #PlansTobeUpdated
		truncate table #TValBulkQ
		truncate table #FundsToBeSetUnitsToZero
		truncate table #FundsTobeUpdated
		truncate table #TPolicyBusinessFundOrderedBy
		truncate table #NewFundSet
		truncate table #NewUnits
		truncate table #CurrentTxnUnits
		truncate table #tmpCost
		truncate table #tmpZeroValueFunds
		truncate table #tmpPlanswithAllZeroValueFunds
	end

	select @printtime = 'Bulk Valuation items processed/Sec '+convert(varchar,(case when @bvcount = 0 then 1 else @bvcount end) /case when datediff(ss,@StampDateTime,@timekeeper) = 0 then 1 else datediff(ss,@StampDateTime,@timekeeper) end)
	insert into @stats values (@printtime,@bvcount,datediff(ms,@StampDateTime,@timekeeper))

	IF EXISTS(Select top 1 1 From TValBulkSummary BS INNER JOIN TValScheduleItem S with (nolock) ON BS.ValScheduleItemId = S.ValScheduleItemId Where S.ValScheduleId = @ValScheduleId And IsArchived = 0)
	BEGIN
		SELECT  @TotalItems = COUNT(1), @ItemId  = min(ValScheduleItemId) FROM TValBulkQ  WHERE ValScheduleId = @ValScheduleId GROUP BY ValScheduleId 
		SELECT  @MatchedItems = COUNT(1) FROM TValBulkQ WHERE ValScheduleId = @ValScheduleId AND PlanMatched = 1
		UPDATE TValBulkSummary SET TotalItems = @TotalItems, MatchedItems = @MatchedItems, ConcurrencyId = ConcurrencyId + 1
		OUTPUT INSERTED.ValScheduleItemId, INSERTED.IndigoClientId, INSERTED.RefProdProviderId, INSERTED.DocVersionId, INSERTED.FailedItemsToUpload,INSERTED.TotalItems, INSERTED.MatchedItems, INSERTED.IsArchived, INSERTED.ConcurrencyId, INSERTED.ValBulkSummaryId, 'U', @StampDateTime, @BulkValuationSystemUser
		INTO TValBulkSummaryAudit (ValScheduleItemId, IndigoClientId, RefProdProviderId, DocVersionId, FailedItemsToUpload, TotalItems, MatchedItems, IsArchived, ConcurrencyId, ValBulkSummaryId,StampAction, StampDateTime, StampUser)
		WHERE ValScheduleItemId = @ItemId 
	End

	while Exists (select 1 from TValBulkQ A with (nolock) where A.xflag = 1 and A.ValScheduleId = @ValScheduleId and A.PlanMatched = 1)
	begin
		delete top(25000) A
		output deleted.CustomerReference,deleted.PortfolioReference,deleted.CustomerSubType,deleted.Title,deleted.CustomerFirstName,deleted.CustomerLastName,deleted.CustomerDoB,deleted.CustomerNINumber,deleted.ClientAddressLine1,deleted.ClientAddressLine2,deleted.ClientAddressLine3,deleted.ClientAddressLine4,deleted.ClientPostCode,deleted.AdviserReference,deleted.AdviserFirstName,deleted.AdviserLastName,deleted.AdviserCompanyName,deleted.AdviserOfficePostCode,deleted.PortfolioId,deleted.HoldingId,deleted.PortfolioType,deleted.Designation,deleted.FundProviderName,deleted._FundName,deleted.ISIN,deleted.MexId,deleted.Sedol,deleted.FundQuantity,deleted.EffectiveDate,deleted.Price,deleted.FundPriceDate,deleted.HoldingValue,deleted.Currency,deleted.WorkInProgressIndicator,deleted.EpicCode,deleted.CitiCode,deleted.GBPBalance,deleted.ForeignBalance,deleted.AvailableCash,deleted.AccountName,deleted.AccountReference,deleted.BalanceDate,deleted.SubPlanReference,deleted.SubPlanType,deleted.PolicyProviderName,deleted.ProviderFundCode,deleted.FundDeleteBreaker,deleted.FundUpdateBreaker,deleted.PlanMatched,deleted.PolicyBusinessId,deleted.FundMatched,deleted.PolicyBusinessFundId,deleted.ValuationUpdated,deleted.PlanValuationId,deleted.PlanInEligibilityMask,deleted.PlanUpdateBreaker,deleted.CreatedDateTime,deleted.Remarks,deleted.ConcurrencyId,deleted.ValScheduleId,deleted.FormattedPolicyNumber,deleted.IndigoClientId,deleted.FundID,deleted.FundTypeID,deleted.CategoryId,deleted.CategoryName,deleted.FundUnitPrice,deleted.Feed,deleted.ValBulkHoldingId,deleted.ValBulkHoldingResultId,deleted.ValScheduleItemId,deleted.FundName,deleted.PolicyStartDate,@StampDateTime,deleted.xflag, deleted.[ModelPortfolioName], deleted.[DFMName]
		into TValBulkProcessed (CustomerReference,PortfolioReference,CustomerSubType,Title,CustomerFirstName,CustomerLastName,CustomerDoB,CustomerNINumber,ClientAddressLine1,ClientAddressLine2,ClientAddressLine3,ClientAddressLine4,ClientPostCode,AdviserReference,AdviserFirstName,AdviserLastName,AdviserCompanyName,AdviserOfficePostCode,PortfolioId,HoldingId,PortfolioType,Designation,FundProviderName,_FundName,ISIN,MexId,Sedol,FundQuantity,EffectiveDate,Price,FundPriceDate,HoldingValue,Currency,WorkInProgressIndicator,EpicCode,CitiCode,GBPBalance,ForeignBalance,AvailableCash,AccountName,AccountReference,BalanceDate,SubPlanReference,SubPlanType,PolicyProviderName,ProviderFundCode,FundDeleteBreaker,FundUpdateBreaker,PlanMatched,PolicyBusinessId,FundMatched,PolicyBusinessFundId,ValuationUpdated,PlanValuationId,PlanInEligibilityMask,PlanUpdateBreaker,CreatedDateTime,Remarks,ConcurrencyId,ValScheduleId,FormattedPolicyNumber,IndigoClientId,FundID,FundTypeID,CategoryId,CategoryName,FundUnitPrice,Feed,ValBulkHoldingId,ValBulkHoldingResultId,ValScheduleItemId,FundName,PolicyStartDate,Qtimestamp,xflag,[ModelPortfolioName], [DFMName])
		from TValBulkQ A where A.xflag = 1 and A.ValScheduleId = @ValScheduleId and A.PlanMatched = 1
	end

	insert into @stats values ('Archiving processed + matched plans',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	while Exists (select 1 from TValBulkQ A with (nolock) where A.xflag = 0 and A.ValScheduleId = @ValScheduleId and A.PlanMatched = 0)
	begin
		delete top (25000) A
		output deleted.CustomerReference,deleted.PortfolioReference,deleted.CustomerSubType,deleted.Title,deleted.CustomerFirstName,deleted.CustomerLastName,deleted.CustomerDoB,deleted.CustomerNINumber,deleted.ClientAddressLine1,deleted.ClientAddressLine2,deleted.ClientAddressLine3,deleted.ClientAddressLine4,deleted.ClientPostCode,deleted.AdviserReference,deleted.AdviserFirstName,deleted.AdviserLastName,deleted.AdviserCompanyName,deleted.AdviserOfficePostCode,deleted.PortfolioId,deleted.HoldingId,deleted.PortfolioType,deleted.Designation,deleted.FundProviderName,deleted._FundName,deleted.ISIN,deleted.MexId,deleted.Sedol,deleted.FundQuantity,deleted.EffectiveDate,deleted.Price,deleted.FundPriceDate,deleted.HoldingValue,deleted.Currency,deleted.WorkInProgressIndicator,deleted.EpicCode,deleted.CitiCode,deleted.GBPBalance,deleted.ForeignBalance,deleted.AvailableCash,deleted.AccountName,deleted.AccountReference,deleted.BalanceDate,deleted.SubPlanReference,deleted.SubPlanType,deleted.PolicyProviderName,deleted.ProviderFundCode,deleted.FundDeleteBreaker,deleted.FundUpdateBreaker,deleted.PlanMatched,deleted.PolicyBusinessId,deleted.FundMatched,deleted.PolicyBusinessFundId,deleted.ValuationUpdated,deleted.PlanValuationId,deleted.PlanInEligibilityMask,deleted.PlanUpdateBreaker,deleted.CreatedDateTime,deleted.Remarks,deleted.ConcurrencyId,deleted.ValScheduleId,deleted.FormattedPolicyNumber,deleted.IndigoClientId,deleted.FundID,deleted.FundTypeID,deleted.CategoryId,deleted.CategoryName,deleted.FundUnitPrice,deleted.Feed,deleted.ValBulkHoldingId,deleted.ValBulkHoldingResultId,deleted.ValScheduleItemId,deleted.FundName,deleted.PolicyStartDate,@StampDateTime,deleted.xflag, deleted.[ModelPortfolioName], deleted.[DFMName]
		into [TValBulkNotMatched] (CustomerReference,PortfolioReference,CustomerSubType,Title,CustomerFirstName,CustomerLastName,CustomerDoB,CustomerNINumber,ClientAddressLine1,ClientAddressLine2,ClientAddressLine3,ClientAddressLine4,ClientPostCode,AdviserReference,AdviserFirstName,AdviserLastName,AdviserCompanyName,AdviserOfficePostCode,PortfolioId,HoldingId,PortfolioType,Designation,FundProviderName,_FundName,ISIN,MexId,Sedol,FundQuantity,EffectiveDate,Price,FundPriceDate,HoldingValue,Currency,WorkInProgressIndicator,EpicCode,CitiCode,GBPBalance,ForeignBalance,AvailableCash,AccountName,AccountReference,BalanceDate,SubPlanReference,SubPlanType,PolicyProviderName,ProviderFundCode,FundDeleteBreaker,FundUpdateBreaker,PlanMatched,PolicyBusinessId,FundMatched,PolicyBusinessFundId,ValuationUpdated,PlanValuationId,PlanInEligibilityMask,PlanUpdateBreaker,CreatedDateTime,Remarks,ConcurrencyId,ValScheduleId,FormattedPolicyNumber,IndigoClientId,FundID,FundTypeID,CategoryId,CategoryName,FundUnitPrice,Feed,ValBulkHoldingId,ValBulkHoldingResultId,ValScheduleItemId,FundName,PolicyStartDate,Qtimestamp,xflag,[ModelPortfolioName], [DFMName])
		from TValBulkQ A where A.xflag = 0 and A.ValScheduleId = @ValScheduleId and A.PlanMatched = 0
	end

	insert into @stats values ('Archiving processed + non-matched plans',@@ROWCOUNT,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	set @statsxml = (select * from (select StatsMessage,sum(effectedrows) as effectedrows,sum(elapsedseconds) as elapsedseconds,max(sequence) as sequence from @stats group by StatsMessage)  BulkValuationStats for xml auto, type)
	
	insert into TValBulkExecStats values (@ValScheduleId, @ValScheduleItemId, null,null, @StampDateTime,getdate(),null,@statsxml)

	SELECT [Description] = ' Records updated successfully' , [Status] = 1

	return 0

	errorhandler:
	set @statsxml = (select * from (select max(sequence) as sequence,StatsMessage,sum(effectedrows) as effectedrows,sum(elapsedseconds) as elapsedseconds from @stats group by StatsMessage) as BulkValuationStats order by sequence for xml auto, type)
	insert into TValBulkExecStats values (@ValScheduleId, @ValScheduleItemId, null,null, @StampDateTime,getdate(),null,@statsxml)
	SELECT [Description] = @ErrorString , [Status] = 0
	return 1
end
GO
