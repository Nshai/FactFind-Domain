SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


 
CREATE PROCEDURE [dbo].[spCustomResetDefaultDashboards]
@IndigoClientId bigint,
@SourceIndigoClientId bigint
AS

set xact_abort on

begin transaction

  -- Remove existing dashboard layout
  -----------------------------------------------------------------
  delete p
  output deleted.DashboardPermissionsId, deleted.DashboardId, deleted.RoleId, deleted.isAllowed, deleted.ConcurrencyId, 'D', getdate(), 0   
  into TDashboardPermissionsAudit (DashboardPermissionsId, DashboardId, RoleId, isAllowed, ConcurrencyId, StampAction, StampDateTime, StampUser)
  from TDashboardPermissions p
  inner join TDashboardLayout l on p.DashboardId = l.DashboardId
  where l.TenantId = @IndigoClientId

  delete gl
  output deleted.DashboardGroupId, deleted.DashboardId, deleted.DisplayOrder, 'D', GETDATE(), '0'
  into TDashboardGroupLayoutAudit (DashboardGroupId, DashboardId, DisplayOrder, StampAction, StampDateTime, StampUser)
  from TDashboardGroupLayout gl
  inner join TDashboardGroup g on gl.DashboardGroupId = g.DashboardGroupId
  where g.TenantId = @IndigoClientId

  delete TDashboardLayout 
  output deleted.Name, deleted.Layout, deleted.TenantId, deleted.IsPublic, deleted.OwnerId, deleted.ConcurrencyId, deleted.DashboardId, 'D', getdate(), 0   
  into TDashboardLayoutAudit (Name, Layout, TenantId, IsPublic, OwnerId, ConcurrencyId, DashboardId, StampAction, StampDateTime, StampUser)
  where TenantId = @IndigoClientId

  delete TDashboardGroup 
  output deleted.Type, deleted.OwnerType, deleted.TenantId, deleted.UserId, deleted.ConcurrencyId, deleted.DashboardGroupId, 'D', getdate(), 0   
  into TDashboardGroupAudit (Type, OwnerType, TenantId, UserId, ConcurrencyId, DashboardGroupId, StampAction, StampDateTime, StampUser)
  where TenantId = @IndigoClientId  

  -- Add the new default dashboards
  -----------------------------------------------------------------
  declare @HomeDashboardGroupId uniqueidentifier
  select @HomeDashboardGroupId = newid()

  insert TDashboardGroup (DashboardGroupId, Type, OwnerType, TenantId, ConcurrencyId)
  output inserted.Type, inserted.OwnerType, inserted.TenantId, inserted.UserId, inserted.ConcurrencyId, inserted.DashboardGroupId, 'C', getdate(), 0   
  into TDashboardGroupAudit (Type, OwnerType, TenantId, UserId, ConcurrencyId, DashboardGroupId, StampAction, StampDateTime, StampUser)
  values(@HomeDashboardGroupId, 0, 0, @IndigoClientId, 1)

  declare @ClientDashboardGroupId uniqueidentifier
  select @ClientDashboardGroupId = newid()

  insert TDashboardGroup (DashboardGroupId, Type, OwnerType, TenantId, ConcurrencyId)
  output inserted.Type, inserted.OwnerType, inserted.TenantId, inserted.UserId, inserted.ConcurrencyId, inserted.DashboardGroupId, 'C', getdate(), 0   
  into TDashboardGroupAudit (Type, OwnerType, TenantId, UserId, ConcurrencyId, DashboardGroupId, StampAction, StampDateTime, StampUser)
  values(@ClientDashboardGroupId, 1, 0, @IndigoClientId, 1)

  -- Add default dashboard layout and group layout here!!

  -- Add all dashboard layouts from source tenant
  insert [TDashboardLayout] ([DashboardId], [Name], [Layout], [TenantId], [IsPublic], [ConcurrencyId])
  output INSERTED.Name, INSERTED.Layout, INSERTED.TenantId, INSERTED.IsPublic, INSERTED.OwnerId, INSERTED.ConcurrencyId, INSERTED.DashboardId, 'C',GETDATE(),'0'
  INTO TDashboardLayoutAudit (Name, Layout, TenantId, IsPublic, OwnerId, ConcurrencyId, DashboardId, StampAction, StampDateTime, StampUser)
  SELECT newid(), [Name], [Layout], @IndigoClientId, [IsPublic], 1
  from TDashboardLayout where TenantId = @SourceIndigoClientId

  -- Add home dashboard layouts
  insert TDashboardGroupLayout (DashboardGroupId, DashboardId, DisplayOrder)
  output INSERTED.DashboardGroupId, INSERTED.DashboardId, INSERTED.DisplayOrder, 'C',GETDATE(),'0'
  into TDashboardGroupLayoutAudit (DashboardGroupId, DashboardId, DisplayOrder, StampAction, StampDateTime, StampUser)
  select @HomeDashboardGroupId, ddest.DashboardId, DisplayOrder
  from TDashboardGroupLayout dgl
  inner join TDashboardGroup dg on dgl.DashboardGroupId = dg.DashboardGroupId
  inner join TDashboardLayout d on dgl.DashboardId = d.DashboardId
  inner join TDashboardLayout ddest on d.Name = ddest.Name and ddest.TenantId = @IndigoClientId
  where dg.Type = 0 and dg.TenantId = @SourceIndigoClientId

  -- Add client dashboard layouts
  insert TDashboardGroupLayout (DashboardGroupId, DashboardId, DisplayOrder)
  output INSERTED.DashboardGroupId, INSERTED.DashboardId, INSERTED.DisplayOrder, 'C',GETDATE(),'0'
  into TDashboardGroupLayoutAudit (DashboardGroupId, DashboardId, DisplayOrder, StampAction, StampDateTime, StampUser)
  select @ClientDashboardGroupId, ddest.DashboardId, DisplayOrder
  from TDashboardGroupLayout dgl
  inner join TDashboardGroup dg on dgl.DashboardGroupId = dg.DashboardGroupId
  inner join TDashboardLayout d on dgl.DashboardId = d.DashboardId
  inner join TDashboardLayout ddest on d.Name = ddest.Name and ddest.TenantId = @IndigoClientId
  where dg.Type = 1 and dg.TenantId = @SourceIndigoClientId

  INSERT INTO TDashboardPermissions (DashboardId, RoleId, isAllowed, ConcurrencyId)
  OUTPUT INSERTED.DashboardId, INSERTED.RoleId, INSERTED.isAllowed, INSERTED.ConcurrencyId, INSERTED.DashboardPermissionsId, 'C', GETDATE(), '0'
  INTO TDashboardPermissionsAudit (DashboardId, RoleId, isAllowed, ConcurrencyId, DashboardPermissionsId, StampAction, StampDateTime, StampUser)
  SELECT 
  (select top 1 ddest.DashboardId from TDashboardLayout ddest where ddest.Name = d.Name and ddest.TenantId = @IndigoClientId), 
  (select top 1 rdest.RoleId from TRole rdest where rdest.Identifier = r.Identifier and rdest.IndigoClientId = @IndigoClientId), 
  dp.isAllowed, 1
  FROM TDashboardPermissions dp
  inner join TDashboardLayout d on dp.DashboardId = d.DashboardId
  inner join TRole r on dp.RoleId = r.RoleId
  where d.TenantId = @SourceIndigoClientId 
  and r.IndigoClientId = @SourceIndigoClientId
  and exists(select top 1 ddest.DashboardId from TDashboardLayout ddest where ddest.Name = d.Name and ddest.TenantId = @IndigoClientId)
  and exists(select top 1 rdest.RoleId from TRole rdest where rdest.Identifier = r.Identifier and rdest.IndigoClientId = @IndigoClientId)
  
  insert TDashboardComponentPermissions(DashboardComponentId, RoleId, isAllowed, ConcurrencyId)
  output inserted.DashboardComponentId, inserted.RoleId, inserted.isAllowed, inserted.ConcurrencyId, inserted.DashboardComponentPermissionsId, 'C', GETDATE(), '0'
  into TDashboardComponentPermissionsAudit (DashboardComponentId, RoleId, isAllowed, ConcurrencyId, DashboardComponentPermissionsId, StampAction, StampDateTime, StampUser)
  select c.DashboardComponentId, r.RoleId, 1, 1
  from TDashboardComponent c
  cross join TRole r    
  left join TDashboardComponentPermissions pdest on c.DashboardComponentId = pdest.DashboardComponentId and r.RoleId = pdest.RoleId
  where pdest.DashboardComponentId is null and r.IndigoClientId = @IndigoClientId
  
  update TDashboardComponentPermissions
  set IsAllowed = 1
  output deleted.DashboardComponentId, deleted.RoleId, deleted.isAllowed, deleted.ConcurrencyId, deleted.DashboardComponentPermissionsId, 'U', GETDATE(), '0'
  into TDashboardComponentPermissionsAudit (DashboardComponentId, RoleId, isAllowed, ConcurrencyId, DashboardComponentPermissionsId, StampAction, StampDateTime, StampUser)
  from TDashboardComponentPermissions p
  inner join TRole r on p.RoleId = r.RoleId
  where p.isAllowed = 0 and r.IndigoClientId = @IndigoClientId

commit

GO
