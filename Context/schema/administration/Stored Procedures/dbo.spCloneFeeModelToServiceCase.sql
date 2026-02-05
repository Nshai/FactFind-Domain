SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneFeeModelToServiceCase] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
	-- Administration > Organisation > Reference Data > Service Status > Assign Fee Nodel
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
		declare @MigRef varchar(15)='',
			@NewId int

		if object_id('tempdb..#TRefServiceStatusToFeeModel_IO') is not null drop table #TRefServiceStatusToFeeModel_IO
		
		-- Clone TRefServiceStatusToFeeModel
		select a.*
			, ss.ServiceStatusName, fm.[Name]
			,[MigRef]='REF_'+right('0000000000'+CONVERT(varchar(255), a.RefServiceStatusToFeeModelId),10), [New_TenantId] = @IndigoClientId, [New_RefServiceStatusToFeeModelId]=CONVERT(int, null)
			, New_RefServiceStatusId=CONVERT(int, null)
			, New_FeeModelId=CONVERT(int, null)
		into #TRefServiceStatusToFeeModel_IO
		from CRM.dbo.TRefServiceStatusToFeeModel a
		inner join CRM.dbo.TRefServiceStatus ss on ss.RefServiceStatusId = a.RefServiceStatusId and ss.IndigoClientId = @SourceIndigoClientId 
		inner join PolicyManagement.dbo.TFeeModel fm on fm.FeeModelId = a.FeeModelId and fm.TenantId = @SourceIndigoClientId
		where a.TenantId = @SourceIndigoClientId
		
		-- Get any existing FKs
		update a
		set New_RefServiceStatusId = b.RefServiceStatusId
		from #TRefServiceStatusToFeeModel_IO a
		inner join CRM.dbo.TRefServiceStatus b on b.ServiceStatusName=a.ServiceStatusName and b.IndigoClientId = @IndigoClientId
		
		update a
		set New_FeeModelId = b.FeeModelId
		from #TRefServiceStatusToFeeModel_IO a
		inner join PolicyManagement.dbo.TFeeModel b on b.[Name]=a.[Name] and b.TenantId = @IndigoClientId

		-- Get any existing TRefServiceStatusToFeeModel
		update a
		set a.New_RefServiceStatusToFeeModelId = b.RefServiceStatusToFeeModelId
		from #TRefServiceStatusToFeeModel_IO a
		inner join CRM.dbo.TRefServiceStatusToFeeModel b on b.RefServiceStatusId = a.New_RefServiceStatusId and b.FeeModelId=a.New_FeeModelId
		where b.TenantId = @IndigoClientId

		while(1=1) begin
			select top 1 @MigRef = MigRef
			from #TRefServiceStatusToFeeModel_IO
			where MigRef>@MigRef
				and New_RefServiceStatusToFeeModelId is null
			order by MigRef

			if @@ROWCOUNT=0 break

			insert into crm.dbo.TRefServiceStatusToFeeModel(
				RefServiceStatusId
				,FeeModelId
				,IsDefault
				,TenantId
				,ConcurrencyId
				)
			output
				inserted.RefServiceStatusToFeeModelId
				,inserted.RefServiceStatusId
				,inserted.FeeModelId
				,inserted.IsDefault
				,inserted.TenantId
				,inserted.ConcurrencyId
				,'C', @Now, @StampUser
			into crm.dbo.TRefServiceStatusToFeeModelAudit(
				RefServiceStatusToFeeModelId
				,RefServiceStatusId
				,FeeModelId
				,IsDefault
				,TenantId
				,ConcurrencyId
				,StampAction,StampDateTime,StampUser)
			select
				New_RefServiceStatusId
				,New_FeeModelId
				,IsDefault
				,New_TenantId
				,1
			from #TRefServiceStatusToFeeModel_IO
			where MigRef=@MigRef

			set @NewId = IDENT_CURRENT('crm.dbo.TRefServiceStatusToFeeModel')

			update #TRefServiceStatusToFeeModel_IO
			set New_RefServiceStatusToFeeModelId = @NewId
			where MigRef=@MigRef
		end

		
		if @tx = 0 begin
			commit transaction TX
			set @msg=@ProcName+': commit transaction TX'
			raiserror(@msg,0,1) with nowait
		end

		exec dbo.spStopCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName

		if object_id('tempdb..#TRefServiceStatusToFeeModel_IO') is not null drop table #TRefServiceStatusToFeeModel_IO
		
	end try
	begin catch
		declare @Errmsg varchar(max) = @ProcName+'
'+ERROR_MESSAGE()

		if @tx = 0 begin
			set @msg=@ProcName+': rollback transaction TX'
			raiserror(@msg,0,1) with nowait
			rollback transaction TX
		end
		if object_id('tempdb..#TRefServiceStatusToFeeModel_IO') is not null drop table #TRefServiceStatusToFeeModel_IO
		raiserror(@Errmsg,16,1)
	end catch
end
GO
