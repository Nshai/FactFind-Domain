SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpDeleteTransitionRoleByLifeCycleTransitionId]
@LifeCycleTransitionId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
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
    'D',
    GetDate(),
    @StampUser

  FROM TTransitionRole T1

  WHERE (T1.LifeCycleTransitionId = @LifeCycleTransitionId)
  DELETE T1 FROM TTransitionRole T1

  WHERE (T1.LifeCycleTransitionId = @LifeCycleTransitionId)


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
