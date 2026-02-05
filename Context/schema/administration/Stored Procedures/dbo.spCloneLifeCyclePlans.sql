SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneLifeCyclePlans] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
-- Compliance > Administration > Life Cycle
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

		delete a -- Delete any existing, that match source Life Cycles
		output
			deleted.LifeCycleId,deleted.RefPlanTypeId,deleted.AdviceTypeId,deleted.ConcurrencyId,deleted.LifeCycle2RefPlanTypeId
			,'D', @Now, @StampUser
		into PolicyManagement.dbo.TLifeCycle2RefPlanTypeAudit(
			LifeCycleId,RefPlanTypeId,AdviceTypeId,ConcurrencyId,LifeCycle2RefPlanTypeId
			,StampAction,StampDateTime,StampUser)
		from PolicyManagement.dbo.TLifeCycle2RefPlanType a
			inner join PolicyManagement.dbo.TLifeCycle tlc on tlc.LifeCycleId = a.LifeCycleId
			inner join PolicyManagement.dbo.TLifeCycle srctlc on srctlc.[Name] = tlc.[Name] and srctlc.[Status] = tlc.[Status] and Isnull(srctlc.PreQueueBehaviour,'')=Isnull(tlc.PreQueueBehaviour,'') and Isnull(srctlc.PostQueueBehaviour,'')=Isnull(tlc.PostQueueBehaviour,'')
			inner join PolicyManagement.dbo.TAdviceType adt on adt.AdviceTypeId = a.AdviceTypeId
		where tlc.IndigoClientId = @IndigoClientId
			and adt.IndigoClientId = @IndigoClientId
			and adt.ArchiveFg = 0 -- VERY IMPORTANT! if ArchiveFg = 1, will return error if edited!
			and srctlc.IndigoClientId = @SourceIndigoClientId

		insert into PolicyManagement.dbo.TLifeCycle2RefPlanType(LifeCycleId,RefPlanTypeId,AdviceTypeId,ConcurrencyId)
		output
			inserted.LifeCycleId,inserted.RefPlanTypeId,inserted.AdviceTypeId,inserted.ConcurrencyId,inserted.LifeCycle2RefPlanTypeId
			,'C', @Now, @StampUser
		into PolicyManagement.dbo.TLifeCycle2RefPlanTypeAudit(
			LifeCycleId,RefPlanTypeId,AdviceTypeId,ConcurrencyId,LifeCycle2RefPlanTypeId
			,StampAction,StampDateTime,StampUser)

		select tgttlc.LifeCycleId, src.RefPlanTypeId, tgtadt.AdviceTypeId,1
		from
			PolicyManagement.dbo.TLifeCycle2RefPlanType src
			inner join PolicyManagement.dbo.TLifeCycle srctlc on srctlc.LifeCycleId = src.LifeCycleId
			inner join PolicyManagement.dbo.TAdviceType srcadt on srcadt.AdviceTypeId = src.AdviceTypeId
			inner join PolicyManagement.dbo.TLifeCycle tgttlc on tgttlc.[Name] = srctlc.[Name] and tgttlc.[Status] = srctlc.[Status] and Isnull(tgttlc.PreQueueBehaviour,'') = Isnull(srctlc.PreQueueBehaviour,'') and Isnull(tgttlc.PostQueueBehaviour,'') = Isnull(srctlc.PostQueueBehaviour,'')
			inner join PolicyManagement.dbo.TAdviceType tgtadt on tgtadt.[Description] = srcadt.[Description] and tgtadt.IntelligentOfficeAdviceType = srcadt.IntelligentOfficeAdviceType
		where srctlc.IndigoClientId=@SourceIndigoClientId
			and srcadt.IndigoClientId=@SourceIndigoClientId
			and srcadt.ArchiveFg = 0 -- VERY IMPORTANT! if ArchiveFg = 1, will return error if edited!
			and tgttlc.IndigoClientId=@IndigoClientId
			and tgtadt.IndigoClientId=@IndigoClientId
			and tgtadt.ArchiveFg = 0 -- VERY IMPORTANT! if ArchiveFg = 1, will return error if edited!

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
