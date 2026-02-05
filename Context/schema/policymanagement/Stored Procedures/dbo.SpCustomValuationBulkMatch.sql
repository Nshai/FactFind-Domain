USE PolicyManagement
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue       Description
----        ---------       -------     -------------
20211124    Nick Fairway    DEF-6517    wait put in place to wait limit number of parallel instance sof this procedure
20211119    Nick Fairway    DEF-6453    temporary wait put in place to wait until cpu is at a certain threshold
20201214    Nick Fairway    DEF-667     Performance issue:  removed redundant columns and use table variable @TmpTValParseBulkHoldingindex. Replace dynamic sql

*/
CREATE PROCEDURE dbo.SpCustomValuationBulkMatch
@ValScheduleId bigint
AS
begin

	EXEC dba.dbo.p_WaitForCPU -- waits for CPU to go below a specific threshold before continuing
		@ConfigMaxCPU	= 'BulkValuationMaxCPU'
	,	@ConfigRetryS	= 'BulkValuationCPURetryS'
	,	@ConfigTimeOutM = 'BulkValuationCPUTimeoutM'
	,	@ConfigDOP		= 'SpCustomValuationBulkMatchDOP';

	DECLARE @Debug int = 0, @Rowcount int, @Now datetime2 = getdate(), @Duration int=0;
	set nocount on
	SET XACT_ABORT ON
	set transaction isolation level read uncommitted

	--If Object_Id('tempdb..@TmpTValParseBulkHolding') Is Not Null Drop Table @TmpTValParseBulkHolding
	IF OBJECT_ID('tempdb..#Holdings') IS NOT NULL DROP TABLE #Holdings
	if object_id('tempdb..#duplicatefunds') is not null drop table #duplicatefunds
	if object_id('tempdb..#GroupedFunds') is not null drop table #GroupedFunds
	if object_id('tempdb..#TValPotentialPlan') is not null drop table #TValPotentialPlan
	if object_id('tempdb..#TmpExRate') IS NOT NULL DROP TABLE #TmpExRate

	CREATE TABLE #duplicatefunds (ValBulkHoldingId bigint null)
	CREATE TABLE #GroupedFunds (ValBulkHoldingId bigint null, PolicyBusinessId bigint null, FundId bigint null, Equity BIT DEFAULT 0, Feed BIT DEFAULT 0, FundQuantity Money null)
	CREATE TABLE #Holdings (ValBulkHoldingId BIGINT, IndigoClientId BIGINT, PolicyBusinessId BIGINT, PlanCurrency VARCHAR(3), PolicyBusinessFundId BIGINT DEFAULT NULL,FundId BIGINT DEFAULT NULL, FundName VARCHAR(255), Quantity VARCHAR (50), UnitPrice MONEY, PlanUnitPrice MONEY, RegionalUnitPrice MONEY, PriceDate DATETIME,  UnitCurrency VARCHAR(3), [FundTypeId] BIGINT,[CategoryId] BIGINT, [CategoryName] VARCHAR(255), [Feed] BIT DEFAULT 0, [Equity] BIT DEFAULT 0, Sedol varchar (50) DEFAULT NULL, MexId VARCHAR (50) DEFAULT NULL,  ISIN varchar (50) DEFAULT NULL, EpicCode varchar (50) DEFAULT NULL, CitiCode VARCHAR (50)  DEFAULT NULL, ProviderFundCode VARCHAR (50)  DEFAULT NULL, PolicyProviderId int NULL, sequentialRef varchar(50) NULL)
	-- NF Do we really need all these 80 columns - slow inserts - slimmed it down to 56 cols
    DECLARE  @TmpTValParseBulkHolding TABLE(
     [CustomerReference] [varchar](100) NULL,[PortfolioReference] [varchar](100) NULL, [FormattedPortfolioReference] [varchar](100) NULL
    ,[CustomerFirstName] [varchar](100) NULL,[CustomerLastName] [varchar](100) NULL
    ,[CustomerDoB] [varchar](50) NULL,[CustomerNINumber] [varchar](50) NULL
    ,[ClientPostCode] [varchar](20) NULL
    ,[AdviserFirstName] [varchar](100) NULL,[AdviserLastName] [varchar](100) NULL
    ,[PortfolioType] [varchar](255) NULL
    ,[_FundName] [varchar](255) NULL,[ISIN] [varchar](50) NULL,[MexId] [varchar](50) NULL,[Sedol] [varchar](50) NULL
    ,[FundQuantity] [varchar](50) NULL,[EffectiveDate] [varchar](50) NULL,[Price] [varchar](50) NULL,[FundPriceDate] varchar(50) NULL
    ,[Currency] [varchar](50) NULL
    ,[EpicCode] [varchar](50) NULL,[CitiCode] [varchar](50) NULL
    ,[PolicyProviderName] [varchar] (255) NULL
    ,[ProviderFundCode] [varchar] (50) NULL
    ,[FundDeleteBreaker] [bit] NULL,[FundUpdateBreaker] [bit] NULL
    ,[PlanMatched] [bit] NULL,[PolicyBusinessId] [bigint] NULL
    ,[FundMatched] [bit] NULL,[PolicyBusinessFundId] [bigint] NULL,[ValuationUpdated] [bit] NULL,[PlanValuationId] [bigint] NULL,[PlanInEligibilityMask] [int] NULL
    ,[PlanUpdateBreaker] [bit] NULL
    ,[CreatedDateTime] [datetime2] NULL,[Remarks] [varchar](1000) NULL,[ConcurrencyId] [bigint] NULL,[ValScheduleId] bigint NULL
    ,[FormattedPolicyNumber] [varchar](60) NULL,[IndigoClientId] [bigint] null,[FundID] bigint null,[FundTypeID] bigint null,[CategoryId] bigint null
    ,[CategoryName] varchar(255) null,[FundUnitPrice] money null,[Feed] bit null,[ValBulkHoldingId] bigint NOT NULL IDENTITY(1, 1)
    ,[ValScheduleItemId] bigint NULL INDEX IX_ValScheduleItemId
    ,[FundName] [varchar](255) NULL,[PolicyStartDate] [datetime] NULL, CRMContactId bigint null,PractitionerId bigint null,IsLatestFG tinyint null,Status varchar(1000)
    , [ModelPortfolioName] [varchar] (2000) null, [DFMName] [varchar] (2000) null
    )
	CREATE TABLE #TValPotentialPlan ([ValuationProviderId] [bigint] NULL,[PolicyProviderId] [bigint] NULL,[IndigoClientId] [bigint] NULL,[PolicyBusinessId] [bigint] NULL
    ,[PolicyDetailId] [bigint] NULL,[PolicyNumber] [varchar](50) NULL,[FormattedPolicyNumber] [varchar](60) NULL,[PortalReference] [varchar](50) NULL
    ,[FormattedPortalReference] [varchar](60) NULL,[AgencyNumber] [varchar](50) NULL,[RefPlanType2ProdSubTypeId] [bigint] NULL,[ProviderPlanType] [varchar](255) NULL
    ,[NINumber] [varchar](50) NULL,[DOB] [datetime] NULL,[LastName] [varchar](255) NULL,[Postcode] [varchar](20) NULL,[PolicyStatusId] [bigint] NULL
    ,[PolicyStartDate] [datetime] NULL,[PolicyOwnerCRMContactID] [bigint] NULL,[SellingAdviserCRMContactID] [bigint] NULL,[SellingAdviserStatus] [varchar](50) NULL
    ,[ServicingAdviserCRMContactID] [bigint] NULL,[ServicingAdviserStatus] [varchar](50) NULL,[EligibilityMask] [int] NULL,[EligibilityMaskRequiresUpdating] [bit] NULL
    ,[ConcurrencyId] [bigint] NULL,[PolicyProviderName] [varchar](255) NULL,[ExtendValuationsByServicingAdviser] [bit] NULL, SequentialRef varchar(50) null) 
	CREATE TABLE #TmpExRate( SourceCurrency VARCHAR(3), TargetCurrency VARCHAR(3), ExRate DECIMAL(18,10))
	CREATE UNIQUE INDEX ix_tmpexrate on #TmpExRate(SourceCurrency,TargetCurrency)

	DECLARE @stats table (sequence smallint identity, StatsMessage varchar(1000), EffectedRows bigint null, ElapsedSeconds bigint)

	DECLARE @execErrDescription VARCHAR(MAX) = '', @StampDateTime DATETIME2 = GETDATE()
	declare @MatchingMask BIGINT, @ValuationProviderId BIGINT

    --normalization masks
    declare @CLEANUP_LEADINGZEROS_PLANNUMBER TINYINT = 1, @CLEANUP_SPACE_PLANNUMBER TINYINT = 2

    --plan matching rule masks
	declare @MATCHING_PLANNUMBER TINYINT = 16, @EX_PORREF_AS_PLANTYPE TINYINT = 64, @EX_COFUND INT = 1024, @EX_IOTEMPLATE INT = 2048

	DECLARE @BulkHoldingInEligibilityMask BIGINT,@INELIGIBLE_GROUPING TINYINT = 2, @FundTypeId BIGINT, @UnknowFundTypeName varchar(10) = 'Unknown', @Purchase_RefFundTransactionTypeId BIGINT,@Sale_RefFundTransactionTypeId BIGINT,@UPDATE_PORTFOLIOREFERENCE INT = 16384,@UPDATE_PORTALREFERENCE INT = 32768, @ValScheduleItemId bigint, @IndigoClientId bigint, @StampUser smallint = 111,  @EligibilityMask BIGINT,@BulkManualTemplate BIGINT
	declare @Equities varchar(10) = 'Equities', @EquityTypeId int, @EquityTypeName varchar(255) = ''
	DECLARE @printtime sysname, @sqltext0 nvarchar(4000)='', @timekeeper datetime, @bvcount real, @UpdatedFg tinyint = 1, @statsxml xml
	DECLARE @RegionalCurrency VARCHAR(3)

	select @printtime = 'Bulk valuation process started: '+convert(varchar(30),@StampDateTime)
	insert into @stats values (@printtime,null,0)
	select @timekeeper = getdate()

	SELECT @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

	SELECT @ValScheduleItemId = Si.ValScheduleItemId, @IndigoClientId = S.IndigoClientId, @ValuationProviderId = S.RefProdProviderId,@EligibilityMask = EligibilityMask, @MatchingMask =  MatchingMask 
	FROM tValschedule  s 
	JOIN tvalscheduleitem si on s.valscheduleid=si.valscheduleid
	JOIN tvalbulkconfig bc on s.RefProdProviderId = bc.RefProdProviderId
	JOIN TValMatchingCriteria MC on MC.ValuationProviderId = S.RefProdProviderid
	JOIN TValEligibilityCriteria EC on EC.ValuationProviderId = S.RefProdProviderid
	WHERE SI.valscheduleid = @ValScheduleId
						
	SELECT @BulkManualTemplate = rp.RefProdProviderId from TRefProdProvider rp join CRM..tcrmcontact c on rp.crmcontactid = c.CRMContactId where c.Corporatename like 'Bulk Manual Template'

    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @@ROWCOUNT, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : Before Insert', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END
	--Import
    insert @TmpTValParseBulkHolding (CustomerReference,PortfolioReference,FormattedPortfolioReference, PortfolioType,CustomerFirstName,CustomerLastName
    ,CustomerDoB,CustomerNINumber,ClientPostCode,AdviserFirstName,AdviserLastName,_FundName,ISIN,EpicCode,MexId,Sedol,FundQuantity,EffectiveDate,Price,FundPriceDate
    ,Currency,CitiCode,ProviderFundCode,ConcurrencyId,	ValScheduleId,ValScheduleItemId, IndigoClientId
    , PolicyBusinessId, PlanMatched, FundMatched, PolicyBusinessFundId
    , FundDeleteBreaker, FundUpdateBreaker, ValuationUpdated, PlanValuationId, PlanInEligibilityMask, Remarks, PlanUpdateBreaker, CRMContactId, PractitionerId, IsLatestFG
    , Status, PolicyProviderName, CreatedDateTime, [ModelPortfolioName], [DFMName])

    SELECT coalesce(CustomerReference,'') ,PortfolioReference,PortfolioReference, PortfolioType,CustomerFirstName,CustomerLastName
    ,CustomerDoB,CustomerNINumber,CustomerPostCode,AdviserFirstName,AdviserLastName,FundName,ISIN,EpicCode,MexId,Sedol,FundQuantity,EffectiveDate,Price,FundPriceDate
    ,Currency,CitiCode,ProviderFundCode,1,ValScheduleId, @ValScheduleItemId, @IndigoClientId
    , 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 0, '', PolicyProviderName, CONVERT(VARCHAR,@StampDateTime, 126) 
    , [ModelPortfolioName], [DFMName] 
    FROM dbo.TValBulkQStage 
    WHERE ValScheduleId = @ValScheduleId
	select @bvcount = @@rowcount

    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @bvcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : insert @TmpTValParseBulkHolding', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END
	insert into @stats values ('Copying imported data - Completed',null,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	select @printtime = 'Line Items to process: '+convert(varchar,@bvcount)
	insert into @stats values (@printtime,@bvcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	FORMATTINGPROVIDERDATA:

	if (select count(1) from @TmpTValParseBulkHolding) = 0 
	begin
		SELECT @execErrDescription = 'Error!! - File Integrity Check Failed [003] - No Valid Records to be processed in the input file - Process Terminates.  Please check the file!'
		insert into @stats values (@execErrDescription,0,datediff(ms,@timekeeper,getdate()))
		goto errorhandling
	end

	insert into @stats values ('Start Plan Matching',null,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	if (@BulkManualTemplate = @ValuationProviderId)
	begin
        -- We should match BMT by PolicyNumber intead of FormattedPolicyNumber because FormattedPolicyNumber has value formatted by MatchingCriteria for specific provider.
		insert #TValPotentialPlan (ValuationProviderId,PolicyProviderId,IndigoClientId,PolicyBusinessId,PolicyDetailId,PolicyNumber,FormattedPolicyNumber,PortalReference,FormattedPortalReference,AgencyNumber,RefPlanType2ProdSubTypeId,ProviderPlanType,NINumber,DOB,LastName,Postcode,PolicyStatusId,PolicyStartDate,PolicyOwnerCRMContactID,SellingAdviserCRMContactID,SellingAdviserStatus,ServicingAdviserCRMContactID,ServicingAdviserStatus,EligibilityMask,EligibilityMaskRequiresUpdating,ConcurrencyId,PolicyProviderName,ExtendValuationsByServicingAdviser, SequentialRef)
		select distinct pp.ValuationProviderId,PolicyProviderId,IndigoClientId, pp.PolicyBusinessId,PolicyDetailId,PolicyNumber, PolicyNumber,PortalReference,LTRIM(COALESCE(FormattedPortalReference,'')),AgencyNumber,RefPlanType2ProdSubTypeId,ProviderPlanType,NINumber,pp.DOB,pp.LastName,pp.Postcode,PolicyStatusId,PolicyStartDate,PolicyOwnerCRMContactID,SellingAdviserCRMContactID,SellingAdviserStatus,ServicingAdviserCRMContactID,ServicingAdviserStatus,pp.EligibilityMask,pp.EligibilityMaskRequiresUpdating,pp.ConcurrencyId,PolicyProviderName,ExtendValuationsByServicingAdviser, SequentialRef
		from Tvalpotentialplan pp
			join TValScheduledPlan sp ON pp.PolicyBusinessId = sp.PolicyBusinessId
			join CRM..TCRMContact c WITH (NOLOCK) on pp.PolicyOwnerCRMContactID = c.CRMContactId
		where pp.IndigoClientId = @IndigoClientId and sp.ValScheduleId = @ValScheduleId and sp.Status = 1 and c.IsDeleted = 0
	end
	else
	begin
		insert #TValPotentialPlan (ValuationProviderId,PolicyProviderId,IndigoClientId,PolicyBusinessId,PolicyDetailId,PolicyNumber,FormattedPolicyNumber,PortalReference,FormattedPortalReference,AgencyNumber,RefPlanType2ProdSubTypeId,ProviderPlanType,NINumber,DOB,LastName,Postcode,PolicyStatusId,PolicyStartDate,PolicyOwnerCRMContactID,SellingAdviserCRMContactID,SellingAdviserStatus,ServicingAdviserCRMContactID,ServicingAdviserStatus,EligibilityMask,EligibilityMaskRequiresUpdating,ConcurrencyId,PolicyProviderName,ExtendValuationsByServicingAdviser, SequentialRef)
		select distinct pp.ValuationProviderId,PolicyProviderId,IndigoClientId,pp.PolicyBusinessId,PolicyDetailId,PolicyNumber,LTRIM(COALESCE(FormattedPolicyNumber,'')),PortalReference,LTRIM(COALESCE(FormattedPortalReference,'')),AgencyNumber,RefPlanType2ProdSubTypeId,ProviderPlanType,NINumber,pp.DOB,pp.LastName,pp.Postcode,PolicyStatusId,PolicyStartDate,PolicyOwnerCRMContactID,SellingAdviserCRMContactID,SellingAdviserStatus,ServicingAdviserCRMContactID,ServicingAdviserStatus,pp.EligibilityMask,pp.EligibilityMaskRequiresUpdating,pp.ConcurrencyId,PolicyProviderName,ExtendValuationsByServicingAdviser, SequentialRef
		from Tvalpotentialplan pp
			join TValScheduledPlan sp ON pp.PolicyBusinessId = sp.PolicyBusinessId
			join CRM..TCRMContact c WITH (NOLOCK) on pp.PolicyOwnerCRMContactID = c.CRMContactId
		where pp.IndigoClientId = @IndigoClientId and pp.ValuationProviderId = @ValuationProviderId and sp.ValScheduleId = @ValScheduleId and sp.Status = 1 and c.IsDeleted = 0
    end

    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @Rowcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : Before Updates', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END
    insert into @stats values ('Copying Tvalpotentialplan data',null,datediff(ms,@timekeeper,getdate()))
    select @timekeeper = getdate()

	IF @MatchingMask & @CLEANUP_LEADINGZEROS_PLANNUMBER = @CLEANUP_LEADINGZEROS_PLANNUMBER
	BEGIN
		UPDATE T
		SET T.FormattedPortfolioReference = RTRIM(SUBSTRING( LTRIM(T.PortfolioReference), PATINDEX('%[^0]%',LTRIM(T.PortfolioReference)),LEN(LTRIM(T.PortfolioReference)) ) )   
		FROM @TmpTValParseBulkHolding T 
		WHERE T.ValScheduleId = @ValScheduleId

        insert into @stats values ('CLEANUP_LEADINGZEROS_PLANNUMBER', @@rowcount, datediff(ms, @timekeeper, getdate()))
	    select @timekeeper = getdate()
	END	

	IF @MatchingMask & @CLEANUP_SPACE_PLANNUMBER = @CLEANUP_SPACE_PLANNUMBER
	BEGIN
		UPDATE T
		SET FormattedPortfolioReference = REPLACE(PortfolioReference, ' ', '')  
		FROM @TmpTValParseBulkHolding T 
		WHERE T.ValScheduleId = @ValScheduleId

        insert into @stats values ('CLEANUP_SPACE_PLANNUMBER', @@rowcount, datediff(ms, @timekeeper, getdate()))
	    select @timekeeper = getdate()
	END	

    IF @MatchingMask & @EX_PORREF_AS_PLANTYPE = @EX_PORREF_AS_PLANTYPE
	BEGIN

		UPDATE T SET [PlanMatched] = 1, [PolicyBusinessId] = pp.PolicyBusinessId, PolicyStartDate = PP.PolicyStartDate
                , T.Remarks = COALESCE(T.Remarks,'') + '>' + CONVERT(VARCHAR,@MatchingMask)
		FROM @TmpTValParseBulkHolding T
				JOIN #TValPotentialPlan PP ON PP.FormattedPolicyNumber = T.[FormattedPortfolioReference] AND PP.FormattedPortalReference = T.PortfolioType

		insert into @stats values ('EX_PORREF_AS_PLANTYPE',null,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

	END
	ELSE IF @MatchingMask & @EX_IOTEMPLATE = @EX_IOTEMPLATE
	BEGIN
        UPDATE T
        SET [PlanMatched] = 1, [PolicyBusinessId] = pp.PolicyBusinessId, PolicyStartDate = PP.PolicyStartDate
        , T.Remarks = COALESCE(T.Remarks,'') + '>' + CONVERT(VARCHAR,@MatchingMask)
        FROM @TmpTValParseBulkHolding T
            JOIN #TValPotentialPlan PP on PP.FormattedPolicyNumber = T.[FormattedPortfolioReference] AND PP.FormattedPortalReference = T.CustomerReference 
            AND PP.PolicyProviderName = T.PolicyProviderName

        insert into @stats values ('EX_IOTEMPLATE', @@rowcount, datediff(ms, @timekeeper, getdate()))
        select @timekeeper = getdate()
	END
	ELSE IF @MatchingMask & @EX_COFUND = @EX_COFUND
	BEGIN
		
		--existing plan, new customer (match only on policy number when portal ref is empty)
		update T
			set [PlanMatched] = 1, [PolicyBusinessId] = pp.PolicyBusinessId, PolicyStartDate = PP.PolicyStartDate
                        , T.Remarks = COALESCE(T.Remarks,'') + '>' + CONVERT(VARCHAR,@MatchingMask)
				from
				@TmpTValParseBulkHolding T
					JOIN #TValPotentialPlan PP ON PP.FormattedPolicyNumber = T.[FormattedPortfolioReference]
				where PP.FormattedPortalReference = ''
		insert into @stats values ('MATCHING_ADDITIONAL_COFUNDRULES-PolicyRef',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()


		--existing plan, new customer (match on policy number and portal ref)
		update t set [PlanMatched] = 1, [PolicyBusinessId] = pp.PolicyBusinessId, PolicyStartDate = PP.PolicyStartDate
                , T.Remarks = COALESCE(T.Remarks,'') + '>' + CONVERT(VARCHAR,@MatchingMask)
				from
					@TmpTValParseBulkHolding T
						JOIN #TValPotentialPlan PP ON PP.FormattedPolicyNumber = T.[FormattedPortfolioReference] and PP.FormattedPortalReference = T.CustomerReference
				where T.PlanMatched = 0 AND PP.FormattedPortalReference <> ''
		insert into @stats values ('MATCHING_ADDITIONAL_COFUNDRULES-CustomerRefAndPolicyRef',@@rowcount,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

		--existing customer, new plan (plan type)
		update T
			set [PlanMatched] = 1, [PolicyBusinessId] = sq.PolicyBusinessId, PolicyStartDate = sq.PolicyStartDate
            , T.Remarks = COALESCE(T.Remarks,'') + '>' + CONVERT(VARCHAR,@MatchingMask)
				from
				@TmpTValParseBulkHolding T join
					(select  formattedportalreference, vg.providerplantypename, pp.PolicyBusinessId, pp.PolicyStartDate from #TValPotentialPlan PP
							join TRefPlanType2ProdSubType RP  ON RP.RefPlanType2ProdSubTypeId = PP.RefPlanType2ProdSubTypeId
							left join TValGating VG ON RP.RefPlanTypeId = VG.RefPlanTypeId AND ISNULL(RP.ProdSubTypeId,'') = ISNULL(VG.ProdSubTypeId,'')
						where PP.FormattedPolicyNumber = '') sq
						on T.CustomerReference = sq.formattedportalreference AND sq.ProviderPlanTypeName = T.PortfolioType
				where T.PlanMatched = 0
			insert into @stats values ('MATCHING_ADDITIONAL_COFUNDRULES-CustomerRefAndPortfolioType',@@rowcount,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()

		--new plan (plan type), new customer (ni number)
		update T
			SET [PlanMatched] = 1, [PolicyBusinessId] = sq.PolicyBusinessId, PolicyStartDate = sq.PolicyStartDate
                , T.Remarks = COALESCE(T.Remarks,'') + '>' + CONVERT(VARCHAR,@MatchingMask)
				FROM
				@TmpTValParseBulkHolding T join
					(select replace(person.NINumber ,'-','') NINumber,  vg.ProviderPlanTypeName, pp.PolicyBusinessId, pp.PolicyStartDate from #TValPotentialPlan PP
						join CRM..TCRMContact Contact  On PP.PolicyOwnerCRMContactID = Contact.CRMContactId
						join CRM..TPerson Person  On contact.PersonId = Person.PersonId
						join TRefPlanType2ProdSubType RP ON RP.RefPlanType2ProdSubTypeId = PP.RefPlanType2ProdSubTypeId
						left join TValGating VG ON RP.RefPlanTypeId = VG.RefPlanTypeId AND ISNULL(RP.ProdSubTypeId,'') = ISNULL(VG.ProdSubTypeId,'')
						where PP.FormattedPolicyNumber = '' ) sq
						on replace(T.CustomerNINumber,'-','') = sq.NINumber AND sq.ProviderPlanTypeName = T.PortfolioType
				WHERE T.PlanMatched = 0
			insert into @stats values ('MATCHING_ADDITIONAL_COFUNDRULES-NI',@@rowcount,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()

		--new plan (plan type), new customer (dob, lastname, postcode)
		update T
			SET [PlanMatched] = 1, [PolicyBusinessId] = sq.PolicyBusinessId, PolicyStartDate = sq.PolicyStartDate
                        , T.Remarks = COALESCE(T.Remarks,'') + '>' + CONVERT(VARCHAR,@MatchingMask) 
				FROM 
				@TmpTValParseBulkHolding T join
					(select PERSON.DOB, PERSON.LastName,  AddStore.Postcode, VG.ProviderPlanTypeName, pp.PolicyBusinessId, pp.PolicyStartDate from #TValPotentialPlan PP
						join CRM..TCRMContact Contact  On PP.PolicyOwnerCRMContactID = Contact.CRMContactId
						join CRM..TPerson Person  On contact.PersonId = Person.PersonId
						join CRM..TAddress Addres  On Addres.CRMContactId = Contact.CRMContactId
						join CRM..TAddressStore AddStore  On Addres.AddressStoreId = AddStore.AddressStoreId
						join TRefPlanType2ProdSubType RP ON RP.RefPlanType2ProdSubTypeId = PP.RefPlanType2ProdSubTypeId
						left join TValGating VG ON RP.RefPlanTypeId = VG.RefPlanTypeId AND ISNULL(RP.ProdSubTypeId,'') = ISNULL(VG.ProdSubTypeId,'')
					where PP.FormattedPolicyNumber = '') sq
					on sq.DOB = T.CustomerDoB AND sq.LastName = T.CustomerLastName AND sq.Postcode = T.ClientPostCode AND sq.ProviderPlanTypeName = T.PortfolioType
				WHERE T.PlanMatched = 0

			insert into @stats values ('MATCHING_ADDITIONAL_COFUNDRULES-PostCode',@@rowcount,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()
	END
	ELSE
	BEGIN        
		update T set [PlanMatched] = 1, [PolicyBusinessId] = pp.PolicyBusinessId, PolicyStartDate = PP.PolicyStartDate, T.Remarks = COALESCE(T.Remarks,'') + '>' + CONVERT(VARCHAR,@MatchingMask)
		from
			@TmpTValParseBulkHolding T
				JOIN #TValPotentialPlan PP ON PP.FormattedPolicyNumber = T.[FormattedPortfolioReference]

		insert into @stats values ('DEFAULT_FORMATTED_PLANNO_AS_FORMATTED_PLANNO', @@rowcount, datediff(ms, @timekeeper, getdate()))
		select @timekeeper = getdate()
	END   

    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @Rowcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : Updates', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END
	-- All Plans matched so populate holdings
	INSERT INTO #Holdings (ValBulkHoldingId,IndigoClientId, PolicyBusinessId, PlanCurrency, FundName, Quantity, UnitPrice, PriceDate, UnitCurrency , Sedol, MexId,ISIN, EpicCode
                , CitiCode, ProviderFundCode, PolicyProviderId, sequentialRef)
	SELECT  tmp.ValBulkHoldingId, tmp.IndigoClientId, tmp.PolicyBusinessId
			,CASE 
				WHEN RTRIM(pb.BaseCurrency) = '' OR pb.BaseCurrency IS NULL THEN @RegionalCurrency
				ELSE pb.BaseCurrency
			END
			,tmp._FundName, tmp.FundQuantity, tmp.Price, CONVERT(datetime,LEFT(tmp.FundPriceDate,4)+SUBSTRING(tmp.FundPriceDate,6,2)+RIGHT(tmp.FundPriceDate,2))
                        , LEFT(LTRIM(tmp.Currency),3), tmp.Sedol, tmp.MexId, tmp.ISIN, tmp.EpicCode, tmp.CitiCode, tmp.ProviderFundCode, pp.PolicyProviderId, pp.SequentialRef
	FROM 
		@TmpTValParseBulkHolding tmp 
		JOIN #TValPotentialPlan pp 
			ON tmp.PolicyBusinessId = pp.PolicyBusinessId 
		JOIN TPolicyBusiness pb
			ON pb.PolicyBusinessId = pp.PolicyBusinessId
	WHERE 
		PlanMatched = 1

	CREATE NONCLUSTERED INDEX IX1 ON [#Holdings] ([FundId]) INCLUDE ([IndigoClientId],[FundName],[UnitPrice],[PriceDate],[EpicCode], [Sedol],[MexId])

	SELECT @BulkHoldingInEligibilityMask = InEligibilityMask 
					FROM TValBulkHoldingInEligibilityCriteria IEC 
						JOIN TValSchedule S on IEC.ValuationProviderId = S.RefProdProviderid and s.ValScheduleId = @ValScheduleId

	SELECT @ValuationProviderID = RefProdProviderId FROM TValSchedule WHERE ValScheduleId = @ValScheduleId

	SELECT @EquityTypeId = RefFundTypeId, @EquityTypeName = [Type] FROM Fund2..TRefFundType WHERE FundTypeName = @Equities

	UPDATE  #Holdings
	SET  
			FundName =  replace(FundName,'&amp;', '&')
			,Sedol = CASE WHEN Sedol IS NULL OR LEN(Sedol) = 0 THEN NULL ELSE Sedol END
			,MexId  = CASE WHEN MexId IS NULL OR LEN(MexId) = 0 THEN NULL ELSE MexId END
			,ISIN  = CASE WHEN ISIN IS NULL OR LEN(ISIN) = 0 THEN NULL ELSE ISIN END
			,EpicCode = CASE WHEN EpicCode IS NULL OR LEN(EpicCode) = 0 THEN NULL ELSE EpicCode END
			,CitiCode  = CASE WHEN CitiCode IS NULL OR LEN(CitiCode) = 0 THEN NULL ELSE CitiCode END
			,ProviderFundCode  = CASE WHEN ProviderFundCode IS NULL OR LEN(ProviderFundCode) = 0 THEN NULL ELSE ProviderFundCode END

	insert into @stats values ('Formatting fund attributes',@@rowcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	UPDATE H
	SET H.FundId = e.EquityId, H.FundName = e.EquityName, H.FundTypeId = @EquityTypeId, H.CategoryName = @EquityTypeName, H.Feed = 1, h.Equity = 1
	FROM
				#Holdings H
					join fund2..TEquity e on (h.EpicCode = e.EpicCode or h.ISIN = e.ISINCode) and e.UpdatedFg = 1
			WHERE H.FundId IS NULL AND H.EpicCode IS NOT NULL

	insert into @stats values ('match equity information based on epic or isin code',@@rowcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	--SEDOL
	UPDATE H
	SET H.FundId = FU.FundUnitId, H.FundName = FU.UnitLongName, H.FundTypeId = F.RefFundTypeId, H.CategoryId = FS.FundSectorId, H.CategoryName = FS.FundSectorName, H.Feed = 1
	FROM
				#Holdings H
					JOIN fund2..TFundUnit FU  ON substring(H.Sedol, patindex('%[^0]%',H.Sedol),30) = substring(FU.SedolCode, patindex('%[^0]%',FU.SedolCode),30) AND FU.UpdatedFg = 1
					JOIN fund2..TFund F  ON f.FundId = fu.FundId
					JOIN fund2..TFundSector FS  ON fs.FundSectorId = f.FundSectorId
			WHERE H.FundId IS NULL AND H.Sedol IS NOT NULL AND H.EpicCode IS NULL

	insert into @stats values ('match fund information based on Sedol',@@rowcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	--MexID
	UPDATE H
	SET H.FundId = FU.FundUnitId, H.FundName = FU.UnitLongName, FundTypeId = F.RefFundTypeId, CategoryId = FS.FundSectorId, CategoryName = FS.FundSectorName, Feed = 1
	FROM
			#Holdings H
					JOIN fund2..TFundUnit FU  ON substring(H.MexID, patindex('%[^0]%',H.MexID),30)  = substring(FU.MexCode, patindex('%[^0]%',FU.MexCode),30)   AND FU.UpdatedFg = @UpdatedFg
					JOIN fund2..TFund F  ON f.FundId = fu.FundId
					JOIN fund2..TFundSector FS  ON fs.FundSectorId = f.FundSectorId
			WHERE H.FundId IS NULL AND H.MexId IS NOT NULL AND H.EpicCode IS NULL

	insert into @stats values ('match fund information based on MexId',@@rowcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	--ISIN
	UPDATE H
	SET H.FundId = FU.FundUnitId, H.FundName = FU.UnitLongName, FundTypeId = F.RefFundTypeId, CategoryId = FS.FundSectorId, CategoryName = FS.FundSectorName, Feed = 1
	FROM
			#Holdings H
					JOIN fund2..TFundUnit FU  ON H.ISIN = FU.IsInCode  AND FU.UpdatedFg = @UpdatedFg
					JOIN fund2..TFund F  ON f.FundId = fu.FundId
					JOIN fund2..TFundSector FS  ON fs.FundSectorId = f.FundSectorId
			WHERE H.FundId IS NULL AND H.ISIN IS NOT NULL AND H.EpicCode IS NULL

	insert into @stats values ('match fund information based on ISIN',@@rowcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	--CITI
	UPDATE H
	SET H.FundId = FU.FundUnitId, H.FundName = FU.UnitLongName, FundTypeId = F.RefFundTypeId, CategoryId = FS.FundSectorId, CategoryName = FS.FundSectorName, Feed = 1
	FROM
			#Holdings H
					JOIN fund2..TFundUnit FU  ON substring(H.CitiCode, patindex('%[^0]%',H.CitiCode),30) = substring(FU.CitiCode, patindex('%[^0]%',FU.CitiCode),30)  AND FU.UpdatedFg = @UpdatedFg
					JOIN fund2..TFund F  ON f.FundId = fu.FundId
					JOIN fund2..TFundSector FS  ON fs.FundSectorId = f.FundSectorId
			WHERE H.FundId IS NULL AND H.CitiCode IS NOT NULL AND H.EpicCode IS NULL

	insert into @stats values ('match fund information based on CitiCode',@@rowcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	UPDATE H
	SET H.FundId = FU.FundUnitId, H.FundName = FU.UnitLongName, FundTypeId = F.RefFundTypeId, CategoryId = FS.FundSectorId, CategoryName = FS.FundSectorName, Feed = 1
	FROM
			#Holdings H
				JOIN TProviderFundCode PFC ON 
					substring(H.ProviderFundCode, patindex('%[^0]%',H.ProviderFundCode),30) = substring(PFC.ProviderFundCode, patindex('%[^0]%',PFC.ProviderFundCode),30) 
					AND PFC.RefProdProviderId = H.PolicyProviderId
				JOIN fund2..TFundUnit FU  ON FU.FundUnitId = PFC.FundId
				JOIN fund2..TFund F  ON f.FundId = FU.FundId and pfc.FundTypeId = f.RefFundTypeId
				JOIN fund2..TFundSector FS  ON FS.FundSectorId = F.FundSectorId
		WHERE H.FundId IS NULL AND H.ProviderFundCode IS NOT NULL AND H.EpicCode IS NULL

	insert into @stats values ('match fund information based on ProviderFundCode',@@rowcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	UPDATE H
	SET H.FundId = e.EquityId, H.FundName = e.EquityName, H.FundTypeId = @EquityTypeId, H.CategoryName = @EquityTypeName, H.Feed = 1, h.Equity = 1
	FROM
				#Holdings H
					join fund2..TEquity e on (h.ISIN = e.ISINCode) and e.UpdatedFg = 1
			WHERE H.FundId IS NULL AND H.EpicCode IS NULL

	insert into @stats values ('match equity information based on epic or isin code',@@rowcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	-- Convert prices to Plan Currency
	;WITH cteCurrencies AS
	(
		SELECT DISTINCT
			 h.UnitCurrency AS SourceCurrency
			,h.PlanCurrency AS TargetCurrency
		FROM
			#Holdings h
		WHERE
			h.UnitCurrency <> h.PlanCurrency
		UNION SELECT DISTINCT
			 h.UnitCurrency AS SourceCurrency
			,@RegionalCurrency AS TargetCurrency
		FROM
			#Holdings h
		WHERE
			h.UnitCurrency <> @RegionalCurrency
	)
	INSERT INTO #TmpExRate
	SELECT
		 SourceCurrency
		,TargetCurrency
		,ISNULL(dbo.FnGetCurrencyRate(SourceCurrency, TargetCurrency), 1.0)
	FROM
		cteCurrencies

	-- Update easy ones where PlanCurrency & Fund Currency are the same
	UPDATE #Holdings  
		SET PlanUnitPrice = UnitPrice
	WHERE 
		PlanCurrency = UnitCurrency
	
	-- same where regional Currency Fund Currency are the same
	UPDATE #Holdings 
		SET RegionalUnitPrice = UnitPrice
	WHERE 
		UnitCurrency = @RegionalCurrency
	
	-- now update where the plan currency doesn't match	the fund currency
	UPDATE H 
	SET
		 H.PlanUnitPrice =  ROUND(H.UnitPrice  * cr.ExRate, 4)
	FROM    
		#Holdings H 
		LEFT JOIN #TmpExRate cr  
			ON cr.SourceCurrency = H.UnitCurrency 
			AND cr.TargetCurrency = H.PlanCurrency
	WHERE
		H.PlanCurrency <> H.UnitCurrency

	-- now update where the fund currency doesn't match	the regional currency
	UPDATE H 
	SET
		 H.RegionalUnitPrice =  ROUND(H.UnitPrice  * cr.ExRate, 4)
	FROM    
		#Holdings H 
		LEFT JOIN #TmpExRate cr  
			ON cr.SourceCurrency = H.UnitCurrency 
			AND cr.TargetCurrency = @RegionalCurrency
	WHERE
		H.UnitCurrency <> @RegionalCurrency


	insert into @stats values ('Fund Matching convert fund prices to plan currency',@@rowcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()
  
	IF EXISTS(SELECT 1 FROM #Holdings WHERE  FundId IS NULL)
	BEGIN
		--Get the fundtypeid for unknown
		SELECT @FundTypeId = RefFundTypeId  FROM fund2..TRefFundType   WHERE FundTypeName = @UnknowFundTypeName

		--Retrieve all the non feed funds for the Tenant
		If Object_Id('tempdb..#TmpTNonFeedFund1') Is Not Null Drop Table #TmpTNonFeedFund1
		select IndigoClientId, FundName, CurrentPrice ,PriceDate, NonFeedFundId, isin, epic, mexid, sedol, citi, ProviderFundCode, fundtypeid
		into #TmpTNonFeedFund1
			from
			(select  IndigoClientId, FundName, CurrentPrice ,PriceDate, NonFeedFundId, isin, epic, mexid, sedol, citi, ProviderFundCode, fundtypeid,
					row_number() over( partition by IndigoClientId, fundtypeid, isin, epic, mexid, sedol, citi, providerfundcode, FundName order by nonfeedfundid desc) r_Number
			from TNonFeedFund f
			WHERE IndigoClientId = @IndigoClientId
			) a where r_number = 1

		create clustered index IXTmpTNonFeedFund1 ON #TmpTNonFeedFund1 (IndigoClientId, NonFeedFundId, CurrentPrice)

		--Update the #holdings with the nonfeedfundid, those matching, and preserve the ids
		If Object_Id('tempdb..#UpdatedNonFeedFundIdDetails1') Is Not Null Drop Table #UpdatedNonFeedFundIdDetails1
		create table #UpdatedNonFeedFundIdDetails1(NonFeedFundId int null, sequentialref varchar(50))

		update H SET H.FundId = tmpfeed.NonFeedFundId, H.FundTypeId = case when h.epiccode is not null then @EquityTypeId else @FundTypeId end
			output inserted.fundid, inserted.sequentialRef into #UpdatedNonFeedFundIdDetails1(NonFeedFundId, sequentialref)
		from 
		     #Holdings H
		        INNER JOIN #TmpTNonFeedFund1 tmpfeed ON  h.IndigoClientId  =  tmpfeed.IndigoClientId
					and
						(
							(
								h.EpicCode is not null
								and
								h.EpicCode = tmpfeed.epic
								and
								tmpfeed.fundtypeid = @EquityTypeId
							)
						OR
							(
								h.EpicCode is null
								and
								(
									(h.isin is not null and h.isin = tmpfeed.isin) OR
									(h.mexid is not null and h.mexid = tmpfeed.mexid)  OR
									(h.citicode is not null and h.citicode = tmpfeed.citi) OR
									(h.providerfundcode is not null and h.providerfundcode = tmpfeed.providerfundcode) OR
									(h.sedol is not null and h.sedol = tmpfeed.sedol) OR
									(h.isin is null and h.mexid is null and h.citicode is null and h.providerfundcode is null and h.sedol  is null)
								)
								and tmpfeed.FundTypeId <>  @EquityTypeId
							)
						)
					and h.FundName = tmpfeed.FundName
			WHERE H.FundId IS NULL
		create clustered index IXUpdatedNonFeedFundIdDetails1 ON #UpdatedNonFeedFundIdDetails1 (NonFeedFundId, sequentialref)

		if exists (select 1 from #TmpTNonFeedFund1 tnf join #Holdings H on H.FundId = tnf.NonFeedFundId join #UpdatedNonFeedFundIdDetails1 u on h.FundId = u.NonFeedFundId where tnf.CurrentPrice <> H.UnitPrice)
		begin
			--update the nonfeed fund ids attribute from the latest provider file (joined with the preserved list above)
			-- always use regional unit price for NFFs
			update nff
				set CurrentPrice = h.RegionalUnitPrice , PriceDate = h.PriceDate, PriceUpdatedByUser = @StampUser, LastUpdatedByPlan = h.sequentialref, ConcurrencyId = nff.ConcurrencyId + 1
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
			from
				tnonfeedfund nff
					join #Holdings h on nff.NonFeedFundId = H.FundId and h.[Feed] = 0
					join (select NonFeedFundId, max(sequentialref) sequentialref from #UpdatedNonFeedFundIdDetails1 group by NonFeedFundId) u on h.FundId = u.NonFeedFundId and h.[Feed] = 0
			where nff.IndigoClientId = @IndigoClientId and nff.CurrentPrice <> h.UnitPrice
		end

		--clear the memory
		If Object_Id('tempdb..#TmpTNonFeedFund1') Is Not Null Drop Table #TmpTNonFeedFund1
		If Object_Id('tempdb..#UpdatedNonFeedFundIdDetails1') Is Not Null Drop Table #UpdatedNonFeedFundIdDetails1

		--Any more non feed funds not matched?
		if exists (select top 1 1 FROM #Holdings H WHERE H.FundId IS NULL)
		begin

			--add them to the repository
			INSERT TNonFeedFund (FundTypeId, FundTypeName, FundName, CompanyId, CompanyName, CategoryId, CategoryName, Sedol, MexId, IndigoClientId, CurrentPrice, PriceDate, PriceUpdatedByUser, ConcurrencyId, isin, Epic, Citi, ProviderFundCode)
			OUTPUT INSERTED.FundTypeId, INSERTED.FundTypeName, INSERTED.FundName, INSERTED.CompanyId, INSERTED.CompanyName, INSERTED.CategoryId, INSERTED.CategoryName, INSERTED.Sedol, INSERTED.MexId, INSERTED.IndigoClientId, INSERTED.CurrentPrice, INSERTED.PriceDate, INSERTED.PriceUpdatedByUser, INSERTED.ConcurrencyId, INSERTED.NonFeedFundId,  'C', @StampDateTime, @StampUser, inserted.isin, inserted.Citi, inserted.ProviderFundCode, inserted.RefProdProviderId
			INTO TNonFeedFundAudit ( FundTypeId, FundTypeName, FundName, CompanyId, CompanyName, CategoryId, CategoryName, Sedol, MexId, IndigoClientId, CurrentPrice, PriceDate, PriceUpdatedByUser, ConcurrencyId, NonFeedFundId, StampAction, StampDateTime, StampUser, isin, Citi, ProviderFundCode, RefProdProviderId) 
			SELECT  DISTINCT @FundTypeId, @UnknowFundTypeName, FundName, NULL, NULL, NULL, NULL, SEDOL, MexID, IndigoClientID, RegionalUnitPrice, PriceDate, @StampUser, 1, isin, EpicCode, CitiCode, ProviderFundCode
			FROM #Holdings H
			WHERE H.FundId IS NULL and EpicCode is null
			union
			SELECT  DISTINCT @EquityTypeId, @EquityTypeName, FundName, NULL, NULL, NULL, NULL, SEDOL, MexID, IndigoClientID, RegionalUnitPrice, PriceDate, @StampUser, 1, isin, EpicCode, CitiCode, ProviderFundCode
			FROM #Holdings H
			WHERE H.FundId IS NULL and EpicCode is not null

			--repeat the above procedure, 
			If Object_Id('tempdb..#TmpTNonFeedFund2') Is Not Null Drop Table #TmpTNonFeedFund2

			--Retrieve all the non feed funds for the Tenant
			select IndigoClientId, FundName, CurrentPrice ,PriceDate, NonFeedFundId, isin, epic, mexid, sedol, citi, ProviderFundCode, fundtypeid
			into #TmpTNonFeedFund2
				from
				(select  IndigoClientId, FundName, CurrentPrice ,PriceDate, NonFeedFundId, isin, epic, mexid, sedol, citi, ProviderFundCode, fundtypeid,
						row_number() over( partition by IndigoClientId, fundtypeid, isin, epic, mexid, sedol, citi, providerfundcode, FundName order by nonfeedfundid desc) r_Number
				from TNonFeedFund f
				WHERE IndigoClientId = @IndigoClientId
				) a where r_number = 1

			--Update the #holdings with the nonfeedfundid, those matching, and preserve the ids
			If Object_Id('tempdb..#UpdatedNonFeedFundIdDetails2') Is Not Null Drop Table #UpdatedNonFeedFundIdDetails2
			create table #UpdatedNonFeedFundIdDetails2(NonFeedFundId int null, sequentialref varchar(50))

			update H SET H.FundId = tmpfeed.NonFeedFundId, H.FundTypeId = case when h.epiccode is not null then @EquityTypeId else @FundTypeId end
				output inserted.fundid, inserted.sequentialRef into #UpdatedNonFeedFundIdDetails2(NonFeedFundId, sequentialref)
			from 
				 #Holdings H
					INNER JOIN #TmpTNonFeedFund2 tmpfeed ON  h.IndigoClientId  =  tmpfeed.IndigoClientId
						and
							(
								(
									h.EpicCode is not null
									and
									h.EpicCode = tmpfeed.epic
									and
									tmpfeed.fundtypeid = @EquityTypeId
								)
							OR
								(
									h.EpicCode is null
									and
									(
										(h.isin is not null and h.isin = tmpfeed.isin) OR
										(h.mexid is not null and h.mexid = tmpfeed.mexid)  OR
										(h.citicode is not null and h.citicode = tmpfeed.citi) OR
										(h.providerfundcode is not null and h.providerfundcode = tmpfeed.providerfundcode) OR
										(h.sedol is not null and h.sedol = tmpfeed.sedol) OR
										(h.isin is null and h.mexid is null and h.citicode is null and h.providerfundcode is null and h.sedol  is null)
									)
									and tmpfeed.FundTypeId <>  @EquityTypeId
								)
							)
						and h.FundName = tmpfeed.FundName
				WHERE H.FundId IS NULL

			create clustered index IXUpdatedNonFeedFundIdDetails2 ON #UpdatedNonFeedFundIdDetails2 (NonFeedFundId, sequentialref)

			--update the nonfeed fund ids attribute from the latest provider file (joined with the preserved list above)
			update nff
			set LastUpdatedByPlan = u.sequentialref, ConcurrencyId = nff.ConcurrencyId + 1
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
			from
				tnonfeedfund nff
					join #Holdings h on nff.NonFeedFundId = H.FundId and h.[Feed] = 0
					join (select NonFeedFundId, max(sequentialref) sequentialref from #UpdatedNonFeedFundIdDetails2 group by NonFeedFundId) u on h.FundId = u.NonFeedFundId and h.[Feed] = 0
			where nff.IndigoClientId = @IndigoClientId and coalesce(nff.CurrentPrice,0) <> coalesce(h.RegionalUnitPrice,0)

			--clear the memory
			If Object_Id('tempdb..#TmpTNonFeedFund2') Is Not Null Drop Table #TmpTNonFeedFund2
			If Object_Id('tempdb..#UpdatedNonFeedFundIdDetails2') Is Not Null Drop Table #UpdatedNonFeedFundIdDetails2

		end

	END
	
	insert into @stats values ('Fund Matching - Identifying NonFeedFund',null,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	IF OBJECT_ID('tempdb..#TPolicyBusinessFundOrderedBy') IS NOT NULL DROP TABLE #TPolicyBusinessFundOrderedBy
	create table #TPolicyBusinessFundOrderedBy (PolicyBusinessFundId bigint null, PolicyBusinessId bigint null, FundID bigint null, FromFeedFg bit, EquityFg bit)
	insert into #TPolicyBusinessFundOrderedBy(PolicyBusinessFundId, PolicyBusinessId, FundId, FromFeedFg, EquityFg)
	select PolicyBusinessFundId, PolicyBusinessId, FundId, FromFeedFg, EquityFg from
	(
		select fund.PolicyBusinessFundId, fund.PolicyBusinessId, fund.FundId, FromFeedFg, EquityFg,
				ROW_NUMBER() Over(Partition by fund.policybusinessid, fund.fundid, fund.FromFeedFg, fund.EquityFg order by fund.policybusinessfundid asc) orderNumber
			from TPolicyBusinessFund fund join #Holdings h on fund.PolicyBusinessId = h.PolicyBusinessId
	) a where orderNumber = 1

	UPDATE H
		SET H.PolicyBusinessFundId = PF.PolicyBusinessFundID
		FROM #Holdings H
					JOIN #TPolicyBusinessFundOrderedBy PF  ON H.PolicyBusinessId = PF.PolicyBusinessId AND H.FundId = PF.FundId AND H.Feed = PF.FromFeedFg AND H.Equity = PF.EquityFg
	WHERE H.FundId IS NOT NULL

	insert into @stats values ('Update PolicyBusinessFundId',@@rowcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	--if there are any duplicate funds with same fund id we will add up the quantity 
	--this is because we cannot have multiple funds in the funds and holding for the same fundid due to building transaction history. 

	IF OBJECT_ID('tempdb..#fundgroupingerror') IS NOT NULL DROP TABLE #fundgroupingerror
	IF @BulkHoldingInEligibilityMask & @INELIGIBLE_GROUPING = @INELIGIBLE_GROUPING
	BEGIN
		select distinct PolicyBusinessId
		into #fundgroupingerror
		from(
				SELECT PolicyBusinessId, FundId, Equity, Feed, UnitPrice
				FROM #Holdings
				GROUP BY PolicyBusinessId, FundId, Equity, Feed, UnitPrice
		) a group by PolicyBusinessId, FundId, Equity, Feed
			HAVING COUNT(1) > 1

			if exists(select 1 from #fundgroupingerror)
			begin
				update t 
				set PlanInEligibilityMask = 2, FundMatched = 0, FundDeleteBreaker = 1, FundUpdateBreaker = 1, PlanUpdateBreaker = 1, PlanMatched = 0
				from @TmpTValParseBulkHolding t join #fundgroupingerror e on t.PolicyBusinessId = e.PolicyBusinessId 

				delete h 
				from #Holdings h join #fundgroupingerror e on h.PolicyBusinessId = e.PolicyBusinessId 
			end
	END

	insert into @stats values ('Fund Matching Eligibility check',null,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	insert #GroupedFunds (ValBulkHoldingId,PolicyBusinessId, FundId, Feed, Equity, FundQuantity)
	SELECT MAX([ValBulkHoldingId]) [ValBulkHoldingId], PolicyBusinessId, FundId, Feed, Equity, SUM( CONVERT(MONEY,[Quantity]))  [FundQuantity]
	FROM #Holdings
	GROUP BY PolicyBusinessId, FundId, Feed, Equity HAVING COUNT(*) > 1

	if exists (select 1 from #GroupedFunds)
	begin
		insert #duplicatefunds (ValBulkHoldingId)
		select ValBulkHoldingId
		from (select row_number() over (partition by h.PolicyBusinessId, h.FundId, h.Feed, h.Equity order by h.ValBulkHoldingId desc) rownumber, h.ValBulkHoldingId from #Holdings h inner join #GroupedFunds g on h.policybusinessid = g.policybusinessid and h.fundid = g.fundid and h.Feed = g.Feed and h.Equity = g.Equity) a
		where rownumber <> 1

		if exists (select 1 from #duplicatefunds)
		begin

				update T 
					SET T.FundQuantity = convert(decimal(19,6),G.FundQuantity)
					FROM @TmpTValParseBulkHolding T            
					JOIN #GroupedFunds G ON T.ValBulkHoldingId = G.ValBulkHoldingId

				delete h
					from #Holdings h inner join #duplicatefunds d on h.ValBulkHoldingId = d.ValBulkHoldingId

				delete T
					
					FROM @TmpTValParseBulkHolding T            
						JOIN #duplicatefunds G ON T.ValBulkHoldingId = g.ValBulkHoldingId
		end
	end

	insert into @stats values ('Fund Matching Duplicate removal',null,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @Rowcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : Before facilitating for a safe re-run', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END
		    --facilitating for a safe re-run
    UPDATE @TmpTValParseBulkHolding
    SET  FundMatched = 0, PolicyBusinessFundId = 0, FundID = NULL, FundName = NULL, FundTypeId = NULL, CategoryId = NULL, CategoryName = NULL, Feed = NULL
    WHERE  ValScheduleId = @ValScheduleId AND FundMatched <> 0

    SET @Rowcount = @@Rowcount

    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @Rowcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : Update @TmpTValParseBulkHolding FundMatched <> 0', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END
	
    UPDATE R
    SET FundMatched = 1, R.PolicyBusinessFundId = H.PolicyBusinessFundId, FundDeleteBreaker = 0, FundUpdateBreaker = 0
        ,R.FundID = H.FundID, R.FundName = H.FundName, R.FundTypeId = H.FundTypeId, R.CategoryId = H.CategoryId, R.CategoryName = H.CategoryName, R.Feed = H.Feed
	    ,R.FundUnitPrice = H.PlanUnitPrice, R.FundQuantity = case when R.FundQuantity is null then '0' else R.FundQuantity end
    FROM @TmpTValParseBulkHolding R 
    INNER JOIN #Holdings H ON R.ValBulkholdingId = H.ValBulkHoldingId AND H.PolicyBusinessFundId IS NOT NULL
    WHERE R.ValScheduleId = @ValScheduleId
    SET @Rowcount = @@Rowcount

    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @Rowcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : Update @TmpTValParseBulkHolding join #Holdings PolicyBusinessFundId IS NOT NULL', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END

    UPDATE R
    SET  FundMatched = 0, FundDeleteBreaker = 0, FundUpdateBreaker = 0
		    ,R.FundID = H.FundID, R.FundName = H.FundName, R.FundTypeId = H.FundTypeId, R.CategoryId = H.CategoryId, R.CategoryName = H.CategoryName, R.Feed = H.Feed
		    ,R.FundUnitPrice = H.PlanUnitPrice
    FROM @TmpTValParseBulkHolding R INNER JOIN #Holdings H ON R.ValBulkholdingId = H.ValBulkHoldingId AND H.PolicyBusinessFundId IS NULL
    WHERE R.ValScheduleId = @ValScheduleId
		
    SET @Rowcount = @@Rowcount
    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @Rowcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : Update @TmpTValParseBulkHolding join #Holdings PolicyBusinessFundId IS NULL', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END
                
		    UPDATE R
		    SET  FundUpdateBreaker = 1  --effectively this is at plan level and not fund level!
                            FROM @TmpTValParseBulkHolding R 
		    JOIN #TValPotentialPlan  PP   ON PP.PolicyBusinessId = R.PolicyBusinessId 
		    JOIN TRefPlanType2ProdSubType RP  ON RP.RefPlanType2ProdSubTypeId = PP.RefPlanType2ProdSubTypeId
				    JOIN TValExcludeFundUpdate FU ON R.ValScheduleId = FU.ValScheduleId JOIN TValGating G ON FU.ValGatingId = G.ValGatingId  
		    WHERE 
				    G.RefPlanTypeId = RP.RefPlanTypeId AND ISNULL(G.ProdSubTypeId,0) = ISNULL(RP.ProdSubTypeId,0)
		    AND R.ValScheduleId = @ValScheduleId
    SET @Rowcount = @@Rowcount
    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @Rowcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : effectively this is at plan level and not fund level', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END

	insert into @stats values ('End Fund Matching',null,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate(),@Rowcount = @@Rowcount

	select @printtime = 'Bulk valuation Matches/Sec '+convert(varchar,(@bvcount/(case when datediff(ss,@StampDateTime,getdate()) =0 then 1 else datediff(ss,@StampDateTime,getdate()) end) ))
	insert into @stats values (@printtime,@bvcount,0)

    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = 1, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : insert @stats', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END
	if exists (select 1 from TValBulkQ where ValScheduleId = @ValScheduleId)
	begin
		delete from TValBulkQ where ValScheduleId = @ValScheduleId
	end
        SET @Rowcount = @@Rowcount

    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @Rowcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : delete from TValBulk', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END

	INSERT dbo.TValBulkQ (CustomerReference,PortfolioReference
        ,CustomerFirstName
        ,CustomerLastName,CustomerDoB,CustomerNINumber
        ,ClientPostCode
        ,AdviserFirstName,AdviserLastName
        ,PortfolioType
        ,_FundName,ISIN,MexId,Sedol,FundQuantity,EffectiveDate,Price,FundPriceDate
        ,Currency
        ,EpicCode,CitiCode
        ,PolicyProviderName,ProviderFundCode,FundDeleteBreaker,FundUpdateBreaker,PlanMatched
        ,PolicyBusinessId,FundMatched,PolicyBusinessFundId,ValuationUpdated,PlanValuationId,PlanInEligibilityMask,PlanUpdateBreaker,CreatedDateTime,Remarks,ConcurrencyId
        ,ValScheduleId,FormattedPolicyNumber,IndigoClientId,FundID,FundTypeID,CategoryId,CategoryName,FundUnitPrice,Feed,ValBulkHoldingId,ValScheduleItemId,FundName,PolicyStartDate
        ,Qtimestamp,xflag, [ModelPortfolioName], [DFMName])

	SELECT CustomerReference,PortfolioReference
        ,CustomerFirstName
        ,CustomerLastName,CustomerDoB,CustomerNINumber
        ,ClientPostCode
        ,AdviserFirstName,AdviserLastName
        ,PortfolioType
        ,_FundName,ISIN,MexId,Sedol,FundQuantity,EffectiveDate,Price,FundPriceDate
        ,Currency
        ,EpicCode,CitiCode
        ,PolicyProviderName,ProviderFundCode,FundDeleteBreaker,FundUpdateBreaker,PlanMatched
        ,PolicyBusinessId,FundMatched,PolicyBusinessFundId,ValuationUpdated,PlanValuationId,PlanInEligibilityMask,PlanUpdateBreaker,CreatedDateTime,Remarks,ConcurrencyId
        ,ValScheduleId,FormattedPolicyNumber,IndigoClientId,FundID,FundTypeID,CategoryId,CategoryName,FundUnitPrice,Feed,ValBulkHoldingId,ValScheduleItemId,FundName,PolicyStartDate
        ,@StampDateTime,0, [ModelPortfolioName], [DFMName] 
	from @TmpTValParseBulkHolding
	
    SET @Rowcount = @@Rowcount
    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @Rowcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : insert dbo.TValBulkQ', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END

	insert into @stats values ('Populating bulk valuation queue',@@rowcount,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate(), @Rowcount = @@Rowcount
    
    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @Rowcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : insert dbo.TValBulkQ', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END

    -- Slow statement 28% duration 0% cost- bad estimation (stats), (fragementation 
	delete from dbo.TValBulkQStage where ValScheduleId = @ValScheduleId
	insert into @stats values ('Deleting records from processing queue staging table',@@rowcount,datediff(ms,@timekeeper,getdate()))
	
	select @timekeeper = getdate(), @Rowcount = @@Rowcount
    IF @Debug > 0
    BEGIN
        SELECT @Duration = datediff (ms, @Now, getdate()), @Rowcount = @Rowcount, @Now = getdate()
        RAISERROR ('Duration = %d, @Rowcount = %d : delete TValBulkQStage', 0,0, @Duration, @Rowcount) WITH NOWAIT;
    END

	select @printtime = 'Bulk valuation process completed: '+convert(varchar(30),getdate())
	insert into @stats values (@printtime,null,0)

	set @statsxml = (select * from (select * from @stats)  BulkValuationStats for xml auto, type)

	insert into TValBulkExecStats values (@ValScheduleId, @ValScheduleItemId, @StampDateTime, getdate(), null,null,@statsxml,null)
	SELECT [Description] = 'Records Matched Successfully' , [Status] = 1
	return 0

	errorhandling: 
	SELECT [Description] = COALESCE(@execErrDescription,'') , [Status] = 0
	set @statsxml = (select * from (select * from @stats)  BulkValuationStats for xml auto, type)
	insert into TValBulkExecStats values (@ValScheduleId, @ValScheduleItemId, @StampDateTime, getdate(), null,null,@statsxml,null)
	RAISERROR (@execErrDescription,10,1,N'Error')
	return 1
end

GO
