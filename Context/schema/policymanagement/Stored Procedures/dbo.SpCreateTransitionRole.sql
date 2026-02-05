SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateTransitionRole]
@StampUser varchar (255),
@RoleId bigint,
@LifeCycleTransitionId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @TransitionRoleId bigint

  INSERT INTO TTransitionRole (
    RoleId, 
    LifeCycleTransitionId, 
    ConcurrencyId ) 
  VALUES (
    @RoleId, 
    @LifeCycleTransitionId, 
    1) 

  SELECT @TransitionRoleId = SCOPE_IDENTITY()
  INSERT INTO TTransitionRoleAudit (
    RoleId, 
    LifeCycleTransitionId, 
    ConcurrencyId,
    TransitionRoleId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.RoleId, 
    T1.LifeCycleTransitionId, 
    T1.ConcurrencyId,
    T1.TransitionRoleId,
    'C',
    GetDate(),
    @StampUser

  FROM TTransitionRole T1
 WHERE T1.TransitionRoleId=@TransitionRoleId
  EXEC SpRetrieveTransitionRoleById @TransitionRoleId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)



GO
