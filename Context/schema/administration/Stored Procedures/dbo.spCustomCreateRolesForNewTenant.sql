SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create Procedure [dbo].[spCustomCreateRolesForNewTenant]
(
	@NewTenantId BIGINT
	,@SourceIndigoClientId BIGINT
)
AS
BEGIN

Declare @RoleId bigint, @NewTenantGroupingId bigint
    
insert into administration..trole (Identifier, RefLicenseTypeId, GroupingId, SuperUser, IndigoClientId,     
    LicensedUserCount, Dashboard, ShowGroupDashboard, ConcurrencyId)    
values ('System Administrator',1,0,1,@NEwTenantID,     
 0,'administratorDashboard',1,1)    
    
Select @RoleId=SCOPE_IDENTITY()    
    
SELECT @RoleId = SCOPE_IDENTITY()    
  INSERT INTO TRoleAudit (Identifier, RefLicenseTypeId,GroupingId, SuperUser, IndigoClientId, LicensedUserCount,     
    Dashboard, ShowGroupDashboard, ConcurrencyId, RoleId, HasGroupDataAccess,
    StampAction,StampDateTime,StampUser)    
  SELECT    
    T1.Identifier, T1.RefLicenseTypeId, T1.GroupingId, T1.SuperUser, T1.IndigoClientId, T1.LicensedUserCount,     
    T1.Dashboard, T1.ShowGroupDashboard, T1.ConcurrencyId, T1.RoleId, T1.HasGroupDataAccess,
    'C', GetDate(), '0'    
  FROM TRole T1    
 WHERE T1.RoleId=@RoleId    

-- Pull through all the remaing roles (other than the above defaulted one) for @SourceIndigoClientId (AME-424)
INSERT INTO administration..trole (Identifier,RefLicenseTypeId, GroupingId, SuperUser, IndigoClientId, DashBoard, ShowGRoupDashBoard, concurrencyId)        
SELECT Identifier, RefLicenseTypeId,GroupingId, SuperUser,@NewTenantId, DashBoard, ShowGRoupDashBoard, concurrencyId 
FROM administration..trole WHERE indigoclientid=@SourceIndigoClientId AND Identifier != 'System Administrator'   


DECLARE @SourceGroupingIdentifier varchar(255), @RoleIdentifier varchar(255)        
        
-- lets copy the hierarchy        
DECLARE role_cursor CURSOR        
FOR 
 SELECT A.Identifier, B.Identifier FROM Administration..TRole A         
 INNER JOIN administration..TGrouping B on a.groupingid=b.groupingid        
 where A.indigoclientid=@SourceIndigoClientId        
 order by a.roleid asc        
 OPEN role_cursor        
        
 FETCH NEXT FROM role_cursor Into @RoleIdentifier,@SourceGroupingIdentifier        
        
 WHILE @@FETCH_STATUS = 0        
 BEGIN        
 -- get the grouping id from our new tenant for this role        
  SELECT @NewTenantGroupingId=GroupingId from Administration..TGrouping where Identifier = @SourceGroupingIdentifier and Indigoclientid=@NewTenantId        
  UPDATE Administration..TRole Set GroupingId=@NewTenantGroupingId where Identifier=@RoleIdentifier and Indigoclientid=@NewTenantId        
        
  FETCH NEXT FROM role_cursor Into @RoleIdentifier,@SourceGroupingIdentifier        
    END        
         
         
CLOSE role_cursor         
DEALLOCATE role_cursor        

exec spCustomCreateFeeStatusTransitionRolesForNewTenant @NewTenantId

END


GO
