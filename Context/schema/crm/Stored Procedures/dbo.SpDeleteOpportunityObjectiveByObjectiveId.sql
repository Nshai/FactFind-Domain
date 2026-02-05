SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDeleteOpportunityObjectiveByObjectiveId]
	@ObjectiveId bigint,
	@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TOpportunityObjectiveAudit (
    OpportunityId, 
    ObjectiveId, 
    ConcurrencyId,
    OpportunityObjectiveId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.OpportunityId, 
    T1.ObjectiveId, 
    T1.ConcurrencyId,
    T1.OpportunityObjectiveId,
    'D',
    GetDate(),
    @StampUser

  FROM TOpportunityObjective T1
  WHERE (T1.ObjectiveId = @ObjectiveId)

  DELETE T1 FROM TOpportunityObjective T1
  WHERE (T1.ObjectiveId = @ObjectiveId)

  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)


GO
