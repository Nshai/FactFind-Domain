SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateRole]
@StampUser varchar (255),
@Identifier varchar (64),
@GroupingId bigint,
@SuperUser bit = 0,
@IndigoClientId bigint,
@LicensedUserCount int = 0,
@Dashboard varchar (255) = NULL,
@ShowGroupDashboard bit = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @RoleId bigint

  INSERT INTO TRole (
    Identifier, 
    GroupingId, 
    SuperUser, 
    IndigoClientId, 
    LicensedUserCount, 
    Dashboard, 
    ShowGroupDashboard, 
    ConcurrencyId ) 
  VALUES (
    @Identifier, 
    @GroupingId, 
    @SuperUser, 
    @IndigoClientId, 
    @LicensedUserCount, 
    @Dashboard, 
    @ShowGroupDashboard, 
    1) 

  SELECT @RoleId = SCOPE_IDENTITY()
  INSERT INTO TRoleAudit (
    Identifier, 
    GroupingId, 
    SuperUser, 
    IndigoClientId, 
    LicensedUserCount, 
    Dashboard, 
    ShowGroupDashboard, 
    ConcurrencyId,
    RoleId,
    HasGroupDataAccess,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Identifier, 
    T1.GroupingId, 
    T1.SuperUser, 
    T1.IndigoClientId, 
    T1.LicensedUserCount, 
    T1.Dashboard, 
    T1.ShowGroupDashboard, 
    T1.ConcurrencyId,
    T1.RoleId,
    T1.HasGroupDataAccess,
    'C',
    GetDate(),
    @StampUser

  FROM TRole T1
 WHERE T1.RoleId=@RoleId
  EXEC SpRetrieveRoleById @RoleId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)


GO
