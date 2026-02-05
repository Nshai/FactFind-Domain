SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneLifeCycleRules] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
	set nocount off
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
		declare @MigRef varchar(15)='',
			@NewId int

		if object_id('tempdb..#TLifeCycleTransitionRule_IO') is not null drop table #TLifeCycleTransitionRule_IO
		if object_id('tempdb..#TStatus_IO') is not null drop table #TStatus_IO
		if object_id('tempdb..#TLifeCycleStep_IO') is not null drop table #TLifeCycleStep_IO
		if object_id('tempdb..#TLifeCycleTransition_IO') is not null drop table #TLifeCycleTransition_IO
		if object_id('tempdb..#TLifeCycleTransitionToLifeCycleTransitionRule_IO') is not null drop table #TLifeCycleTransitionToLifeCycleTransitionRule_IO

		-- Clone TLifeCycleTransitionRule
		select *, 
			[MigRef]='REF_'+right('0000000000'+CONVERT(varchar(255), LifeCycleTransitionRuleId),10), [New_TenantId] = case when TenantId = @SourceIndigoClientId then @IndigoClientId else null end , [New_LifeCycleTransitionRuleId]=CONVERT(int, null)
		into #TLifeCycleTransitionRule_IO
		from PolicyManagement.dbo.TLifeCycleTransitionRule
		where isnull(TenantId,@SourceIndigoClientId) = @SourceIndigoClientId
		
		-- Get any existing LifeCycleTransitionRuleId
		update a
		set New_LifeCycleTransitionRuleId = b.LifeCycleTransitionRuleId
		from #TLifeCycleTransitionRule_IO a
		inner join PolicyManagement.dbo.TLifeCycleTransitionRule b on a.[Name]=b.[Name] and a.Code=b.Code and a.[Description]=b.[Description] and a.SpName=b.SpName
		where b.TenantId is not null and b.TenantId = @IndigoClientId

		update a
		set New_LifeCycleTransitionRuleId = b.LifeCycleTransitionRuleId
		from #TLifeCycleTransitionRule_IO a
		inner join PolicyManagement.dbo.TLifeCycleTransitionRule b on a.[Name]=b.[Name] and a.Code=b.Code and a.[Description]=b.[Description] and a.SpName=b.SpName
		where a.TenantId is null and b.TenantId is null

		while(1=1) begin
			select top 1 @MigRef = MigRef
			from #TLifeCycleTransitionRule_IO
			where MigRef>@MigRef
				and New_LifeCycleTransitionRuleId is null
			order by MigRef

			if @@ROWCOUNT=0 break

			insert into PolicyManagement.dbo.TLifeCycleTransitionRule(
				TenantId
				,[Name]
				,Code
				,[Description]
				,SpName
				,ConcurrencyId
				,RefLifecycleRuleCategoryId
				)
			output
				inserted.LifeCycleTransitionRuleId
				,inserted.TenantId
				,inserted.[Name]
				,inserted.Code
				,inserted.[Description]
				,inserted.SpName
				,inserted.ConcurrencyId
				,inserted.RefLifecycleRuleCategoryId
				,'C', @Now, @StampUser
			into PolicyManagement.dbo.TLifeCycleTransitionRuleAudit(
				 LifeCycleTransitionRuleId
				,TenantId
				,[Name]
				,Code
				,[Description]
				,SpName
				,ConcurrencyId
				,RefLifecycleRuleCategoryId
				,StampAction,StampDateTime,StampUser)
			select
				New_TenantId
				,[Name]
				,Code
				,[Description]
				,SpName
				,1
				,RefLifecycleRuleCategoryId
			from #TLifeCycleTransitionRule_IO
			where MigRef=@MigRef

			set @NewId = IDENT_CURRENT('PolicyManagement.dbo.TLifeCycleTransitionRule')

			update #TLifeCycleTransitionRule_IO
			set New_LifeCycleTransitionRuleId = @NewId
			where MigRef=@MigRef
		end

		-- Clone TStatus
		select *, 
			[MigRef]='REF_'+right('0000000000'+CONVERT(varchar(255), StatusId),10), [New_IndigoClientId] = @IndigoClientId, [New_StatusId]=CONVERT(int, null)
		into #TStatus_IO
		from PolicyManagement.dbo.TStatus
		where IndigoClientId = @SourceIndigoClientId
		
		-- Get any existing StatusId: There are duplicates!
		update a
		set New_StatusId = b.StatusId
		from #TStatus_IO a
		cross apply (select top 1 * from PolicyManagement.dbo.TStatus b where b.[Name]=a.[Name] and isnull(b.OrigoStatusId,0) =isnull(a.OrigoStatusId,0) 
			and b.IntelligentOfficeStatusType=a.IntelligentOfficeStatusType and b.IndigoClientId = @IndigoClientId) b

		set @MigRef=''

		while(1=1) begin
			select top 1 @MigRef = MigRef
			from #TStatus_IO
			where MigRef>@MigRef
				and New_StatusId is null
			order by MigRef

			if @@ROWCOUNT=0 break

			-- Copy LifeCycleStatus
			insert into PolicyManagement.dbo.TStatus(
				[Name]
				,OrigoStatusId
				,IntelligentOfficeStatusType
				,PreComplianceCheck
				,PostComplianceCheck
				,SystemSubmitFg
				,IndigoClientId
				,ConcurrencyId
				,IsPipelineStatus
				)
			output
				inserted.StatusId
				,inserted.[Name]
				,inserted.OrigoStatusId
				,inserted.IntelligentOfficeStatusType
				,inserted.PreComplianceCheck
				,inserted.PostComplianceCheck
				,inserted.SystemSubmitFg
				,inserted.IndigoClientId
				,inserted.ConcurrencyId
				,inserted.IsPipelineStatus
				,'C', @Now, @StampUser
			into PolicyManagement.dbo.TStatusAudit(
				StatusId
				,[Name]
				,OrigoStatusId
				,IntelligentOfficeStatusType
				,PreComplianceCheck
				,PostComplianceCheck
				,SystemSubmitFg
				,IndigoClientId
				,ConcurrencyId
				,IsPipelineStatus
				,StampAction,StampDateTime,StampUser)
			SELECT 
				[Name]
				,OrigoStatusId
				,IntelligentOfficeStatusType
				,PreComplianceCheck
				,PostComplianceCheck
				,SystemSubmitFg
				,@IndigoClientId
				,1
				,IsPipelineStatus
			FROM #TStatus_IO
			where MigRef = @MigRef

			set @NewId = IDENT_CURRENT('PolicyManagement.dbo.TStatus')

			update #TStatus_IO
			set New_StatusId = @NewId
			where MigRef=@MigRef

		end

		-- Clone TLifeCycleStep
		
		select lcs.*,
			[LC_Name]=lc.[Name], lc.Descriptor, lc.Status, lc.PreQueueBehaviour, lc.PostQueueBehaviour, lc.IgnorePostCheckIfPreHasBeenCompleted
			, [S_Name]=s.[Name], s.OrigoStatusId, s.IntelligentOfficeStatusType, s.PreComplianceCheck, s.PostComplianceCheck, s.SystemSubmitFg, s.IsPipelineStatus
			, [MigRef]='REF_'+right('0000000000'+CONVERT(varchar(255), LifeCycleStepId),10), [New_IndigoClientId] = @IndigoClientId, [New_LifeCycleStepId]=CONVERT(int, null)
			, [New_LifeCycleId]=CONVERT(int, null)
			, [New_StatusId]=CONVERT(int, null)
		into #TLifeCycleStep_IO
		from PolicyManagement.dbo.TLifeCycleStep lcs
		inner join PolicyManagement.dbo.TLifeCycle lc on lc.LifeCycleId = lcs.LifeCycleId 
		inner join PolicyManagement.dbo.TStatus s on s.StatusId = lcs.StatusId
		where lc.IndigoClientId = @SourceIndigoClientId
		
		
		update a
		set New_StatusId = b.New_StatusId
		from #TLifeCycleStep_IO a
		inner join #TStatus_IO b on b.StatusId = a.StatusId
		
		update a
		set New_LifeCycleId = lc.LifeCycleId
		from #TLifeCycleStep_IO a
		inner join PolicyManagement.dbo.TLifeCycle lc on lc.[Name] = a.LC_Name and lc.Descriptor = a.Descriptor and lc.PreQueueBehaviour = a.PreQueueBehaviour and lc.PostQueueBehaviour = a.PostQueueBehaviour and lc.IgnorePostCheckIfPreHasBeenCompleted = a.IgnorePostCheckIfPreHasBeenCompleted
		inner join PolicyManagement.dbo.TLifeCycleStep lcs on lcs.LifeCycleId  = lc.LifeCycleId

		update a
		set New_LifeCycleStepId = lcs.LifeCycleStepId,
			New_LifeCycleId = lcs.LifeCycleId,
			New_StatusId = lcs.StatusId
		from #TLifeCycleStep_IO a
		inner join PolicyManagement.dbo.TLifeCycle lc on lc.[Name] = a.LC_Name and lc.Descriptor = a.Descriptor and lc.PreQueueBehaviour = a.PreQueueBehaviour and lc.PostQueueBehaviour = a.PostQueueBehaviour and lc.IgnorePostCheckIfPreHasBeenCompleted = a.IgnorePostCheckIfPreHasBeenCompleted
		inner join PolicyManagement.dbo.TLifeCycleStep lcs on lcs.LifeCycleId  = lc.LifeCycleId
		inner join PolicyManagement.dbo.TStatus s on s.StatusId = lcs.StatusId and s.[Name]=a.S_Name and ISNULL(s.OrigoStatusId,0) = ISNULL(a.OrigoStatusId,0) and s.IntelligentOfficeStatusType = a.IntelligentOfficeStatusType
			and s.PreComplianceCheck = a.PreComplianceCheck and s.PostComplianceCheck = a.PostComplianceCheck and s.SystemSubmitFg = a.SystemSubmitFg and s.IsPipelineStatus = a.IsPipelineStatus
		where lc.IndigoClientId = @IndigoClientId and s.IndigoClientId = @IndigoClientId

		set @MigRef=''

		while(1=1) begin

			select top 1 @MigRef = MigRef
			from #TLifeCycleStep_IO
			where MigRef>@MigRef
				and New_LifeCycleStepId is null
			order by MigRef

			if @@ROWCOUNT=0 break

			insert into PolicyManagement.dbo.TLifeCycleStep(
				StatusId
				,LifeCycleId
				,ConcurrencyId
				,IsSystem)
			output
				 inserted.LifeCycleStepId
				,inserted.StatusId
				,inserted.LifeCycleId
				,inserted.ConcurrencyId
				,inserted.IsSystem
				,'C', @Now, @StampUser
			into PolicyManagement.dbo.TLifeCycleStepAudit(
				LifeCycleStepId
				,StatusId
				,LifeCycleId
				,ConcurrencyId
				,IsSystem
				,StampAction,StampDateTime,StampUser)
			select 
				New_StatusId
				,New_LifeCycleId
				,1
				,IsSystem
			from #TLifeCycleStep_IO
			where MigRef=@MigRef

			set @NewId = IDENT_CURRENT('PolicyManagement.dbo.TLifeCycleStep')

			update #TLifeCycleStep_IO
			set New_LifeCycleStepId = @NewId
			where MigRef=@MigRef
		end
		
		-- Clone TLifeCycleTransition
		select lct.*
			, [MigRef]='REF_'+right('0000000000'+CONVERT(varchar(255), lct.LifeCycleTransitionId),10), [New_IndigoClientId] = @IndigoClientId, [New_LifeCycleTransitionId]=CONVERT(int, null)
			,	[New_LifeCycleStepId]=CONVERT(int, null)
			, [New_ToLifeCycleStepId]=CONVERT(int, null)
		into #TLifeCycleTransition_IO
		from PolicyManagement.dbo.TLifeCycleTransition lct
		inner join PolicyManagement.dbo.TLifeCycleStep lcs on lcs.LifeCycleStepId  = lct.LifeCycleStepId
		inner join PolicyManagement.dbo.TLifeCycle lc on lc.LifeCycleId = lcs.LifeCycleId
		where lc.IndigoClientId = @SourceIndigoClientId

		update a
		set New_LifeCycleStepId = lcs.New_LifeCycleStepId
		from #TLifeCycleTransition_IO a
		inner join #TLifeCycleStep_IO lcs on lcs.LifeCycleStepId = a.LifeCycleStepId
		
		update a
		set New_ToLifeCycleStepId = lcs.New_LifeCycleStepId
		from #TLifeCycleTransition_IO a
		inner join #TLifeCycleStep_IO lcs on lcs.LifeCycleStepId = a.ToLifeCycleStepId
		
		update a
		set New_LifeCycleTransitionId = lct.LifeCycleTransitionId
		from #TLifeCycleTransition_IO a
		inner join PolicyManagement.dbo.TLifeCycleTransition lct on lct.LifeCycleStepId = a.New_LifeCycleStepId and lct.ToLifeCycleStepId = a.New_ToLifeCycleStepId and lct.OrderNumber = a.OrderNumber and lct.HideStep = a.HideStep and ISNULL(lct.[Type],'') = ISNULL(a.[Type],'')
		inner join PolicyManagement.dbo.TLifeCycleStep lcs on lcs.LifeCycleStepId = lct.LifeCycleStepId
		inner join PolicyManagement.dbo.TLifeCycle lc on lc.LifeCycleId = lcs.LifeCycleId and lc.IndigoClientId = @IndigoClientId

		Set @MigRef=''

		while(1=1) begin
			select top 1 @MigRef = MigRef
			from #TLifeCycleTransition_IO
			where MigRef>@MigRef
				and New_LifeCycleTransitionId is null
			order by MigRef

			if @@ROWCOUNT=0 break

			insert into PolicyManagement.dbo.TLifeCycleTransition(
				LifeCycleStepId
				,ToLifeCycleStepId
				,OrderNumber
				,[Type]
				,HideStep
				,AddToCommissionsFg
				,ConcurrencyId)
			output
				 inserted.LifeCycleTransitionId
				,inserted.LifeCycleStepId
				,inserted.ToLifeCycleStepId
				,inserted.OrderNumber
				,inserted.[Type]
				,inserted.HideStep
				,inserted.AddToCommissionsFg
				,inserted.ConcurrencyId
				,'C', @Now, @StampUser
			into PolicyManagement.dbo.TLifeCycleTransitionAudit(
				LifeCycleTransitionId
				,LifeCycleStepId
				,ToLifeCycleStepId
				,OrderNumber
				,[Type]
				,HideStep
				,AddToCommissionsFg
				,ConcurrencyId
				,StampAction,StampDateTime,StampUser)
			select
				New_LifeCycleStepId
				,New_ToLifeCycleStepId
				,OrderNumber
				,[Type]
				,HideStep
				,AddToCommissionsFg
				,1
			from #TLifeCycleTransition_IO
			where MigRef = @MigRef

			set @NewId = IDENT_CURRENT('PolicyManagement.dbo.TLifeCycleTransition')

			update #TLifeCycleTransition_IO
			set New_LifeCycleTransitionId = @NewId
			where MigRef = @MigRef

		end

		-- Clone TLifeCycleTransitionToLifeCycleTransitionRule

		select a.*
			, [MigRef]='REF_'+right('0000000000'+CONVERT(varchar(255), a.LifeCycleTransitionToLifeCycleTransitionRuleId),10), [New_IndigoClientId] = @IndigoClientId, [New_LifeCycleTransitionToLifeCycleTransitionRuleId]=CONVERT(int, null)
			, [New_LifeCycleTransitionId]=CONVERT(int, null)
			, [New_LifeCycleTransitionRuleId]=CONVERT(int, null)
		into #TLifeCycleTransitionToLifeCycleTransitionRule_IO
		from PolicyManagement.dbo.TLifeCycleTransitionToLifeCycleTransitionRule a
		inner join PolicyManagement.dbo.TLifeCycleTransition lct on lct.LifeCycleTransitionId = a.LifeCycleTransitionId
		inner join PolicyManagement.dbo.TLifeCycleStep lcs on lcs.LifeCycleStepId = lct.LifeCycleStepId
		inner join PolicyManagement.dbo.TLifeCycle lc on lc.LifeCycleId = lcs.LifeCycleId and lc.IndigoClientId = @SourceIndigoClientId

		update a
		set New_LifeCycleTransitionId = b.New_LifeCycleTransitionId
			,New_LifeCycleTransitionRuleId = c.New_LifeCycleTransitionRuleId
		from #TLifeCycleTransitionToLifeCycleTransitionRule_IO a
		inner join #TLifeCycleTransition_IO b on b.LifeCycleTransitionId = a.LifeCycleTransitionId
		inner join #TLifeCycleTransitionRule_IO c on c.LifeCycleTransitionRuleId = a.LifeCycleTransitionRuleId

		update a
		set New_LifeCycleTransitionToLifeCycleTransitionRuleId = b.LifeCycleTransitionToLifeCycleTransitionRuleId
		from #TLifeCycleTransitionToLifeCycleTransitionRule_IO a
		inner join PolicyManagement.dbo.TLifeCycleTransitionToLifeCycleTransitionRule b on b.LifeCycleTransitionId = a.New_LifeCycleTransitionId and b.LifeCycleTransitionRuleId = a.New_LifeCycleTransitionRuleId
		inner join PolicyManagement.dbo.TLifeCycleTransition lct on lct.LifeCycleTransitionId = b.LifeCycleTransitionId
		inner join PolicyManagement.dbo.TLifeCycleStep lcs on lcs.LifeCycleStepId = lct.LifeCycleStepId
		inner join PolicyManagement.dbo.TLifeCycle lc on lc.LifeCycleId = lcs.LifeCycleId and lc.IndigoClientId = @IndigoClientId

		set @MigRef=''

		while(1=1) begin

			select top 1 @MigRef = MigRef
			from #TLifeCycleTransitionToLifeCycleTransitionRule_IO
			where MigRef>@MigRef
				and New_LifeCycleTransitionToLifeCycleTransitionRuleId is null
			order by MigRef

			if @@ROWCOUNT=0 break

			insert into PolicyManagement.dbo.TLifeCycleTransitionToLifeCycleTransitionRule(
				LifeCycleTransitionId,LifeCycleTransitionRuleId,ConcurrencyId)
			output
				inserted.LifeCycleTransitionToLifeCycleTransitionRuleId
				,inserted.LifeCycleTransitionId
				,inserted.LifeCycleTransitionRuleId
				,inserted.ConcurrencyId
				,'C', @Now, @StampUser
			into PolicyManagement.dbo.TLifeCycleTransitionToLifeCycleTransitionRuleAudit(
				LifeCycleTransitionToLifeCycleTransitionRuleId
				,LifeCycleTransitionId
				,LifeCycleTransitionRuleId
				,ConcurrencyId
				,StampAction,StampDateTime,StampUser)
			select 
				New_LifeCycleTransitionId
				,New_LifeCycleTransitionRuleId
				,1
			from #TLifeCycleTransitionToLifeCycleTransitionRule_IO
			where MigRef = @MigRef


			set @NewId = IDENT_CURRENT('PolicyManagement.dbo.TLifeCycleTransitionToLifeCycleTransitionRule')

			update #TLifeCycleTransitionToLifeCycleTransitionRule_IO
			set New_LifeCycleTransitionToLifeCycleTransitionRuleId = @NewId
			where MigRef = @MigRef

		end

		if @tx = 0 begin
			commit transaction TX
			set @msg=@ProcName+': commit transaction TX'
			raiserror(@msg,0,1) with nowait
		end

		exec dbo.spStopCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName

		if object_id('tempdb..#TLifeCycleTransitionRule_IO') is not null drop table #TLifeCycleTransitionRule_IO
		if object_id('tempdb..#TStatus_IO') is not null drop table #TStatus_IO
		if object_id('tempdb..#TLifeCycleStep_IO') is not null drop table #TLifeCycleStep_IO
		if object_id('tempdb..#TLifeCycleTransition_IO') is not null drop table #TLifeCycleTransition_IO
		if object_id('tempdb..#TLifeCycleTransitionToLifeCycleTransitionRule_IO') is not null drop table #TLifeCycleTransitionToLifeCycleTransitionRule_IO

	end try
	begin catch
		declare @Errmsg varchar(max) = @ProcName+'
'+ERROR_MESSAGE()

		if @tx = 0 begin
			set @msg=@ProcName+': rollback transaction TX'
			raiserror(@msg,0,1) with nowait
			rollback transaction TX
		end

		if object_id('tempdb..#TLifeCycleTransitionRule_IO') is not null drop table #TLifeCycleTransitionRule_IO
		if object_id('tempdb..#TStatus_IO') is not null drop table #TStatus_IO
		if object_id('tempdb..#TLifeCycleStep_IO') is not null drop table #TLifeCycleStep_IO
		if object_id('tempdb..#TLifeCycleTransition_IO') is not null drop table #TLifeCycleTransition_IO
		if object_id('tempdb..#TLifeCycleTransitionToLifeCycleTransitionRule_IO') is not null drop table #TLifeCycleTransitionToLifeCycleTransitionRule_IO
		raiserror(@Errmsg,16,1)
	end catch
end
GO
