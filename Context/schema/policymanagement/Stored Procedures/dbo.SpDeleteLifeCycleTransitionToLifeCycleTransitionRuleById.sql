SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpDeleteLifeCycleTransitionToLifeCycleTransitionRuleById]
@LifeCycleTransitionToLifeCycleTransitionRuleId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TLifeCycleTransitionToLifeCycleTransitionRuleAudit (
    LifeCycleTransitionId, 
    LifeCycleTransitionRuleId, 
    ConcurrencyId,
    LifeCycleTransitionToLifeCycleTransitionRuleId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.LifeCycleTransitionId, 
    T1.LifeCycleTransitionRuleId, 
    T1.ConcurrencyId,
    T1.LifeCycleTransitionToLifeCycleTransitionRuleId,
    'D',
    GetDate(),
    @StampUser

  FROM TLifeCycleTransitionToLifeCycleTransitionRule T1

  WHERE (T1.LifeCycleTransitionToLifeCycleTransitionRuleId = @LifeCycleTransitionToLifeCycleTransitionRuleId)
  DELETE T1 FROM TLifeCycleTransitionToLifeCycleTransitionRule T1

  WHERE (T1.LifeCycleTransitionToLifeCycleTransitionRuleId = @LifeCycleTransitionToLifeCycleTransitionRuleId)


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
