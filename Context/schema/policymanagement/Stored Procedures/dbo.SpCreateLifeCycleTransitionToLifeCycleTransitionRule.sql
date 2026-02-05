SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateLifeCycleTransitionToLifeCycleTransitionRule]
@StampUser varchar (255),
@LifeCycleTransitionId bigint,
@LifeCycleTransitionRuleId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @LifeCycleTransitionToLifeCycleTransitionRuleId bigint

  INSERT INTO TLifeCycleTransitionToLifeCycleTransitionRule (
    LifeCycleTransitionId, 
    LifeCycleTransitionRuleId, 
    ConcurrencyId ) 
  VALUES (
    @LifeCycleTransitionId, 
    @LifeCycleTransitionRuleId, 
    1) 

  SELECT @LifeCycleTransitionToLifeCycleTransitionRuleId = SCOPE_IDENTITY()
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
    'C',
    GetDate(),
    @StampUser

  FROM TLifeCycleTransitionToLifeCycleTransitionRule T1
 WHERE T1.LifeCycleTransitionToLifeCycleTransitionRuleId=@LifeCycleTransitionToLifeCycleTransitionRuleId
  EXEC SpRetrieveLifeCycleTransitionToLifeCycleTransitionRuleById @LifeCycleTransitionToLifeCycleTransitionRuleId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
