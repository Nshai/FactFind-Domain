SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.SpCustomValuationsPopulateValScheduledPlan
@ValuationProviderCode sysname
WITH RECOMPILE
AS

BEGIN

	SET NOCOUNT ON
	SET XACT_ABORT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Declare @StampUser VARCHAR(1) = '0', @ErrorMessage VARCHAR(MAX)

    DECLARE @FIRM_SCHEDULE varchar(10) = 'firm', 
			@BULK_MANUAL_SCHEDULE varchar(50) = 'bulkmanual',
			@ADVISER_SCHEDULE varchar(10) = 'adviser',  
			@CLIENT_SCHEDULE varchar(10) = 'client'

    DECLARE @USERHASACCESS INT = 256, 
			@GROUPHASACCESS INT = 512, 
			@SCHEDULEDPLANNOTDUPLICATE INT = 1024, 
			@USERHASCREDENTIALS INT = 2048,
			@AdviserAllowed tinyint = 4,
			@PlanExcluded tinyint = 8,
			@Plantypeallowed tinyint = 16

    DECLARE @MatchingMask  BIGINT

	DECLARE @MATCHING_PLANNUMBER TINYINT = 16,
			@MATCHING_PLANNUMBER_CUSTOMERREFERENCE TINYINT = 32,
			@MATCHING_PORTALREFERENCE_PORTFOLIOTYPE TINYINT = 64,
			@MATCHING_PORTALREFERENCE_CUSTOMERREFERENCE TINYINT = 128,
		    @MATCHING_WRAPPERPLANNUMBER_CUSTOMERREFERENCE INT = 256,
	        @MATCHING_AGENCYNUMBER INT = 512,
			@MATCHING_ADDITIONAL_AEGONCOFUNDRULES INT = 1024

	DECLARE @PlanEligibility BIGINT, @ScheduleEligibility BIGINT, @Bulk_PlanEligibility int, @Client_Scheduled_PlanEligibility int
	DECLARE @BulkManualTemplate BIGINT, @BulkManualTemplateFlag BIT
	DECLARE @ProviderId BIGINT
	declare @TValScheduledJobExecStatsId as table (id bigint)
	declare @ValScheduledJobExecStatsId bigint
	declare @timekeeper datetime, @statlog sysname, @affectedRecords bigint, @statsxml xml

	declare @stats table (sequence smallint identity, StatsMessage varchar(Max), affectedRows bigint null, ElapsedMilliSeconds bigint)

	declare @StampDateTime DATETIME2 = GETDATE()

	insert into @stats values ('Scheduled plan eligibility process started: '+ convert(varchar(30),@StampDateTime),null,0)
	select @timekeeper = getdate()

	BEGIN TRY

		SELECT @ProviderId = RefProdProviderId FROM TValProviderConfig Where ValuationProviderCode = @ValuationProviderCode

		insert into TValScheduledJobExecStats(ValuationProviderId,JobStart) 
			output inserted.ValScheduledJobExecStatsID into @TValScheduledJobExecStatsId
		values (@ProviderId, @StampDateTime)
		select @ValScheduledJobExecStatsId = id from @TValScheduledJobExecStatsId

		IF @ProviderId IS NULL
		BEGIN
			insert into @stats values ('Provider doenot exist - Process ends.',null,datediff(ms,@timekeeper,getdate()))
			select @timekeeper = getdate()
			goto errorhandling
		END
		
--we need to have some special handling for bulk manual template
		SELECT @BulkManualTemplate = rp.RefProdProviderId 
				from TRefProdProvider rp join crm..tcrmcontact c on rp.crmcontactid = c.CRMContactId 
				where c.Corporatename like 'Bulk Manual Template'

		if (@ProviderId = @BulkManualTemplate) 
			SET @BulkManualTemplateFlag = 1 
		else 
		SET @BulkManualTemplateFlag = 0

