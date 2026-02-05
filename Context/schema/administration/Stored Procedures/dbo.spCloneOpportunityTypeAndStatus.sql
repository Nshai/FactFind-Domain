create proc dbo.spCloneOpportunityTypeAndStatus @IndigoClientId int, @SourceIndigoClientId int, @RegionCode nvarchar(max) null, @StampUser varchar(255) = '-1010'
as
begin
	set nocount on
	declare @ProcName sysname = OBJECT_NAME(@@PROCID),
		@procResult int
	exec @procResult = dbo.spStartCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName
	if @procResult!=0 return

	declare @tx int,
		@Now datetime = GetDate()

	select @tx = @@TRANCOUNT

	if @tx = 0 begin
			print @ProcName+': begin transaction TX'
			begin transaction TX
		end

	begin try

		if object_id('tempdb..#OpportunityStatusSource') is not null drop table #OpportunityStatusSource
		if object_id('tempdb..#OpportunityStatusTarget') is not null drop table #OpportunityStatusTarget

		create table #OpportunityStatusSource(ID int identity(1,1), OpportunityStatusId int, OpportunityStatusName varchar(255), InitialStatusFG bit, ArchiveFG bit, AutoCloseOpportunityFg bit, OpportunityStatusTypeId int)
		create table #OpportunityStatusTarget(ID int identity(1,1), OpportunityStatusId int, OpportunityStatusName varchar(255), InitialStatusFG bit, ArchiveFG bit, AutoCloseOpportunityFg bit, OpportunityStatusTypeId int)


		insert into #OpportunityStatusSource(OpportunityStatusId, OpportunityStatusName, InitialStatusFG, ArchiveFG, AutoCloseOpportunityFg, OpportunityStatusTypeId)
		select OpportunityStatusId, OpportunityStatusName, InitialStatusFG, ArchiveFG, AutoCloseOpportunityFg, OpportunityStatusTypeId
		from crm.dbo.TOpportunityStatus
		where IndigoClientId = @SourceIndigoClientId
		order by OpportunityStatusId

		insert into #OpportunityStatusTarget(OpportunityStatusId, OpportunityStatusName, InitialStatusFG, ArchiveFG, AutoCloseOpportunityFg, OpportunityStatusTypeId)
		select OpportunityStatusId, OpportunityStatusName, InitialStatusFG, ArchiveFG, AutoCloseOpportunityFg, OpportunityStatusTypeId
		from crm.dbo.TOpportunityStatus
		where IndigoClientId = @IndigoClientId
		order by OpportunityStatusId

		-- crm.dbo.TOpportunityStatus
		update a
		set
			a.OpportunityStatusName = oss.OpportunityStatusName,
			a.ArchiveFG = oss.ArchiveFG,
			a.InitialStatusFG = oss.InitialStatusFG,
			a.AutoCloseOpportunityFg = oss.AutoCloseOpportunityFg,
			a.OpportunityStatusTypeId = oss.OpportunityStatusTypeId,
			ConcurrencyId +=1
		output
			inserted.OpportunityStatusId, inserted.OpportunityStatusName, inserted.IndigoClientId, inserted.InitialStatusFG, inserted.ArchiveFG, inserted.AutoCloseOpportunityFg, inserted.OpportunityStatusTypeId, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into crm.dbo.TOpportunityStatusAudit(OpportunityStatusId, OpportunityStatusName, IndigoClientId, InitialStatusFG, ArchiveFG, AutoCloseOpportunityFg, OpportunityStatusTypeId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from crm.dbo.TOpportunityStatus a
		inner join #OpportunityStatusTarget ost on ost.OpportunityStatusId = a.OpportunityStatusId
		inner join #OpportunityStatusSource oss on oss.Id = ost.Id
		where a.IndigoClientId = @IndigoClientId
			and (
				a.OpportunityStatusName!=oss.OpportunityStatusName
				or a.ArchiveFG != oss.ArchiveFG
				or a.InitialStatusFG != oss.InitialStatusFG
				or a.AutoCloseOpportunityFg != oss.AutoCloseOpportunityFg
				or a.OpportunityStatusTypeId != oss.OpportunityStatusTypeId
			)


		insert into crm.dbo.TOpportunityStatus(OpportunityStatusName, IndigoClientId, InitialStatusFG, ArchiveFG, AutoCloseOpportunityFg, OpportunityStatusTypeId, ConcurrencyId)
		output
			inserted.OpportunityStatusId, inserted.OpportunityStatusName, inserted.IndigoClientId, inserted.InitialStatusFG, inserted.ArchiveFG, inserted.AutoCloseOpportunityFg, inserted.OpportunityStatusTypeId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into crm.dbo.TOpportunityStatusAudit(OpportunityStatusId, OpportunityStatusName, IndigoClientId, InitialStatusFG, ArchiveFG, AutoCloseOpportunityFg, OpportunityStatusTypeId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select OpportunityStatusName, @IndigoClientId, InitialStatusFG, ArchiveFG, AutoCloseOpportunityFg, OpportunityStatusTypeId, 1
		from crm.dbo.TOpportunityStatus
		where IndigoClientId = @SourceIndigoClientId
		except
		select OpportunityStatusName, IndigoClientId, InitialStatusFG, ArchiveFG, AutoCloseOpportunityFg, OpportunityStatusTypeId, 1
		from crm.dbo.TOpportunityStatus
		where IndigoClientId = @IndigoClientId

		-- remove remaining extra OpportunityStatus
		delete ost
		output
			deleted.OpportunityStatusId, deleted.OpportunityStatusName, deleted.IndigoClientId, deleted.InitialStatusFG, deleted.ArchiveFG, deleted.AutoCloseOpportunityFg, deleted.OpportunityStatusTypeId, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into crm.dbo.TOpportunityStatusAudit(OpportunityStatusId, OpportunityStatusName, IndigoClientId, InitialStatusFG, ArchiveFG, AutoCloseOpportunityFg, OpportunityStatusTypeId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from crm.dbo.TOpportunityStatus ost 
		left join crm.dbo.TOpportunityStatus oss on oss.OpportunityStatusName = ost.OpportunityStatusName and oss.InitialStatusFG = ost.InitialStatusFG and oss.AutoCloseOpportunityFg = ost.AutoCloseOpportunityFg 
			and oss.OpportunityStatusTypeId = ost.OpportunityStatusTypeId 
			and oss.IndigoClientId = @SourceIndigoClientId
		where ost.IndigoClientId = @IndigoClientId
		and oss.OpportunityStatusId is null

		if object_id('tempdb..#OpportunityStatusSource') is not null drop table #OpportunityStatusSource
		if object_id('tempdb..#OpportunityStatusTarget') is not null drop table #OpportunityStatusTarget

		-- crm.dbo.TOpportunityType
		update a
		set a.ArchiveFG = b.ArchiveFG,
			a.InvestmentDefault = b.InvestmentDefault,
			a.RetirementDefault = b.RetirementDefault,
			a.ConcurrencyId +=1
		output
			inserted.OpportunityTypeId, inserted.OpportunityTypeName, inserted.IndigoClientId, inserted.ArchiveFG, inserted.SystemFG, inserted.InvestmentDefault, inserted.RetirementDefault, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into crm.dbo.TOpportunityTypeAudit(OpportunityTypeId, OpportunityTypeName, IndigoClientId, ArchiveFG, SystemFG, InvestmentDefault, RetirementDefault, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		from crm.dbo.TOpportunityType a
		inner join crm.dbo.TOpportunityType b on b.OpportunityTypeName = a.OpportunityTypeName and b.IndigoClientId = @SourceIndigoClientId
		where a.IndigoClientId = @IndigoClientId
			and a.SystemFG = b.SystemFG
			and (a.ArchiveFG != b.ArchiveFG
			or a.InvestmentDefault != b.InvestmentDefault
			or a.RetirementDefault != b.RetirementDefault)


		insert into crm.dbo.TOpportunityType(OpportunityTypeName, IndigoClientId, ArchiveFG, SystemFG, InvestmentDefault, RetirementDefault, ConcurrencyId)
		output
			inserted.OpportunityTypeId, inserted.OpportunityTypeName, inserted.IndigoClientId, inserted.ArchiveFG, inserted.SystemFG, inserted.InvestmentDefault, inserted.RetirementDefault, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into crm.dbo.TOpportunityTypeAudit(OpportunityTypeId, OpportunityTypeName, IndigoClientId, ArchiveFG, SystemFG, InvestmentDefault, RetirementDefault, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select OpportunityTypeName, @IndigoClientId, ArchiveFG, SystemFG, InvestmentDefault, RetirementDefault, 1
		from crm.dbo.TOpportunityType
		where IndigoClientId = @SourceIndigoClientId
		except
		select OpportunityTypeName, IndigoClientId, ArchiveFG, SystemFG, InvestmentDefault, RetirementDefault, 1
		from crm.dbo.TOpportunityType
		where IndigoClientId = @IndigoClientId

		-- remove remaining extra OpportunityType
		delete ott
		output
			deleted.OpportunityTypeId, deleted.OpportunityTypeName, deleted.IndigoClientId, deleted.ArchiveFG, deleted.SystemFG, deleted.InvestmentDefault, deleted.RetirementDefault, deleted.ConcurrencyId
			,'D', GETDATE(), @StampUser
		into crm.dbo.TOpportunityTypeAudit(OpportunityTypeId, OpportunityTypeName, IndigoClientId, ArchiveFG, SystemFG, InvestmentDefault, RetirementDefault, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from crm.dbo.TOpportunityType ott
		left join crm.dbo.TOpportunityType ots on ots.OpportunityTypeName = ott.OpportunityTypeName and ots.ArchiveFG = ott.ArchiveFG 
			and ots.SystemFg = ott.SystemFg and ots.InvestmentDefault = ott.InvestmentDefault and ots.RetirementDefault = ott.RetirementDefault 
			and ots.IndigoClientId  = @SourceIndigoClientId
		where ott.IndigoClientId = @IndigoClientId 
			and ots.OpportunityTypeId is null

		-- TPropositionType
		update a
		set a.IsArchived = b.IsArchived,
			a.ConcurrencyId+=1
		output
			inserted.PropositionTypeId, inserted.PropositionTypeName, inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId
			,'U', @Now, @StampUser
		into CRM.dbo.TPropositionTypeAudit(PropositionTypeId,PropositionTypeName,TenantId,IsArchived,ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TPropositionType a
			inner join CRM.dbo.TPropositionType b on b.PropositionTypeName = a.PropositionTypeName and b.TenantId = @SourceIndigoClientId
		where a.TenantId = @IndigoClientId
			and a.IsArchived != b.IsArchived

		insert into CRM.dbo.TPropositionType(PropositionTypeName, TenantId, IsArchived, ConcurrencyId)
		output
			inserted.PropositionTypeId, inserted.PropositionTypeName, inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into CRM.dbo.TPropositionTypeAudit(PropositionTypeId,PropositionTypeName,TenantId,IsArchived,ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select PropositionTypeName, @IndigoClientId, IsArchived, 1
		from CRM.dbo.TPropositionType
		where TenantId = @SourceIndigoClientId
		except
		select PropositionTypeName, TenantId, IsArchived, 1
		from CRM.dbo.TPropositionType
		where TenantId = @IndigoClientId

		-- TPropositionToOpportunityTypeLink
		delete pot
		output
			deleted.PropositionToOpportunityTypeLinkId, deleted.PropositionTypeId, deleted.OpportunityTypeId, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into CRM.dbo.TPropositionToOpportunityTypeLinkAudit(
			PropositionToOpportunityTypeLinkId, PropositionTypeId, OpportunityTypeId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TPropositionToOpportunityTypeLink pot
			inner join CRM.dbo.TPropositionType ptt on pot.PropositionTypeId=ptt.PropositionTypeId and ptt.TenantId = @IndigoClientId
			inner join CRM.dbo.TOpportunityType ott on pot.OpportunityTypeId=ott.OpportunityTypeId and ott.IndigoClientId = @IndigoClientId
		where not exists (select 1 from CRM.dbo.TPropositionToOpportunityTypeLink pos
			inner join CRM.dbo.TPropositionType pts on pos.PropositionTypeId=pts.PropositionTypeId and pts.TenantId = @SourceIndigoClientId
			inner join CRM.dbo.TOpportunityType ots on pos.OpportunityTypeId=ots.OpportunityTypeId and ots.IndigoClientId = @SourceIndigoClientId
		where pts.PropositionTypeName = ptt.PropositionTypeName
			and ots.OpportunityTypeName = ott.OpportunityTypeName
		)


		insert into CRM.dbo.TPropositionToOpportunityTypeLink(PropositionTypeId, OpportunityTypeId, ConcurrencyId)
		output
			inserted.PropositionToOpportunityTypeLinkId, inserted.PropositionTypeId, inserted.OpportunityTypeId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into CRM.dbo.TPropositionToOpportunityTypeLinkAudit(
			PropositionToOpportunityTypeLinkId, PropositionTypeId, OpportunityTypeId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select ptt.PropositionTypeId, ott.OpportunityTypeId, 1
		from CRM.dbo.TPropositionType ptt
			inner join CRM.dbo.TPropositionType pts on pts.PropositionTypeName = ptt.PropositionTypeName and pts.TenantId = @SourceIndigoClientId
			inner join CRM.dbo.TPropositionToOpportunityTypeLink pos on pos.PropositionTypeId = pts.PropositionTypeId
			inner join CRM.dbo.TOpportunityType ots on pos.OpportunityTypeId=ots.OpportunityTypeId and ots.IndigoClientId = @SourceIndigoClientId
			inner join CRM.dbo.TOpportunityType ott on ott.OpportunityTypeName = ots.OpportunityTypeName and ott.IndigoClientId = @IndigoClientId
		where ptt.TenantId = @IndigoClientId
		except
		select pot.PropositionTypeId, pot.OpportunityTypeId, 1
		from CRM.dbo.TPropositionToOpportunityTypeLink pot
			inner join CRM.dbo.TPropositionType ptt on pot.PropositionTypeId=ptt.PropositionTypeId and ptt.TenantId = @IndigoClientId
			inner join CRM.dbo.TOpportunityType ott on pot.OpportunityTypeId=ott.OpportunityTypeId and ott.IndigoClientId = @IndigoClientId

		-- TPropositionToRefPlanTypeProductSubType
		delete a
		output
			deleted.PropositionToRefPlanTypeProductSubTypeId, deleted.TenantId, deleted.PropositionTypeId, deleted.RefPlanType2ProdSubTypeId, deleted.ConcurrencyId
			,'D', @Now, @StampUser
		into CRM.dbo.TPropositionToRefPlanTypeProductSubTypeAudit(
			PropositionToRefPlanTypeProductSubTypeId, TenantId, PropositionTypeId, RefPlanType2ProdSubTypeId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TPropositionToRefPlanTypeProductSubType a
			inner join CRM.dbo.TPropositionType ptt on ptt.PropositionTypeId = a.PropositionTypeId and ptt.TenantId = @IndigoClientId
			inner join PolicyManagement.dbo.TRefPlanType2ProdSubType rptstt on rptstt.RefPlanType2ProdSubTypeId = a.RefPlanType2ProdSubTypeId
			inner join PolicyManagement.dbo.TRefPlanType rptt on rptt.RefPlanTypeId = rptstt.RefPlanTypeId
		WHERE a.TenantId = @IndigoClientId and rptstt.RegionCode = @RegionCode
		and
		(not exists (select * from CRM.dbo.TPropositionToRefPlanTypeProductSubType b
			inner join PolicyManagement.dbo.TRefPlanType2ProdSubType rptsts on rptsts.RefPlanType2ProdSubTypeId = b.RefPlanType2ProdSubTypeId
			inner join CRM.dbo.TPropositionType pts on pts.PropositionTypeId = b.PropositionTypeId and pts.TenantId = @SourceIndigoClientId
			WHERE b.TenantId = @SourceIndigoClientId and rptsts.RegionCode = @RegionCode
				and pts.PropositionTypeName = ptt.PropositionTypeName)
		or not exists (select * from CRM.dbo.TPropositionToRefPlanTypeProductSubType b
			inner join PolicyManagement.dbo.TRefPlanType2ProdSubType rptsts on rptsts.RefPlanType2ProdSubTypeId = b.RefPlanType2ProdSubTypeId
			inner join PolicyManagement.dbo.TRefPlanType rpts on rpts.RefPlanTypeId = rptsts.RefPlanTypeId
			WHERE b.TenantId = @SourceIndigoClientId and rptsts.RegionCode = @RegionCode
				and rpts.PlanTypeName = rptt.PlanTypeName)
		)

		insert into CRM.dbo.TPropositionToRefPlanTypeProductSubType(TenantId, PropositionTypeId, RefPlanType2ProdSubTypeId, ConcurrencyId)
		output
			inserted.PropositionToRefPlanTypeProductSubTypeId, inserted.TenantId, inserted.PropositionTypeId, inserted.RefPlanType2ProdSubTypeId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into CRM.dbo.TPropositionToRefPlanTypeProductSubTypeAudit(
			PropositionToRefPlanTypeProductSubTypeId, TenantId, PropositionTypeId, RefPlanType2ProdSubTypeId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @IndigoClientId, ptt.PropositionTypeId, a.RefPlanType2ProdSubTypeId, 1
		from CRM.dbo.TPropositionToRefPlanTypeProductSubType a
			inner join PolicyManagement.dbo.TRefPlanType2ProdSubType refplantyp1_ on a.RefPlanType2ProdSubTypeId=refplantyp1_.RefPlanType2ProdSubTypeId
			inner join PolicyManagement.dbo.TRefPlanType rpt on refplantyp1_.RefPlanTypeId=rpt.RefPlanTypeId
			inner join CRM.dbo.TPropositionType pts on pts.PropositionTypeId = a.PropositionTypeId and pts.TenantId = @SourceIndigoClientId
			inner join CRM.dbo.TPropositionType ptt on ptt.PropositionTypeName = pts.PropositionTypeName and ptt.TenantId = @IndigoClientId
		WHERE a.TenantId = @SourceIndigoClientId and refplantyp1_.RegionCode = @RegionCode
		except
		select a.TenantId, a.PropositionTypeId, a.RefPlanType2ProdSubTypeId, 1
		from CRM.dbo.TPropositionToRefPlanTypeProductSubType a
			inner join PolicyManagement.dbo.TRefPlanType2ProdSubType refplantyp1_ on a.RefPlanType2ProdSubTypeId=refplantyp1_.RefPlanType2ProdSubTypeId
			inner join PolicyManagement.dbo.TRefPlanType rpt on refplantyp1_.RefPlanTypeId=rpt.RefPlanTypeId
			inner join CRM.dbo.TPropositionType pt on pt.PropositionTypeId = a.PropositionTypeId and pt.TenantId = @IndigoClientId
		WHERE a.TenantId = @IndigoClientId and refplantyp1_.RegionCode = @RegionCode

		if @tx = 0 begin
			commit transaction TX
			print @ProcName+': commit transaction TX'
		end

		exec dbo.spStopCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName

	end try
	begin catch
		if @tx = 0 begin
			declare @msg varchar(max) = ERROR_MESSAGE()
			print @ProcName+': rollback transaction TX'
			rollback transaction TX
			RAISERROR(@msg,16,1)
		end
	end catch


end

GO
