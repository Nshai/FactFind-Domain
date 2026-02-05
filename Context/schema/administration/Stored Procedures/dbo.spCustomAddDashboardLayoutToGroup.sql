SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE procedure [dbo].[spCustomAddDashboardLayoutToGroup]
 @Name varchar(50),
 @Layout varchar(max),
 @TenantId bigint,
 @OwnerId bigint,
 @DashboardGroupId uniqueidentifier,
 @DisplayOrder tinyint
 as
 
  declare @DashboardId uniqueidentifier
  select @DashboardId = newid()

  insert TDashboardLayout (DashboardId, Name, Layout, TenantId, IsPublic, OwnerId, ConcurrencyId)
  select @DashboardId, @Name, @Layout, @TenantId, 1, null, 1
  
  insert TDashboardLayoutAudit (Name, Layout, TenantId, IsPublic, OwnerId, ConcurrencyId, DashboardId, StampAction, StampDateTime, StampUser)
  select Name, Layout, TenantId, IsPublic, OwnerId, ConcurrencyId, DashboardId, 'C', getdate(), 0   
  FROM TDashboardLayout
  WHERE DashboardId = @DashboardId 

  insert TDashboardGroupLayout (DashboardGroupId, DashboardId, DisplayOrder) values(@DashboardGroupId, @DashboardId, @DisplayOrder)

  insert TDashboardGroupLayoutAudit (DashboardGroupId, DashboardId, DisplayOrder, StampAction, StampDateTime, StampUser)
  values (@DashboardGroupId, @DashboardId, @DisplayOrder, 'C', getdate(), 0)
  
  insert TDashboardPermissions (DashboardId, RoleId, isAllowed, ConcurrencyId)
  select @DashboardId, r.RoleId, 1, 1
  from TRole r  
  where r.IndigoClientId = @TenantId

  insert TDashboardPermissionsAudit (DashboardPermissionsId, DashboardId, RoleId, isAllowed, ConcurrencyId, StampAction, StampDateTime, StampUser)
  select DashboardPermissionsId, DashboardId, RoleId, isAllowed, ConcurrencyId, 'C', getdate(), 0
  from TDashboardPermissions p 
  where DashboardId = @DashboardId

GO
