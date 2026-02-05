create proc dbo.spCloneRefExpenditureGroup @IndigoClientId int, @SourceIndigoClientId int, @RegionCode nvarchar(max) null, @StampUser varchar(255) = '-1010'
as
begin
	set nocount on
	declare @ProcName sysname = OBJECT_NAME(@@PROCID),
		@procResult int,
		@serializedParameters nvarchar(max) = ''

	select @serializedParameters = (select @IndigoClientId as IndigoClientId,
		@SourceIndigoClientId as SourceIndigoClientId,
		@RegionCode as RegionCode
	FOR JSON PATH)

	exec @procResult = dbo.spStartCreateTenantModule @IndigoClientId, @SourceIndigoClientId, @ProcName, @serializedParameters
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
	if exists (select top 1 1 from factFind.dbo.TRefExpenditureGroup where TenantId = @SourceIndigoClientId)
		insert into factFind.dbo.TRefExpenditureGroup(
			[Name]
			,Ordinal
			,IsConsolidateEnabled
			,TenantId
			,RegionCode
			,Attributes
			,ConcurrencyId)
		output
			inserted.[Name]
			,inserted.Ordinal
			,inserted.IsConsolidateEnabled
			,inserted.TenantId
			,inserted.RegionCode
			,inserted.Attributes
			,inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into factFind.dbo.TRefExpenditureGroupAudit(
			[Name]
			,Ordinal
			,IsConsolidateEnabled
			,TenantId
			,RegionCode
			,Attributes
			,ConcurrencyId
			,StampAction,StampDateTime,StampUser)
		select [Name]
			,Ordinal
			,IsConsolidateEnabled
			,@IndigoClientId
			,@RegionCode
			,Attributes
			,1
		from factFind.dbo.TRefExpenditureGroup
		where isnull(RegionCode,@RegionCode) = @RegionCode
			and TenantId = @SourceIndigoClientId
		except
		select [Name]
			,Ordinal
			,IsConsolidateEnabled
			,TenantId
			,@RegionCode
			,Attributes
			,1
		from factFind.dbo.TRefExpenditureGroup
		where TenantId = @IndigoClientId
	
	else

		insert into factFind.dbo.TRefExpenditureGroup(
			[Name]
			,Ordinal
			,IsConsolidateEnabled
			,TenantId
			,RegionCode
			,Attributes
			,ConcurrencyId)
		output
			inserted.[Name]
			,inserted.Ordinal
			,inserted.IsConsolidateEnabled
			,inserted.TenantId
			,inserted.RegionCode
			,inserted.Attributes
			,inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into factFind.dbo.TRefExpenditureGroupAudit(
			[Name]
			,Ordinal
			,IsConsolidateEnabled
			,TenantId
			,RegionCode
			,Attributes
			,ConcurrencyId
			,StampAction,StampDateTime,StampUser)
		select [Name]
			,Ordinal
			,IsConsolidateEnabled
			,@IndigoClientId
			,@RegionCode
			,Attributes
			,1
		from factFind.dbo.TRefExpenditureGroup
		where isnull(RegionCode,@RegionCode) = @RegionCode
			and TenantId is null
		except
		select [Name]
			,Ordinal
			,IsConsolidateEnabled
			,TenantId
			,@RegionCode
			,Attributes
			,1
		from factFind.dbo.TRefExpenditureGroup
		where TenantId = @IndigoClientId

	-- Add to TRefExpenditureType2ExpenditureGroup
	insert into FactFind.dbo.TRefExpenditureType2ExpenditureGroup(ExpenditureTypeId,ExpenditureGroupId)
	output
		inserted.RefExpenditureType2ExpenditureGroupId
		,inserted.ExpenditureTypeId
		,inserted.ExpenditureGroupId
		,1
		,'C', getdate(), @StampUser
	into FactFind.dbo.TRefExpenditureType2ExpenditureGroupAudit(
		RefExpenditureType2ExpenditureGroupId
		,ExpenditureTypeId
		,ExpenditureGroupId
		,ConcurrencyId
		,StampAction,StampDateTime,StampUser)
	select et.RefExpenditureTypeId, teg.RefExpenditureGroupId
	from FactFind.dbo.TRefExpenditureType2ExpenditureGroup eteg
	inner join FactFind.dbo.TRefExpenditureGroup seg on seg.RefExpenditureGroupId = eteg.ExpenditureGroupId
	inner join FactFind.dbo.TRefExpenditureGroup teg on teg.[Name] = seg.[Name] and teg.Ordinal = seg.Ordinal
	inner join FactFind.dbo.TRefExpenditureType et on et.RefExpenditureTypeId = eteg.ExpenditureTypeId
	where seg.TenantId = @SourceIndigoClientId
	and teg.TenantId = @IndigoClientId
	except
	select eteg.ExpenditureTypeId, eteg.ExpenditureGroupId
	from FactFind.dbo.TRefExpenditureType2ExpenditureGroup eteg
	inner join FactFind.dbo.TRefExpenditureGroup teg on teg.RefExpenditureGroupId = eteg.ExpenditureGroupId
	where teg.TenantId = @IndigoClientId

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
