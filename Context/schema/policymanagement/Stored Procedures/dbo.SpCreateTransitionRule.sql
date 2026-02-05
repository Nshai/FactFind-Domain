SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateTransitionRule]
@StampUser varchar (255),
@RuleSPName varchar (128),
@LifeCycleTransitionId bigint,
@Alias varchar (1000) = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @TransitionRuleId bigint

  INSERT INTO TTransitionRule (
    RuleSPName, 
    LifeCycleTransitionId, 
    Alias, 
    ConcurrencyId ) 
  VALUES (
    @RuleSPName, 
    @LifeCycleTransitionId, 
    @Alias, 
    1) 

  SELECT @TransitionRuleId = SCOPE_IDENTITY()
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
    'C',
    GetDate(),
    @StampUser

  FROM TTransitionRule T1
 WHERE T1.TransitionRuleId=@TransitionRuleId
  EXEC SpRetrieveTransitionRuleById @TransitionRuleId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
