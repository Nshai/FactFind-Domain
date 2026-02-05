SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateRole]
@StampUser varchar (255),
@Name varchar (50),
@ParentRoleId bigint = NULL,
@IndClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @RoleId bigint

  INSERT INTO TRole (
    Name, 
    ParentRoleId, 
    IndClientId, 
    ConcurrencyId ) 
  VALUES (
    @Name, 
    @ParentRoleId, 
    @IndClientId, 
    1) 

  SELECT @RoleId = SCOPE_IDENTITY()
  INSERT INTO TRoleAudit (
    Name, 
    ParentRoleId, 
    IndClientId, 
    ConcurrencyId,
    RoleId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Name, 
    T1.ParentRoleId, 
    T1.IndClientId, 
    T1.ConcurrencyId,
    T1.RoleId,
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
