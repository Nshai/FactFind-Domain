SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneActivityOutcomes] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Administration > Organization > Reference Data > Activity Outcomes
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
		-- crm.dbo.TActivityCategoryParent
		update a
		set a.IsArchived = b.IsArchived
		output
			inserted.ActivityCategoryParentId, inserted.[Name], inserted.IndigoClientId, inserted.ConcurrencyId, inserted.IsArchived
			,'U', @Now, @StampUser
		into crm.dbo.TActivityCategoryParentAudit(ActivityCategoryParentId, [Name], IndigoClientId, ConcurrencyId, IsArchived
			, StampAction, StampDateTime, StampUser)
		from crm.dbo.TActivityCategoryParent a
		inner join crm.dbo.TActivityCategoryParent b on b.[Name] = a.[Name] and b.IndigoClientId = @SourceIndigoClientId
		where a.IndigoClientId = @IndigoClientId
		and a.IsArchived != b.IsArchived

		insert into crm.dbo.TActivityCategoryParent([Name], IndigoClientId, ConcurrencyId, IsArchived)
		output
			inserted.ActivityCategoryParentId, inserted.[Name], inserted.IndigoClientId, inserted.ConcurrencyId, inserted.IsArchived
			,'C', @Now, @StampUser
		into crm.dbo.TActivityCategoryParentAudit(ActivityCategoryParentId, [Name], IndigoClientId, ConcurrencyId, IsArchived
			, StampAction, StampDateTime, StampUser)
		select Name, @IndigoClientId, 1, IsArchived
		from crm.dbo.TActivityCategoryParent
		where IndigoClientId = @SourceIndigoClientId
		except
		select [Name], IndigoClientId, 1, IsArchived
		from crm.dbo.TActivityCategoryParent
		where IndigoClientId = @IndigoClientId

		-- Before removing duplicates, update children
		;with duplicates as (
			select *, row_number() over ( partition BY [Name] order by [Name], ActivityCategoryParentId ) AS nr
			from crm.dbo.TActivityCategoryParent with (nolock)
			where IndigoClientId = @IndigoClientId
		)
		update a set a.ActivityCategoryParentId = org.ActivityCategoryParentId
		from crm.dbo.TActivityCategory a
		inner join duplicates dup on dup.ActivityCategoryParentId = a.ActivityCategoryParentId and dup.IndigoClientId = a.IndigoClientId and dup.nr>1
		inner join duplicates org on org.[Name] = dup.[name] and dup.IndigoClientId = a.IndigoClientId and org.nr=1
		where a.IndigoClientId = @IndigoClientId

		-- Now, remove duplicates
		;with duplicates as (
			select *, row_number() over ( partition BY IndigoClientId, [Name] order by IndigoClientId, [Name], ActivityCategoryParentId ) AS nr
			from crm.dbo.TActivityCategoryParent with (nolock)
			where IndigoClientId = @IndigoClientId
			)
		delete duplicates
		where nr>1
		and IndigoClientId = @IndigoClientId

		-- crm.dbo.TActivityCategory
		update a
		set a.ClientRelatedFG = b.ClientRelatedFG,
			a.PlanRelatedFG = b.PlanRelatedFG,
			a.FeeRelatedFG = b.FeeRelatedFG,
			a.RetainerRelatedFG = b.RetainerRelatedFG,
			a.OpportunityRelatedFG = b.OpportunityRelatedFG,
			a.AdviserRelatedFg = b.AdviserRelatedFg,
			a.RefSystemEventId = b.RefSystemEventId,
			a.IsArchived = b.IsArchived,
			a.IsPropagated = b.IsPropagated,
			a.TaskBillingRate = b.TaskBillingRate,
			a.EstimatedTimeHrs = b.EstimatedTimeHrs,
			a.EstimatedTimeMins = b.EstimatedTimeMins,
			a.[Description] = b.[Description],
			a.ConcurrencyId +=1
		output
			inserted.ActivityCategoryId, inserted.[Name], inserted.ActivityCategoryParentId, inserted.LifeCycleTransitionId, inserted.IndigoClientId, inserted.ClientRelatedFG,
			inserted.PlanRelatedFG, inserted.FeeRelatedFG, inserted.RetainerRelatedFG, inserted.OpportunityRelatedFG, inserted.AdviserRelatedFg, inserted.ActivityEvent,
			inserted.RefSystemEventId, inserted.TemplateTypeId, inserted.TemplateId, inserted.ConcurrencyId, inserted.IsArchived, inserted.GroupId, inserted.IsPropagated,
			inserted.TaskBillingRate, inserted.EstimatedTimeHrs, inserted.EstimatedTimeMins, inserted.DocumentDesignerTemplateId, inserted.[Description]
			,'U', @Now, @StampUser
		into crm.dbo.TActivityCategoryAudit(
			ActivityCategoryId, [Name], ActivityCategoryParentId, LifeCycleTransitionId, IndigoClientId, ClientRelatedFG,
			PlanRelatedFG, FeeRelatedFG, RetainerRelatedFG, OpportunityRelatedFG, AdviserRelatedFg, ActivityEvent,
			RefSystemEventId, TemplateTypeId, TemplateId, ConcurrencyId, IsArchived, GroupId, IsPropagated,
			TaskBillingRate, EstimatedTimeHrs, EstimatedTimeMins,
			DocumentDesignerTemplateId, [Description]
			, StampAction, StampDateTime, StampUser)

		from crm.dbo.TActivityCategory a
		inner join crm.dbo.TActivityCategory b on b.[Name] = a.[Name] and b.ActivityEvent = a.ActivityEvent and b.IndigoClientId = @SourceIndigoClientId
		where a.IndigoClientId = @IndigoClientId
			and a.GroupId is null
			and b.GroupId is null
			and (a.ClientRelatedFG = b.ClientRelatedFG
				or a.PlanRelatedFG != b.PlanRelatedFG
				or a.FeeRelatedFG != b.FeeRelatedFG
				or a.RetainerRelatedFG != b.RetainerRelatedFG
				or a.OpportunityRelatedFG != b.OpportunityRelatedFG
				or a.AdviserRelatedFg != b.AdviserRelatedFg
				or isnull(a.RefSystemEventId,0) != isnull(b.RefSystemEventId,0)
				or a.IsArchived != b.IsArchived
				or a.IsPropagated != b.IsPropagated
				or isnull(a.TaskBillingRate,0.0) != isnull(b.TaskBillingRate,0.0)
				or isnull(a.EstimatedTimeHrs,0) != isnull(b.EstimatedTimeHrs,0)
				or isnull(a.EstimatedTimeMins,0) != isnull(b.EstimatedTimeMins,0)
				or isnull(a.[Description],'') != isnull(b.[Description],''))

		insert into crm.dbo.TActivityCategory(
			[Name], ActivityCategoryParentId, LifeCycleTransitionId, IndigoClientId, ClientRelatedFG, PlanRelatedFG, FeeRelatedFG,
			RetainerRelatedFG, OpportunityRelatedFG, AdviserRelatedFg, ActivityEvent,
			RefSystemEventId,
			TemplateTypeId,
			TemplateId,
			ConcurrencyId, IsArchived, GroupId, IsPropagated, TaskBillingRate, EstimatedTimeHrs, EstimatedTimeMins,
			DocumentDesignerTemplateId, [Description])
		output
			inserted.ActivityCategoryId, inserted.[Name], inserted.ActivityCategoryParentId, inserted.LifeCycleTransitionId, inserted.IndigoClientId, inserted.ClientRelatedFG,
			inserted.PlanRelatedFG, inserted.FeeRelatedFG, inserted.RetainerRelatedFG, inserted.OpportunityRelatedFG, inserted.AdviserRelatedFg, inserted.ActivityEvent,
			inserted.RefSystemEventId, inserted.TemplateTypeId, inserted.TemplateId, inserted.ConcurrencyId, inserted.IsArchived, inserted.GroupId,
			inserted.IsPropagated, inserted.TaskBillingRate, inserted.EstimatedTimeHrs, inserted.EstimatedTimeMins, inserted.DocumentDesignerTemplateId, inserted.[Description]
			,'C', @Now, @StampUser
		into crm.dbo.TActivityCategoryAudit(
			ActivityCategoryId, [Name], ActivityCategoryParentId, LifeCycleTransitionId, IndigoClientId, ClientRelatedFG,
			PlanRelatedFG, FeeRelatedFG, RetainerRelatedFG, OpportunityRelatedFG, AdviserRelatedFg, ActivityEvent,
			RefSystemEventId, TemplateTypeId, TemplateId, ConcurrencyId, IsArchived, GroupId,
			IsPropagated, TaskBillingRate, EstimatedTimeHrs, EstimatedTimeMins,
			DocumentDesignerTemplateId, [Description]
			, StampAction, StampDateTime, StampUser)

		select a.[Name], t.ActivityCategoryParentId, LifeCycleTransitionId, @IndigoClientId, ClientRelatedFG, PlanRelatedFG, FeeRelatedFG,
		RetainerRelatedFG, OpportunityRelatedFG, AdviserRelatedFg, ActivityEvent,
			RefSystemEventId,
			TemplateTypeId,
			TemplateId,
			1, a.IsArchived, GroupId, IsPropagated, TaskBillingRate, EstimatedTimeHrs, EstimatedTimeMins,
			DocumentDesignerTemplateId, [Description]
		from crm.dbo.TActivityCategory a
			inner join crm.dbo.TActivityCategoryParent b on b.ActivityCategoryParentId = a.ActivityCategoryParentId and b.IndigoClientId = @SourceIndigoClientId
			cross apply (select top 1 * from crm.dbo.TActivityCategoryParent c where c.[Name] = c.[Name] and c.IndigoClientId = @IndigoClientId order by ActivityCategoryParentId) t
		where a.IndigoClientId = @SourceIndigoClientId
			and GroupId is null
		except
		select a.[Name], t.ActivityCategoryParentId, LifeCycleTransitionId, a.IndigoClientId, ClientRelatedFG, PlanRelatedFG, FeeRelatedFG,
		RetainerRelatedFG, OpportunityRelatedFG, AdviserRelatedFg, ActivityEvent,
			RefSystemEventId,
			TemplateTypeId,
			TemplateId,
			1, a.IsArchived, GroupId, IsPropagated, TaskBillingRate, EstimatedTimeHrs, EstimatedTimeMins,
			DocumentDesignerTemplateId, [Description]
		from crm.dbo.TActivityCategory a
			inner join crm.dbo.TActivityCategoryParent b on b.ActivityCategoryParentId = a.ActivityCategoryParentId and b.IndigoClientId = @IndigoClientId
			cross apply (select top 1 * from crm.dbo.TActivityCategoryParent c where c.[Name] = c.[Name] and c.IndigoClientId = @IndigoClientId order by ActivityCategoryParentId) t
		where a.IndigoClientId = @IndigoClientId

		-- remove any duplicates
		;with duplicates as (
			select *, row_number() over ( partition BY IndigoClientId, [Name],ActivityCategoryParentId, ActivityEvent order by IndigoClientId, [Name],ActivityCategoryParentId, ActivityEvent) AS nr
			from crm.dbo.TActivityCategory with (nolock)
			where IndigoClientId = @IndigoClientId
			)
		delete duplicates
		where nr>1


		-- crm.dbo.TActivityOutcome
		update a
		set a.ArchiveFG = b.ArchiveFG,
			a.GroupId = gt.GroupId,
			a.ConcurrencyId +=1
		output
			inserted.ActivityOutcomeId, inserted.ActivityOutcomeName, inserted.IndigoClientId, inserted.ArchiveFG, inserted.ConcurrencyId, inserted.GroupId
			,'U', @Now, @StampUser
		into crm.dbo.TActivityOutcomeAudit(ActivityOutcomeId, ActivityOutcomeName, IndigoClientId, ArchiveFG, ConcurrencyId, GroupId
			, StampAction, StampDateTime, StampUser)
		from crm.dbo.TActivityOutcome a
			inner join crm.dbo.TActivityOutcome b on b.ActivityOutcomeName = a.ActivityOutcomeName and b.IndigoClientId = @SourceIndigoClientId
			left join Administration.dbo.TGroup gs on gs.GroupId = b.GroupId and gs.IndigoClientId = @SourceIndigoClientId
			left join Administration.dbo.TGroup gt on gt.Identifier = gs.Identifier and gt.IndigoClientId = @IndigoClientId
		where a.IndigoClientId = @IndigoClientId
			and (a.GroupId != gt.GroupId
				or a.ArchiveFG != b.ArchiveFG)


		insert into crm.dbo.TActivityOutcome(ActivityOutcomeName, IndigoClientId, ArchiveFG, ConcurrencyId, GroupId)
		output
			inserted.ActivityOutcomeId, inserted.ActivityOutcomeName, inserted.IndigoClientId, inserted.ArchiveFG, inserted.ConcurrencyId, inserted.GroupId
			,'C', @Now, @StampUser
		into crm.dbo.TActivityOutcomeAudit(ActivityOutcomeId, ActivityOutcomeName, IndigoClientId, ArchiveFG, ConcurrencyId, GroupId
			, StampAction, StampDateTime, StampUser)
		select ActivityOutcomeName, @IndigoClientId, ArchiveFG, 1, gt.GroupId
		from crm.dbo.TActivityOutcome aos
			left join Administration.dbo.TGroup gs on gs.GroupId = aos.GroupId and gs.IndigoClientId = @SourceIndigoClientId
			left join Administration.dbo.TGroup gt on gt.Identifier = gs.Identifier and gt.IndigoClientId = @IndigoClientId
		where aos.IndigoClientId = @SourceIndigoClientId
		except
		select ActivityOutcomeName, IndigoClientId, ArchiveFG, 1, GroupId
		from crm.dbo.TActivityOutcome
		where IndigoClientId = @IndigoClientId

		insert into crm.dbo.TActivityCategory2ActivityOutcome(ActivityCategoryId, ActivityOutcomeId, ConcurrencyId)
		output
			inserted.ActivityCategory2ActivityOutcomeId, inserted.ActivityCategoryId, inserted.ActivityOutcomeId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into crm.dbo.TActivityCategory2ActivityOutcomeAudit(ActivityCategory2ActivityOutcomeId, ActivityCategoryId, ActivityOutcomeId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select act.ActivityCategoryId, aot.ActivityOutcomeId, 1
		--, acs.ActivityCategoryId, aos.ActivityOutcomeId
		--, aot.ActivityOutcomeName, act.Description, act.ActivityEvent
		--, aos.ActivityOutcomeName, acs.Description, acs.ActivityEvent
		from crm.dbo.TActivityCategory2ActivityOutcome a
		inner join crm.dbo.TActivityOutcome aos on aos.ActivityOutcomeId = a.ActivityOutcomeId and aos.IndigoClientId = @SourceIndigoClientId
		inner join crm.dbo.TActivityCategory acs on acs.ActivityCategoryId = a.ActivityCategoryId and acs.IndigoClientId = @SourceIndigoClientId
		cross apply (select top 1 * from crm.dbo.TActivityOutcome ao where ao.ActivityOutcomeName = aos.ActivityOutcomeName and ao.ArchiveFG = aos.ArchiveFG and ao.GroupId is null and ao.IndigoClientId = @IndigoClientId order by ao.ActivityOutcomeId) aot
		cross apply (select top 1 * from crm.dbo.TActivityCategory ac where ac.[Name] = acs.[Name] and ac.IndigoClientId = @IndigoClientId
			and ac.ClientRelatedFG = acs.ClientRelatedFG
			and ac.PlanRelatedFG = acs.PlanRelatedFG
			and ac.FeeRelatedFG = acs.FeeRelatedFG
			and ac.RetainerRelatedFG = acs.RetainerRelatedFG
			and ac.OpportunityRelatedFG = acs.OpportunityRelatedFG
			and ac.AdviserRelatedFg = acs.AdviserRelatedFg
			and ac.IsArchived = acs.IsArchived
			and ac.IsPropagated = acs.IsPropagated

			and isnull(ac.LifeCycleTransitionId,0) = isnull(acs.LifeCycleTransitionId,0)
			and isnull(ac.RefSystemEventId,0) = isnull(acs.RefSystemEventId,0)
			and isnull(ac.TaskBillingRate,0.0) = isnull(acs.TaskBillingRate,0.0)
			and isnull(ac.EstimatedTimeHrs,0) = isnull(acs.EstimatedTimeHrs,0)
			and isnull(ac.EstimatedTimeMins,0) = isnull(acs.EstimatedTimeMins,0)
			and isnull(ac.DocumentDesignerTemplateId,0) = isnull(acs.DocumentDesignerTemplateId,0)

			and isnull(ac.ActivityEvent,'') = isnull(acs.ActivityEvent,'')
			and isnull(ac.TemplateTypeId,'') = isnull(acs.TemplateTypeId,'')
			and isnull(ac.TemplateId,'') = isnull(acs.TemplateId,'')
			and isnull(ac.[Description],'') = isnull(acs.[Description],'')
			order by ActivityCategoryId) act
		where aos.GroupId is null
		except
			select ActivityCategoryId, ActivityOutcomeId, 1
			from crm.dbo.TActivityCategory2ActivityOutcome

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