--preparatory data
		IF (select object_id('tempdb..#ExtendValuationsByServicingadviser')) is not null drop table #ExtendValuationsByServicingadviser
		SELECT  Value ValueByServicingAdviser, IndigoClientId INTO #ExtendValuationsByServicingadviser
									FROM Administration..TIndigoClientPreference  with (nolock) WHERE PreferenceName = 'ExtendValuationsByServicingadviser' AND Value = '1' 

		SELECT @PlanEligibility = SUM(EligibilityFlag) FROM TValEligibilityCriteria Criteria CROSS JOIN TValRefEligibilityFlag Flag
									WHERE Criteria.EligibilityMask & Flag.EligibilityFlag = Flag.EligibilityFlag And Flag.EligibilityLevel = 'plan' and Criteria.ValuationProviderId = @ProviderId
		SET @Bulk_PlanEligibility = @PlanEligibility & ~@AdviserAllowed
		SET @Bulk_PlanEligibility = @Bulk_PlanEligibility & ~@PlanExcluded
		SET @Bulk_PlanEligibility = @Bulk_PlanEligibility & ~@Plantypeallowed
		SET @Client_Scheduled_PlanEligibility = @PlanEligibility & ~@AdviserAllowed

		SELECT @ScheduleEligibility = SUM(EligibilityFlag) FROM TValEligibilityCriteria Criteria CROSS JOIN TValRefEligibilityFlag Flag
									WHERE Criteria.EligibilityMask & Flag.EligibilityFlag = Flag.EligibilityFlag And Flag.EligibilityLevel = 'scheduledplan' and Criteria.ValuationProviderId = @ProviderId

		SELECT @MatchingMask =  MatchingMask FROM TValMatchingCriteria where ValuationProviderId = @ProviderId

		insert into @stats values ('Read Provider Configuration',null,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()

--eligibile schedules
		if OBJECT_ID('tempdb..#EligibleSchedules') is not null drop table #EligibleSchedules
		SELECT s.ValScheduleId, s.ScheduledLevel, S.RefProdProviderId ValuationProviderId, S.IndigoClientId, S.PortalCRMContactId
				INTO #EligibleSchedules
					FROM TValSchedule s JOIN TValScheduleItem i ON s.ValScheduleId = i.ValScheduleId 
					WHERE 
					s.RefProdProviderId = @ProviderId
					and
					(	
						(coalesce(S.Frequency,'') <> 'Single')
						OR 
						(s.Frequency = 'Single' AND i.RefValScheduleItemStatusId = 5) 
					)

		select @AffectedRecords = @@rowcount

		set @ErrorMessage = ''
		select @ErrorMessage = ',' + STRING_AGG(CONVERT(varchar(max),ValScheduleId), ',') from  #EligibleSchedules
		insert into @stats values ('Eligible Schedules' + @ErrorMessage ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()
		set @ErrorMessage = ''
	
		insert into #EligibleSchedules(ValScheduleId, ScheduledLevel, ValuationProviderId, IndigoClientId, PortalCRMContactId)
		select s.ValScheduleId, s.ScheduledLevel, lk.MappedRefProdProviderId ValuationProviderId,  S.IndigoClientId, S.PortalCRMContactId
		from TValSchedule s 
			join TValScheduleItem i on s.ValScheduleId = i.ValScheduleId
			join TValLookUp lk on s.RefProdProviderId = lk.RefProdProviderId
		where 
				s.RefProdProviderId in (select RefProdProviderId from TValLookUp with (nolock) where MappedRefProdProviderId = @ProviderId)
				and
				(	
					(coalesce(S.Frequency,'') <> 'Single')
					OR 
					(s.Frequency = 'Single' AND i.RefValScheduleItemStatusId = 5) 
				)

		select @AffectedRecords = @@rowcount
		
		select @ErrorMessage = ',' + STRING_AGG(CONVERT(varchar(max),ValScheduleId), ',') from  #EligibleSchedules
		insert into @stats values ('Eligible Schedules - Lookup' + @ErrorMessage ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
		select @timekeeper = getdate()
		set @ErrorMessage = ''


--template provider handling
		if object_id('tempdb..#templateproviders') is not null drop table #templateproviders
		create table #templateproviders (IndigoClientid bigint, refprodproviderid bigint)
		if @BulkManualTemplateFlag = 1
			BEGIN
				--Private Template Providers
				insert into #templateproviders (IndigoClientid, refprodproviderid)
					SELECT TP.IndigoClientid, refprodproviderid FROM #EligibleSchedules ES JOIN TValTemplateProvider TP ON TP.IndigoClientId = ES.IndigoClientId

				select @AffectedRecords = @@rowcount
				insert into @stats values ('Private Template Providers' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()

				--Public Template Providers
				insert into #templateproviders (IndigoClientid, refprodproviderid)
					SELECT ES.IndigoClientid, refprodproviderid FROM #EligibleSchedules ES CROSS APPLY TValTemplateProvider TP
						WHERE ES.ValuationProviderId = @BulkManualTemplate
						AND NOT EXISTS( SELECT 1 FROM TValTemplateProvider WHERE IndigoClientId = ES.IndigoClientId)

				select @AffectedRecords = @@rowcount
				insert into @stats values ('Public Template Providers' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()

			END
				
        --Finding related plans for a schedule could differ by its level
        --1) client                        <1-1> PBId; 
        --2) adviser					   <1-M> All plans by selling adviser and valuation provider
        --3) firm/bulkmanual(non-template) <1-M> All plans by firm and valuation provider 
		--4) bulk manual template	       <1-M> All plans by firm and template provider

--scheduled plans
		if OBJECT_ID('tempdb..#scheduledplans') is not null drop table #scheduledplans
		create table #scheduledplans (indigoclientid int, ValScheduleId int, PolicyBusinessId int,
						EligibilityMask int not null default(0) , [Status] int not null default (0),
						Remarks varchar(100) not null default '', [Bulk] tinyint not null default (0))

		if (@BulkManualTemplateFlag = 1)
		begin
				insert into #scheduledplans (indigoclientid, ValScheduleId, PolicyBusinessId, [Bulk])
					SELECT DISTINCT pp.indigoclientid, S.ValScheduleId, PP.PolicyBusinessId, 1
							FROM #EligibleSchedules S
								JOIN #templateproviders TP ON TP.IndigoClientId = S.IndigoClientId
								JOIN  TValPotentialPlan PP  ON PP.IndigoClientId = S.IndigoClientId AND PP.PolicyProviderId = TP.RefProdProviderId
							WHERE  S.ScheduledLevel IN ( @FIRM_SCHEDULE, @BULK_MANUAL_SCHEDULE) 
								AND PP.EligibilityMask & @Bulk_PlanEligibility =  @Bulk_PlanEligibility
		end
		else
		begin
				insert into #scheduledplans (indigoclientid, ValScheduleId, PolicyBusinessId, [Bulk])
					SELECT pp.indigoclientid, S.ValScheduleId, PP.PolicyBusinessId, 0
							FROM #EligibleSchedules S
							   JOIN TValSchedulePolicy SP ON S.Valscheduleid = SP.Valscheduleid
							   JOIN TValPotentialPlan PP ON PP.ValuationProviderId = S.ValuationProviderId and S.IndigoClientId = PP.IndigoClientId and PP.PolicyBusinessId = SP.PolicyBusinessId
							   WHERE  S.ScheduledLevel = @CLIENT_SCHEDULE  AND PP.EligibilityMask & @Client_Scheduled_PlanEligibility = @Client_Scheduled_PlanEligibility
					UNION ALL

					SELECT pp.indigoclientid, S.ValScheduleId, PP.PolicyBusinessId, 0
					FROM #EligibleSchedules S
							   JOIN  TValPotentialPlan PP  ON PP.ValuationProviderId = S.ValuationProviderId and  S.IndigoClientId = PP.IndigoClientId
							   left join #ExtendValuationsByServicingadviser X on x.IndigoClientId = s.IndigoClientId
							   WHERE  S.ScheduledLevel = @ADVISER_SCHEDULE AND PP.EligibilityMask & @PlanEligibility =  @PlanEligibility
													AND
													(
													   (
														(S.PortalCRMContactId = PP.SellingAdviserCRMContactID and pp.SellingAdviserStatus = 'Access Granted')
														OR
														(pp.SellingAdviserStatus != 'Access Granted'  AND pp.ServicingAdviserStatus = 'Access Granted' AND S.PortalCRMContactId =  PP.ServicingAdviserCRMContactID)
													   )
													)
					UNION ALL

					SELECT pp.indigoclientid, S.ValScheduleId, PP.PolicyBusinessId, 1
					FROM #EligibleSchedules S
								JOIN  TValPotentialPlan PP  ON PP.ValuationProviderId = S.ValuationProviderId and PP.IndigoClientId = S.IndigoClientId
								WHERE  S.ScheduledLevel IN ( @FIRM_SCHEDULE, @BULK_MANUAL_SCHEDULE)
								AND PP.EligibilityMask & @Bulk_PlanEligibility =  @Bulk_PlanEligibility
		end
	
	select @AffectedRecords = @@rowcount
	insert into @stats values ('eligible plans retrieved from TValpotentialPlan' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	create nonclustered index [IX_tmpscheduledplans] on [#scheduledplans] (ValScheduleId,Policybusinessid ) INCLUDE (EligibilityMask)

	if @BulkManualTemplateFlag <> 1
	begin
						UPDATE SP SET EligibilityMask = SP.EligibilityMask + @USERHASACCESS
						FROM     [#scheduledplans] SP   
										JOIN TValSchedule S ON SP.ValScheduleId = S.ValScheduleId
										JOIN #EligibleSchedules ES ON SP.ValScheduleId = ES.ValScheduleId
										JOIN TValPotentialPlan PP  ON PP.PolicyBusinessId = SP.PolicyBusinessId 
										JOIN crm..TCRMContact CC  ON PP.PolicyOwnerCRMContactID = CC.CRMContactId
										JOIN crm..VwCRMContactKeyByCreatorId TCKey ON TCKey.UserId = S.CreatedByUserId AND TCKey.CreatorId = CC._OwnerId
										JOIN crm..VwCRMContactKeyByEntityId TEKey ON TEKey.UserId = S.CreatedByUserId AND TEKey.EntityId = CC.CRMContactId

				select @AffectedRecords = @@rowcount
				insert into @stats values ('user has entity access to the scheduled plans' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()

						UPDATE SP SET EligibilityMask = SP.EligibilityMask + @USERHASCREDENTIALS
						FROM     [#scheduledplans] SP   
										JOIN TValSchedule S   ON SP.ValScheduleId = S.ValScheduleId
										JOIN #EligibleSchedules ES ON SP.ValScheduleId = ES.ValScheduleId
										JOIN administration..tcertificate C ON S.PortalCRMContactId = C.crmcontactid
										JOIN TValProviderConfig PC ON ES.ValuationProviderId = PC.refprodproviderid 
						WHERE PC.AuthenticationType in (1,2) AND S.ScheduledLevel in (@ADVISER_SCHEDULE ,@CLIENT_SCHEDULE) AND @StampDateTime <= C.ValidUntil and IsRevoked = 0

				select @AffectedRecords = @@rowcount
				insert into @stats values ('scheduled plans of user has unipass' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()

						UPDATE SP SET EligibilityMask = SP.EligibilityMask + @USERHASCREDENTIALS
						FROM      [#scheduledplans] SP   
										JOIN TValSchedule S   ON SP.ValScheduleId = S.ValScheduleId
										JOIN #EligibleSchedules ES ON SP.ValScheduleId = ES.ValScheduleId    
										JOIN TValportalSetup C ON ES.ValuationProviderId =  C.Refprodproviderid AND S.PortalCRMContactId =  C.CRMContactId
										JOIN TValProviderConfig PC ON ES.ValuationProviderId = PC.refprodproviderid
						WHERE PC.AuthenticationType in(0,2) AND S.ScheduledLevel in (@ADVISER_SCHEDULE ,@CLIENT_SCHEDULE) and EligibilityMask & @USERHASCREDENTIALS <> @USERHASCREDENTIALS


				select @AffectedRecords = @@rowcount
				insert into @stats values ('scheduled plans of user has username-password' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()


						UPDATE SP SET EligibilityMask = SP.EligibilityMask + @USERHASCREDENTIALS
						FROM      [#scheduledplans] SP   
										JOIN TValSchedule S   ON SP.ValScheduleId = S.ValScheduleId
										JOIN #EligibleSchedules ES ON SP.ValScheduleId = ES.ValScheduleId
						WHERE S.ScheduledLevel not in (@ADVISER_SCHEDULE ,@CLIENT_SCHEDULE) and EligibilityMask & @USERHASCREDENTIALS <> @USERHASCREDENTIALS

				select @AffectedRecords = @@rowcount
				insert into @stats values ('ignored scheduled plans of user credential check for bulk schedules' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()
	
	end

            UPDATE SP SET EligibilityMask = SP.EligibilityMask + @GROUPHASACCESS
            FROM      [#scheduledplans] SP   
							JOIN TValSchedule S   ON SP.ValScheduleId = S.ValScheduleId
							JOIN #EligibleSchedules ES ON SP.ValScheduleId = ES.ValScheduleId
							JOIN TValPotentialPlan PP  ON PP.PolicyBusinessId = SP.PolicyBusinessId
							JOIN administration..TUser U  ON PP.SellingAdviserCRMContactID = U.CRMContactId  --Group is always decided by selling adviser and not servicing adviser - It is by requirement
							JOIN administration..TGroup G  ON S.RefGroupId = G.GroupId
							LEFT JOIN #ExtendValuationsByServicingadviser X on X.IndigoClientId = s.IndigoClientId
							WHERE 
									(
										(G.ParentId IS NULL) --it is an organizational level schedule 
										OR
										(s.RefGroupId = U.GroupId)
									)
	select @AffectedRecords = @@rowcount
	insert into @stats values ('scheduled group has access' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

			if @BulkManualTemplateFlag = 1
			begin
				-- Special handling to check the duplicate plans for bulkmanual template uploads Should be updated whenever the matching criteria for bulkmanual template changes
				--this is because matching criteria 
				if OBJECT_ID('tempdb..#duplicateBMTPolicyAttributes') is not null drop table #duplicateBMTPolicyAttributes
					
						;WITH DuplicateCandidatesCTE (IndigoClientId, Policybusinessid, PolicyNumber, PortalReference, PolicyProviderName)
						AS
						(
							select distinct 
								sp.IndigoClientId, sp.Policybusinessid, 
								COALESCE(formattedpolicynumber,'') PolicyNumber,
								COALESCE(formattedPortalReference,'') PortalReference,
								COALESCE(REPLACE(PolicyProviderName,'-','') ,'') AS PolicyProviderName
							FROM #scheduledplans SP
									join TValPotentialPlan PP with (nolock)  on sp.indigoclientid = pp.indigoclientid and SP.PolicyBusinessId = PP.PolicyBusinessId
							where pp.eligibilitymask & @Bulk_PlanEligibility = @Bulk_PlanEligibility
						)
						select IndigoClientId, Policybusinessid, PolicyNumber, PortalReference, PolicyProviderName,
						ROW_NUMBER() OVER(PARTITION BY IndigoClientId, PolicyNumber, PortalReference, PolicyProviderName ORDER BY Policybusinessid) AS DuplicateCount
						into #duplicateBMTPolicyAttributes
						FROM DuplicateCandidatesCTE

					update SP
						set sp.EligibilityMask = SP.EligibilityMask + @SCHEDULEDPLANNOTDUPLICATE
						FROM #scheduledplans SP
						join TValPotentialPlan PP on sp.indigoclientid = pp.indigoclientid and SP.PolicyBusinessId = PP.PolicyBusinessId
							and not exists
								(select 1 from #duplicateBMTPolicyAttributes 
								where
								Indigoclientid = sp.Indigoclientid and
								coalesce(PP.formattedPolicyNumber,'') =   PolicyNumber and
								coalesce(PP.formattedPortalReference,'') =   PortalReference and
								coalesce(PP.PolicyProviderName,'') =   PolicyProviderName
								 and duplicatecount > 1)	

					select @AffectedRecords = @@rowcount
					insert into @stats values ('bulk manual duplicate check - set the duplicate flag' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
					select @timekeeper = getdate()
			end
			else
			begin
				
					if OBJECT_ID('tempdb..#duplicatePolicyAttributes') is not null drop table #duplicatePolicyAttributes
					
						;WITH DuplicateCandidatesCTE (IndigoClientId, ValScheduleId, Policybusinessid, PolicyNumber, PortalReference, AgencyNumber, Refplantype2ProdSubTypeId, PolicyProviderName)
						AS
						(
							select distinct PP.IndigoClientId, sp.ValScheduleId, pp.Policybusinessid, 
								CASE
									WHEN @MatchingMask & @MATCHING_PLANNUMBER =  @MATCHING_PLANNUMBER 
											OR @MatchingMask & @MATCHING_PLANNUMBER_CUSTOMERREFERENCE = @MATCHING_PLANNUMBER_CUSTOMERREFERENCE 
										THEN COALESCE(formattedPolicyNumber,'') 
									ELSE '' 
								END AS PolicyNumber,

								CASE
									WHEN @MatchingMask & @MATCHING_PORTALREFERENCE_PORTFOLIOTYPE = @MATCHING_PORTALREFERENCE_PORTFOLIOTYPE
											OR @MatchingMask & @MATCHING_PORTALREFERENCE_CUSTOMERREFERENCE = @MATCHING_PORTALREFERENCE_CUSTOMERREFERENCE 
										THEN COALESCE(formattedPortalReference,'') 
									ELSE '' 
								END AS PortalReference,

								CASE
									WHEN @MatchingMask & @MATCHING_AGENCYNUMBER = @MATCHING_AGENCYNUMBER 
										THEN COALESCE(AgencyNumber,'') 
									ELSE '' 
								END AS AgencyNumber,

								CASE
									WHEN @MatchingMask & @MATCHING_ADDITIONAL_AEGONCOFUNDRULES = @MATCHING_ADDITIONAL_AEGONCOFUNDRULES
										THEN COALESCE(Refplantype2ProdSubTypeId,0)
									ELSE 0
								END AS Refplantype2ProdSubTypeId,

							COALESCE(REPLACE(PolicyProviderName,'-','') ,'') AS PolicyProviderName
							FROM #scheduledplans SP
									join TValPotentialPlan PP with (nolock)  on sp.indigoclientid = pp.indigoclientid and SP.PolicyBusinessId = PP.PolicyBusinessId
							where 
								([Bulk] = 0 and pp.eligibilitymask & @PlanEligibility = @PlanEligibility)
								or
								([Bulk] = 1 and pp.eligibilitymask & @Bulk_PlanEligibility = @Bulk_PlanEligibility)
						)
						select IndigoClientId, Policybusinessid, ValScheduleId, PolicyNumber, PortalReference, AgencyNumber, PolicyProviderName, Refplantype2ProdSubTypeId,
						ROW_NUMBER() OVER(PARTITION BY IndigoClientId, ValScheduleId, PolicyNumber, PortalReference, AgencyNumber, PolicyProviderName, Refplantype2ProdSubTypeId
						ORDER BY Policybusinessid) AS DuplicateCount
						into #duplicatePolicyAttributes
						FROM DuplicateCandidatesCTE
					
					update SP
						set sp.EligibilityMask = SP.EligibilityMask + @SCHEDULEDPLANNOTDUPLICATE
					FROM #scheduledplans SP
						join TValPotentialPlan PP on sp.indigoclientid = pp.indigoclientid and  SP.PolicyBusinessId = PP.PolicyBusinessId  
						and not exists
							(select 1 from #duplicatePolicyAttributes where 
								Indigoclientid = sp.Indigoclientid and ValScheduleId = sp.ValScheduleId and
								coalesce(PP.formattedPolicyNumber,'') =   PolicyNumber and
								coalesce(PP.formattedPortalReference,'') =   PortalReference and
								coalesce(PP.AgencyNumber,'') =   AgencyNumber and 
								coalesce(PP.PolicyProviderName,'') =   PolicyProviderName and
								coalesce(PP.Refplantype2ProdSubTypeId,0) =   Refplantype2ProdSubTypeId and
								duplicatecount > 1)					

					select @AffectedRecords = @@rowcount
					insert into @stats values ('duplicate check - set the duplicate flag' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
					select @timekeeper = getdate()
			end


			if @ScheduleEligibility > 0 
			begin

				UPDATE SP SET [Status] = 1
				FROM [#scheduledplans] SP    
					JOIN  #EligibleSchedules ES ON SP.ValScheduleId = ES.ValScheduleId
					WHERE COALESCE(SP.EligibilityMask,0) & @ScheduleEligibility = @ScheduleEligibility 

					select @AffectedRecords = @@rowcount
					insert into @stats values ('scheduled plan eligibility count for those which has the criteria set' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
					select @timekeeper = getdate()
			end
			else
			begin
				UPDATE SP SET [Status] = 1
				FROM [#scheduledplans] SP    
					JOIN  #EligibleSchedules ES ON SP.ValScheduleId = ES.ValScheduleId

					select @AffectedRecords = @@rowcount
					insert into @stats values ('scheduled plan eligibility count for those which does not have the criteria' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
					select @timekeeper = getdate()
			end

	declare @ExistingNumberOfPolicies bigint, @NewNumberOfPolicies bigint

	IF OBJECT_ID('TEMPDB..#ExistingRecordCheckSum') IS NOT NULL 
			DROP TABLE #ExistingRecordCheckSum

		select sp.ValuationProviderId, SP.ValScheduleId, policybusinessid,
				binary_checksum
				(
					SP.ValScheduleId, policybusinessid,  sp.ValuationProviderId, SP.[Status], SP.[EligibilityMask], SP.[Remarks]
				) as 'BinaryCheckSum'
		into #ExistingRecordCheckSum
		from TValScheduledPlan SP
		join #EligibleSchedules ES on SP.ValScheduleId = es.ValScheduleId
		
	select @AffectedRecords = @@rowcount
	select @ExistingNumberOfPolicies = @AffectedRecords
	insert into @stats values ('finding check sum for plans already in TValScheduledPlan' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	IF OBJECT_ID('TEMPDB..#NewRecordCheckSum') IS NOT NULL 
			DROP TABLE #NewRecordCheckSum

		select es.ValuationProviderId, SP.Valscheduleid, policybusinessid, 
				binary_checksum
				(
					SP.Valscheduleid, policybusinessid, es.ValuationProviderId, SP.[Status], SP.[EligibilityMask], SP.[Remarks]
				) as 'BinaryCheckSum'
		into #NewRecordCheckSum
		from #scheduledplans SP
		join #EligibleSchedules ES on SP.ValScheduleId = es.ValScheduleId
			
	select @AffectedRecords = @@rowcount
	select @NewNumberOfPolicies = @AffectedRecords
	insert into @stats values ('finding check sum for new plans' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()
	
	create index idx_tmpNewRecordCheckSum on #NewRecordCheckSum (ValScheduleId, PolicyBusinessId, ValuationProviderId) include(BinaryCheckSum)
	create index idx_tmpExistingRecordCheckSum on #ExistingRecordCheckSum (ValScheduleId, PolicyBusinessId, ValuationProviderId) include(BinaryCheckSum)
	
	if @NewNumberOfPolicies = @ExistingNumberOfPolicies 
	begin
		if not exists (
					select 1 from 
						#NewRecordCheckSum n left join 
							#ExistingRecordCheckSum e on e.ValuationProviderId = n.ValuationProviderId 
															and e.Valscheduleid = n.ValScheduleId 
															and e.policybusinessid = n.PolicyBusinessId
						where coalesce(e.BinaryCheckSum,0) <> coalesce(n.BinaryCheckSum,0))
			begin
				insert into @stats values ('No plans eligibility had changed since last run - Process ends.',null,datediff(ms,@timekeeper,getdate()))
				select @timekeeper = getdate()
				goto errorhandling		
			end
	end

		update  T
			set t.status = s.status, t.eligibilitymask = s.eligibilitymask, t.remarks = s.remarks, ValuationProviderId = @ProviderId
		from 
			TValScheduledPlan T
				join #scheduledplans s on t.Valscheduleid = s.Valscheduleid and t.PolicyBusinessId = s.policybusinessid
				join #ExistingRecordCheckSum esum on  esum.Valscheduleid = t.Valscheduleid and t.policybusinessid = esum.policybusinessid
				join #NewRecordCheckSum nsum on  nsum.Valscheduleid = t.Valscheduleid and t.policybusinessid = nsum.policybusinessid
		where esum.BinaryCheckSum <> nsum.BinaryChecksum

	select @AffectedRecords = @@rowcount
	insert into @stats values ('Updating Plans' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

		insert into TValScheduledPlan
			(ValuationProviderId, ValScheduleId, PolicyBusinessId, EligibilityMask, EligibilityMaskRequiresUpdating, Status, Remarks, ConcurrencyId)
			select distinct @ProviderId, s.valscheduleid, s.PolicyBusinessId , s.eligibilitymask, 0, s.status, s.remarks, 1
		from 
			#scheduledplans S
				left join TValScheduledPlan T on t.Valscheduleid = s.Valscheduleid and t.policybusinessid = s.policybusinessid
			where t.policybusinessid is null

	select @AffectedRecords = @@rowcount
	insert into @stats values ('Inserting Plans' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()


		delete T
		from 
			#scheduledplans S
				right join TValScheduledPlan T on t.Valscheduleid = s.Valscheduleid and t.policybusinessid = s.policybusinessid
				join #EligibleSchedules ES on T.ValScheduleId = ES.ValScheduleId
			where s.policybusinessid is null

	select @AffectedRecords = @@rowcount
	insert into @stats values ('Deleting Plans' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	select @AffectedRecords = @@rowcount
	insert into @stats values ('eligible plans merged' ,@AffectedRecords,datediff(ms,@timekeeper,getdate()))
	select @timekeeper = getdate()

	update TValScheduledJobExecStats set JobEnd = getdate() where ValScheduledJobExecStatsID = @ValScheduledJobExecStatsID

    END TRY
    BEGIN CATCH
		SET @ErrorMessage = ERROR_MESSAGE()		
		insert into @stats values ('Err ' +  @ErrorMessage,null,datediff(ms,@timekeeper,getdate()))
		set @statsxml = (select * from (select * from @stats)  BulkValuationStats for xml auto, type)
		update TValScheduledJobExecStats set JobEnd = getdate(), JobStats = @statsxml where ValScheduledJobExecStatsID = @ValScheduledJobExecStatsID
		RAISERROR(@ErrorMessage, 16, 1)
    END CATCH

	errorhandling:
	set @statsxml = (select * from (select * from @stats)  BulkValuationStats for xml auto, type)
	update TValScheduledJobExecStats set JobEnd = getdate(), JobStats = @statsxml where ValScheduledJobExecStatsID = @ValScheduledJobExecStatsID

	SET NOCOUNT OFF
	SET XACT_ABORT OFF
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
GO

