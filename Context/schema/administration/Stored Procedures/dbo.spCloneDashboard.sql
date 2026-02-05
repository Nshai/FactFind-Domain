SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCloneDashboard] @IndigoClientId int, @SourceIndigoClientId int, @StampUser varchar(255) = '-1010'
as
begin
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
		if OBJECT_ID('tempdb..#Role') is not null drop table #Role

		select r.*, b.RoleId as NEW_RoleId
		into #Role
		from administration.dbo.TRole r
			inner join administration.dbo.TRole b on b.Identifier = r.Identifier and b.IndigoClientId = @IndigoClientId
		where r.IndigoClientId = @SourceIndigoClientId

		raiserror('TDashboardComponent',0,1) with nowait

		insert into Administration.dbo.TDashboardComponent(Identifier, [Description], ConcurrencyId, TenantId)
		output inserted.DashboardComponentId, inserted.Identifier, inserted.[Description], inserted.ConcurrencyId, inserted.TenantId
			,'C', @Now, @StampUser
		into Administration.dbo.TDashboardComponentAudit(DashboardComponentId, Identifier, [Description], ConcurrencyId, TenantId
			, StampAction, StampDateTime, StampUser)
		select Identifier, [Description], 1, @IndigoClientId
		from Administration.dbo.TDashboardComponent
		where TenantId = @SourceIndigoClientId
		except
		select Identifier, [Description], 1, TenantId
		from Administration.dbo.TDashboardComponent
		where TenantId = @IndigoClientId

		raiserror('TDashboardComponentItem',0,1) with nowait

		insert into Administration.dbo.TDashboardComponentItem(DashboardComponentId, TenantId, ItemName, [Description], Value, ConcurrencyId)
		output inserted.DashboardComponentItemId, inserted.DashboardComponentId, inserted.TenantId, inserted.ItemName, inserted.[Description], inserted.Value, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into Administration.dbo.TDashboardComponentItemAudit(DashboardComponentItemId, DashboardComponentId, TenantId, ItemName, [Description], Value, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select distinct c.DashboardComponentId, @IndigoClientId, a.ItemName, a.[Description], a.Value, 1
		from Administration.dbo.TDashboardComponentItem a
			inner join Administration.dbo.TDashboardComponent b on b.DashboardComponentId = a.DashboardComponentId
			inner join Administration.dbo.TDashboardComponent c on c.Identifier = b.Identifier and isnull(c.Description,'') = isnull(b.Description,'')
		where isnull(b.TenantId,@SourceIndigoClientId) = @SourceIndigoClientId and isnull(c.TenantId,@IndigoClientId) = @IndigoClientId
		except
		select DashboardComponentId, @IndigoClientId, ItemName, [Description], Value, 1
		from Administration.dbo.TDashboardComponentItem a
		where TenantId = @IndigoClientId


		raiserror('TDashboardComponentPermissions',0,1) with nowait

		insert into Administration.dbo.TDashboardComponentPermissions(DashboardComponentId, RoleId, isAllowed, ConcurrencyId)
		output inserted.DashboardComponentPermissionsId, inserted.DashboardComponentId, inserted.RoleId, inserted.isAllowed, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into Administration.dbo.TDashboardComponentPermissionsAudit(DashboardComponentPermissionsId, DashboardComponentId, RoleId, isAllowed, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select dct.DashboardComponentId, r.NEW_RoleId, a.isAllowed, 1
		from Administration.dbo.TDashboardComponentPermissions a
			inner join Administration.dbo.TDashboardComponent dcs on dcs.DashboardComponentId = a.DashboardComponentId and dcs.TenantId = @SourceIndigoClientId
			inner join #Role r on r.RoleId = a.RoleId
			inner join Administration.dbo.TDashboardComponent dct on dct.Identifier = dcs.Identifier and dct.TenantId = @IndigoClientId
		where isnull(dct.Description,'') = isnull(dcs.Description,'')
		except
		select a.DashboardComponentId, b.RoleId, a.isAllowed, 1
		from Administration.dbo.TDashboardComponentPermissions a
		inner join Administration.dbo.TRole b on b.RoleId = a.RoleId and b.IndigoClientId = @IndigoClientId
		inner join Administration.dbo.TDashboardComponent c on c.DashboardComponentId = a.DashboardComponentId and c.TenantId = @IndigoClientId

		if OBJECT_ID('tempdb..#DashboardGroup') is not null drop table #DashboardGroup

		select *, NEWID() as NEW_DashboardGroupId
		into #DashboardGroup
		from Administration.dbo.TDashboardGroup
		where TenantId = @SourceIndigoClientId
			and UserId is null

		-- Get existing DashboardGroup (if any). It will overwrite newly created NEW_DashboardGroupId
		update a
			set a.NEW_DashboardGroupId = b.DashboardGroupId
		from #DashboardGroup a
		inner join Administration.dbo.TDashboardGroup b on b.[Type] = a.[Type] and b.OwnerType = a.OwnerType and b.TenantId = @IndigoClientId

		raiserror('TDashboardGroup',0,1) with nowait

		insert into Administration.dbo.TDashboardGroup(DashboardGroupId, [Type], OwnerType, TenantId, UserId, ConcurrencyId)
		output inserted.DashboardGroupId, inserted.[Type], inserted.OwnerType, inserted.TenantId, inserted.UserId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into Administration.dbo.TDashboardGroupAudit(DashboardGroupId, [Type], OwnerType, TenantId, UserId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select NEW_DashboardGroupId, [Type], OwnerType, @IndigoClientId, UserId, 1
		from #DashboardGroup
		except
		select DashboardGroupId, [Type], OwnerType, TenantId, UserId, 1
		from Administration.dbo.TDashboardGroup
		where TenantId = @IndigoClientId

		if OBJECT_ID('tempdb..#DashboardLayout') is not null drop table #DashboardLayout

		select *, NEWID() as NEW_DashboardId
		into #DashboardLayout
		from Administration.dbo.TDashboardLayout
		where TenantId = @SourceIndigoClientId
			and OwnerId is null

		--alter table #DashboardLayout add NEW_DashboardId uniqueidentifier
		alter table #DashboardLayout add NEW_OwnerId int

		update a
		set a.NEW_DashboardId = b.DashboardId,
			a.Layout = b.Layout
		from #DashboardLayout a
		inner join Administration.dbo.TDashboardLayout b on b.[Name] = a.[Name] and b.TenantId = @IndigoClientId and b.IsPublic = a.IsPublic
		where b.OwnerId is null

		raiserror('TDashboardLayout',0,1) with nowait

		insert into Administration.dbo.TDashboardLayout(DashboardId, [Name], Layout, TenantId, IsPublic, OwnerId, ConcurrencyId)
		output inserted.DashboardId, inserted.[Name], inserted.Layout, inserted.TenantId, inserted.IsPublic, inserted.OwnerId, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into Administration.dbo.TDashboardLayoutAudit(DashboardId, [Name], Layout, TenantId, IsPublic, OwnerId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select NEW_DashboardId, [Name], Layout, @IndigoClientId, IsPublic, OwnerId, 1
		from #DashboardLayout
		except
		select DashboardId, [Name], Layout, TenantId, IsPublic, OwnerId, 1
		from Administration.dbo.TDashboardLayout
		where TenantId = @IndigoClientId
			and OwnerId is null

		raiserror('TDashboardGroupLayout',0,1) with nowait

		insert into Administration.dbo.TDashboardGroupLayout(DashboardGroupId, DashboardId, DisplayOrder)
		output inserted.DashboardGroupId, inserted.DashboardId, inserted.DisplayOrder
			,'C', @Now, @StampUser
		into Administration.dbo.TDashboardGroupLayoutAudit(DashboardGroupId, DashboardId, DisplayOrder
			, StampAction, StampDateTime, StampUser)

		select dg.NEW_DashboardGroupId, dl.NEW_DashboardId, a.DisplayOrder
		from Administration.dbo.TDashboardGroupLayout a
			inner join #DashboardGroup dg on dg.DashboardGroupId = a.DashboardGroupId
			inner join #DashboardLayout dl on dl.DashboardId = a.DashboardId
		except
		select DashboardGroupId, DashboardId, DisplayOrder
		from Administration.dbo.TDashboardGroupLayout

		raiserror('TDashboardPermissions',0,1) with nowait

		insert into Administration.dbo.TDashboardPermissions(DashboardId, RoleId, isAllowed, ConcurrencyId)
		output inserted.DashboardPermissionsId, inserted.DashboardId, inserted.RoleId, inserted.isAllowed, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into Administration.dbo.TDashboardPermissionsAudit(DashboardPermissionsId, DashboardId, RoleId, isAllowed, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select b.NEW_DashboardId, c.NEW_RoleId, a.isAllowed, 1
		from Administration.dbo.TDashboardPermissions a
		inner join #DashboardLayout b on b.DashboardId = a.DashboardId
		inner join #Role c on c.RoleId = a.RoleId
		except
		select DashboardId, RoleId, isAllowed, 1
		from Administration.dbo.TDashboardPermissions

		raiserror('TDashboardSecurity',0,1) with nowait

		insert into Administration.dbo.TDashboardSecurity(DashboardComponentId, RoleId, isAllowed, ConcurrencyId)
		output inserted.DashboardSecurityId, inserted.DashboardComponentId, inserted.RoleId, inserted.isAllowed, inserted.ConcurrencyId
			,'C', @Now, @StampUser
		into Administration.dbo.TDashboardSecurityAudit(DashboardSecurityId, DashboardComponentId, RoleId, isAllowed, ConcurrencyId
			, StampAction, StampDateTime, StampUser)

		select a.DashboardComponentId, b.NEW_RoleId, a.isAllowed, 1
		from Administration.dbo.TDashboardSecurity a
		inner join #Role b on b.RoleId = a.RoleId
		except
		select DashboardComponentId, RoleId, isAllowed, 1
		from Administration.dbo.TDashboardSecurity

		if @tx = 0 begin
			commit transaction TX
			set @msg=@ProcName+': commit transaction TX'
			raiserror(@msg,0,1) with nowait
		end

		if OBJECT_ID('tempdb..#Role') is not null drop table #Role
		if OBJECT_ID('tempdb..#DashboardGroup') is not null drop table #DashboardGroup
		if OBJECT_ID('tempdb..#DashboardLayout') is not null drop table #DashboardLayout

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
		
		if OBJECT_ID('tempdb..#Role') is not null drop table #Role
		if OBJECT_ID('tempdb..#DashboardGroup') is not null drop table #DashboardGroup
		if OBJECT_ID('tempdb..#DashboardLayout') is not null drop table #DashboardLayout
		raiserror(@Errmsg,16,1)
	end catch
end
GO