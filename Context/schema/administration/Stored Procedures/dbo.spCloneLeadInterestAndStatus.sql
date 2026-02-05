SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneLeadInterestAndStatus] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Lead Statuses: Administration > Organization > Leads > Leads Admin
-- Lead Interest Areas: Administration > Organization > Leads > Interest Area Options
	set nocount on
	declare @ProcName sysname = OBJECT_NAME(@@PROCID),
		@procResult int
	exec @procResult = dbo.spStartCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName
	if @procResult!=0 return

	declare @tx int,
		@Now datetime = GetDate(),
		@msg varchar(max)

	select @tx = @@TRANCOUNT

	if @tx = 0 begin
			set @msg=@ProcName+': begin transaction TX'
			raiserror(@msg,0,1) with nowait
			begin transaction TX
		end

	begin try
		if object_id('tempdb..#Groups') is not null drop table #Groups
		create table #Groups(SourceGroupId int, SourceParentId int, TargetGroupId int, TargetParentId int)

		insert into #Groups(SourceGroupId, SourceParentId, TargetGroupId)
		select sgr.GroupId, sgr.ParentId, dgr.GroupId
		from Administration..TGroup sgr with(nolock)
			inner join Administration..TGroup dgr with(nolock) on dgr.Identifier = sgr.Identifier and dgr.IndigoClientId = @IndigoClientId
		where sgr.IndigoClientId = @SourceIndigoClientId

		update a
		set a.TargetParentId = b.TargetGroupId
		from #Groups a
		inner join #Groups b on b.SourceGroupId = a.SourceParentId

		-- crm.dbo.TRefServiceStatus
		update a
			set a.IsArchived = b.IsArchived,
				a.IsPropagated = b.IsPropagated,
				a.ReportFrequency = b.ReportFrequency,
				a.ReportStartDateType = b.ReportStartDateType,
				a.ReportStartDate = b.ReportStartDate,
				a.GroupId = g.TargetGroupId,
				a.ConcurrencyId +=1
		output
			inserted.RefServiceStatusId, inserted.ServiceStatusName, inserted.IndigoClientId, inserted.ConcurrencyId, inserted.IsArchived, inserted.GroupId,
			inserted.IsPropagated, inserted.ReportFrequency, inserted.ReportStartDateType, inserted.ReportStartDate
			,'U', @Now, @StampUser
		into crm.dbo.TRefServiceStatusAudit(RefServiceStatusId, ServiceStatusName, IndigoClientId, ConcurrencyId, IsArchived, GroupId,
		IsPropagated, ReportFrequency, ReportStartDateType, ReportStartDate
			, StampAction, StampDateTime, StampUser)
		from crm.dbo.TRefServiceStatus a
			inner join crm.dbo.TRefServiceStatus b on b.ServiceStatusName = a.ServiceStatusName and b.IndigoClientId = @SourceIndigoClientId
			left join #Groups g on g.SourceGroupId = a.GroupId
		where a.IndigoClientId = @IndigoClientId

		insert into crm.dbo.TRefServiceStatus(ServiceStatusName, IndigoClientId, ConcurrencyId, IsArchived, GroupId, IsPropagated, ReportFrequency, ReportStartDateType, ReportStartDate)
		output
			inserted.RefServiceStatusId, inserted.ServiceStatusName, inserted.IndigoClientId, inserted.ConcurrencyId, inserted.IsArchived, inserted.GroupId,
			inserted.IsPropagated, inserted.ReportFrequency, inserted.ReportStartDateType, inserted.ReportStartDate
			,'C', @Now, @StampUser
		into crm.dbo.TRefServiceStatusAudit(
			RefServiceStatusId, ServiceStatusName, IndigoClientId, ConcurrencyId, IsArchived, GroupId,
			IsPropagated, ReportFrequency, ReportStartDateType, ReportStartDate
			, StampAction, StampDateTime, StampUser)

		select ServiceStatusName, @IndigoClientId, 1, IsArchived, g.TargetGroupId, IsPropagated, ReportFrequency, ReportStartDateType, ReportStartDate
		from crm.dbo.TRefServiceStatus a
			left join #Groups g on g.SourceGroupId = a.GroupId
		where IndigoClientId = @SourceIndigoClientId
		except
		select ServiceStatusName, IndigoClientId, 1, IsArchived, GroupId, IsPropagated, ReportFrequency, ReportStartDateType, ReportStartDate
		from crm.dbo.TRefServiceStatus a
		where IndigoClientId = @IndigoClientId

		-- TLeadStatus
		update a
		set a.CanConvertToClientFG = b.CanConvertToClientFG,
			a.OrderNumber = b.OrderNumber,
			a.RefServiceStatusId = Servt.RefServiceStatusId,
			a.ConcurrencyId+=1
		output
			inserted.LeadStatusId
			, inserted.Descriptor
			, inserted.CanConvertToClientFG
			, inserted.OrderNumber
			, inserted.IndigoClientId
			, inserted.ConcurrencyId
			, inserted.RefServiceStatusId
			,'U', @Now, @StampUser
		into CRM.dbo.TLeadStatusAudit(
			LeadStatusId
			, Descriptor
			, CanConvertToClientFG
			, OrderNumber
			, IndigoClientId
			, ConcurrencyId
			, RefServiceStatusId
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TLeadStatus a
		inner join CRM.dbo.TLeadStatus b on b.Descriptor = a.Descriptor and b.IndigoClientId = @SourceIndigoClientId
		left join crm.dbo.TRefServiceStatus ServS on ServS.RefServiceStatusId = b.RefServiceStatusId and ServS.IndigoClientId = @SourceIndigoClientId
		left join crm.dbo.TRefServiceStatus Servt on ServT.ServiceStatusName = ServS.ServiceStatusName and Servt.IndigoClientId = @IndigoClientId
		where a.IndigoClientId = @IndigoClientId


		insert into CRM.dbo.TLeadStatus(Descriptor, CanConvertToClientFG, OrderNumber, IndigoClientId, ConcurrencyId, RefServiceStatusId)
		output
			inserted.LeadStatusId
			, inserted.Descriptor
			, inserted.CanConvertToClientFG
			, inserted.OrderNumber
			, inserted.IndigoClientId
			, inserted.ConcurrencyId
			, inserted.RefServiceStatusId
			,'C', @Now, @StampUser
		into CRM.dbo.TLeadStatusAudit(
			LeadStatusId
			, Descriptor
			, CanConvertToClientFG
			, OrderNumber
			, IndigoClientId
			, ConcurrencyId
			, RefServiceStatusId
			, StampAction, StampDateTime, StampUser)
		select Descriptor, CanConvertToClientFG, OrderNumber, @IndigoClientId, 1, Servt.RefServiceStatusId
		from CRM.dbo.TLeadStatus lss
			left join crm.dbo.TRefServiceStatus ServS on ServS.RefServiceStatusId = lss.RefServiceStatusId and ServS.IndigoClientId = @SourceIndigoClientId
			inner join crm.dbo.TRefServiceStatus Servt on ServS.ServiceStatusName = ServT.ServiceStatusName and Servt.IndigoClientId = @IndigoClientId
		where lss.IndigoClientId = @SourceIndigoClientId
			and not exists(select 1 from CRM.dbo.TLeadStatus lst where lst.Descriptor = lss.Descriptor and lst.IndigoClientId = @IndigoClientId)


		-- "Move down" any duplicate OrderNumber
		while (1=1) begin
			;with duplicates
			as (select *,
				row_number() OVER ( PARTITION BY IndigoClientId, OrderNumber
				ORDER BY LeadStatusId) AS nr
				from crm.dbo.TLeadStatus with(nolock)
				where IndigoClientId = @IndigoClientId
			)
			update duplicates
			set OrderNumber += 1
			where nr > 1

			if @@ROWCOUNT = 0 break
		end


		--TLeadStatusToRole
		-- Remove roles not associated
		delete a
		output deleted.LeadStatusToRoleId, deleted.LeadStatusId, deleted.RoleId, deleted.TenantId, deleted.ConcurrencyId
			, 'D', @Now, @StampUser
		into CRM.dbo.TLeadStatusToRoleAudit (
			LeadStatusToRoleId, LeadStatusId, RoleId, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		from CRM.dbo.TLeadStatusToRole a
			inner join CRM.dbo.TLeadStatus lst on lst.LeadStatusId = a.LeadStatusId and lst.IndigoClientId = @IndigoClientId
			inner join Administration.dbo.TRole rt on rt.RoleId = a.RoleId and rt.IndigoClientId = @IndigoClientId
		where a.TenantId = @IndigoClientId
		and not exists (select 1 from CRM.dbo.TLeadStatusToRole b
			inner join CRM.dbo.TLeadStatus lss on lss.LeadStatusId = b.LeadStatusId and lss.IndigoClientId = @SourceIndigoClientId
			inner join Administration.dbo.TRole rs on rs.RoleId = b.RoleId and rs.IndigoClientId = @SourceIndigoClientId
			where b.TenantId = @SourceIndigoClientId
				and lss.Descriptor = lst.Descriptor
				and rs.Identifier = rt.Identifier)

		insert into CRM.dbo.TLeadStatusToRole(LeadStatusId, RoleId, TenantId, ConcurrencyId)
		output inserted.LeadStatusToRoleId, inserted.LeadStatusId, inserted.RoleId, inserted.TenantId, inserted.ConcurrencyId
			, 'C', @Now, @StampUser
		into CRM.dbo.TLeadStatusToRoleAudit (
			LeadStatusToRoleId, LeadStatusId, RoleId, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select lt.LeadStatusId, rt.RoleId, @IndigoClientId, 1
		from CRM.dbo.TLeadStatusToRole a
		inner join CRM.dbo.TLeadStatus ls on ls.LeadStatusId = a.LeadStatusId and ls.IndigoClientId = @SourceIndigoClientId
		inner join Administration.dbo.TRole rs on rs.RoleId = a.RoleId and rs.IndigoClientId = @SourceIndigoClientId
		inner join CRM.dbo.TLeadStatus lt on lt.Descriptor = ls.Descriptor and lt.IndigoClientId = @IndigoClientId
		inner join Administration.dbo.TRole rt on rt.Identifier = rs.Identifier and rt.IndigoClientId = @IndigoClientId
		where TenantId = @SourceIndigoClientId
		except
		select LeadStatusId, RoleId, TenantId, 1
		from CRM.dbo.TLeadStatusToRole
		where TenantId = @IndigoClientId

		-- crm.dbo.TRefInterest
		update a
		set a.OpportunityCreationFg = b.OpportunityCreationFg,
			a.Probability = b.Probability,
			a.LeadVersionFG = b.LeadVersionFG,
			a.ArchiveFG = b.ArchiveFG,
			a.Ordinal = b.Ordinal,
			a.SystemFG = b.SystemFG,
			a.DefaultFG = b.DefaultFG,
			a.OpportunityTypeId = ott.OpportunityTypeId,
			a.ConcurrencyId += 1
		output
			inserted.RefInterestId, inserted.Descriptor, inserted.Interest, inserted.OpportunityTypeId, inserted.OpportunityCreationFg, inserted.Probability,
			inserted.LeadVersionFG, inserted.IndigoClientId, inserted.ConcurrencyId, inserted.ArchiveFG, inserted.Ordinal, inserted.SystemFG, inserted.DefaultFG
			,'U', @Now, @StampUser
		into crm.dbo.TRefInterestAudit(RefInterestId, Descriptor, Interest, OpportunityTypeId, OpportunityCreationFg, Probability, LeadVersionFG, IndigoClientId, ConcurrencyId, ArchiveFG, Ordinal, SystemFG, DefaultFG
			, StampAction, StampDateTime, StampUser)
		from crm.dbo.TRefInterest a
			inner join crm.dbo.TRefInterest b on b.Descriptor = a.Descriptor and isnull(b.Interest,'') = Isnull(a.Interest,'') and b.IndigoClientId = @SourceIndigoClientId
			left join CRM.dbo.TOpportunityType ots on ots.OpportunityTypeId = b.OpportunityTypeId and ots.IndigoClientId = @SourceIndigoClientId
			left join CRM.dbo.TOpportunityType ott on ott.OpportunityTypeName = ots.OpportunityTypeName and ott.IndigoClientId = @IndigoClientId
		where a.IndigoClientId = @IndigoClientId
			and a.OpportunityTypeId is null
			and b.OpportunityTypeId is null
			and (a.OpportunityCreationFg != b.OpportunityCreationFg
				or a.Probability != b.Probability
				or a.LeadVersionFG != b.LeadVersionFG
				or a.ArchiveFG != b.ArchiveFG
				or a.Ordinal != b.Ordinal
				or a.SystemFG != b.SystemFG
				or a.DefaultFG != b.DefaultFG)

		insert into crm.dbo.TRefInterest(Descriptor, Interest, OpportunityTypeId, OpportunityCreationFg, Probability, LeadVersionFG, IndigoClientId, ConcurrencyId, ArchiveFG, Ordinal, SystemFG, DefaultFG)
		output
			inserted.RefInterestId, inserted.Descriptor, inserted.Interest, inserted.OpportunityTypeId, inserted.OpportunityCreationFg, inserted.Probability,
			inserted.LeadVersionFG, inserted.IndigoClientId, inserted.ConcurrencyId, inserted.ArchiveFG, inserted.Ordinal, inserted.SystemFG, inserted.DefaultFG
			,'C', @Now, @StampUser
		into crm.dbo.TRefInterestAudit(RefInterestId, Descriptor, Interest, OpportunityTypeId, OpportunityCreationFg, Probability, LeadVersionFG, IndigoClientId, ConcurrencyId, ArchiveFG, Ordinal, SystemFG, DefaultFG
			, StampAction, StampDateTime, StampUser)

		select Descriptor, Interest, c.OpportunityTypeId, OpportunityCreationFg, Probability, LeadVersionFG, @IndigoClientId, 1, a.ArchiveFG, Ordinal, a.SystemFG, DefaultFG
		from crm.dbo.TRefInterest a
			left join crm.dbo.TOpportunityType b on b.OpportunityTypeId = a.OpportunityTypeId and b.IndigoClientId = @SourceIndigoClientId
			left join crm.dbo.TOpportunityType c on c.OpportunityTypeName = b.OpportunityTypeName and c.IndigoClientId = @IndigoClientId
		where a.IndigoClientId = @SourceIndigoClientId
		except
		select Descriptor, Interest, OpportunityTypeId, OpportunityCreationFg, Probability, LeadVersionFG, IndigoClientId, 1, ArchiveFG, Ordinal, SystemFG, DefaultFG
		from crm.dbo.TRefInterest
		where IndigoClientId = @IndigoClientId

		---- "Move down" any duplicate Ordinal
		--while (1=1) begin
		--	;with duplicates
		--	as (select *,
		--		row_number() OVER ( PARTITION BY IndigoClientId, Ordinal
		--		ORDER BY RefInterestId) AS nr
		--		from crm.dbo.TRefInterest with(nolock)
		--		where IndigoClientId = @IndigoClientId
		--	)
		--	update duplicates
		--	set Ordinal += 1
		--	where nr > 1

		--	if @@ROWCOUNT = 0 break
		--end

		if @tx = 0 begin
			commit transaction TX
			set @msg=@ProcName+': commit transaction TX'
			raiserror(@msg,0,1) with nowait
		end

		exec dbo.spStopCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName

	end try
	begin catch
		declare @Errmsg varchar(max) = @ProcName+'
'+ERROR_MESSAGE()

		if @tx = 0 begin
			set @msg=@ProcName+': rollback transaction TX'
			raiserror(@msg,0,1) with nowait
			rollback transaction TX
		end
		raiserror(@Errmsg,16,1)
	end catch
end
GO
