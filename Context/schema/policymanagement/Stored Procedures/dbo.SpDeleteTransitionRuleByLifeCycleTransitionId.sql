SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpDeleteTransitionRuleByLifeCycleTransitionId]
@LifeCycleTransitionId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TTransitionRuleAudit (
    RuleSPName, 
    LifeCycleTransitionId, 
    Alias, 
    ConcurrencyId,
    TransitionRuleId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.RuleSPName, 
    T1.LifeCycleTransitionId, 
    T1.Alias, 
    T1.ConcurrencyId,
    T1.TransitionRuleId,
    'D',
    GetDate(),
    @StampUser

  FROM TTransitionRule T1

  WHERE (T1.LifeCycleTransitionId = @LifeCycleTransitionId)
  DELETE T1 FROM TTransitionRule T1

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
