SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateStatusHistory]
@StampUser varchar (255),
@PolicyBusinessId bigint,
@StatusId bigint,
@StatusReasonId bigint = NULL,
@ChangedToDate datetime,
@ChangedByUserId bigint,
@DateOfChange datetime = NULL,
@LifeCycleStepFG bit = 0
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @StatusHistoryId bigint
  --Set all CurrentStatusFG to 0 for the current policybusiness

	--AJF - update the audit table too
	insert into tstatushistoryaudit  (policybusinessid, statusid, statusreasonid, changedtodate, changedbyuserid, dateofchange, lifecyclestepfg, currentstatusfg, concurrencyid, statushistoryid, stampaction, stampdatetime, stampuser)
	SELECT PolicyBusinessId, StatusId, StatusReasonId, ChangedToDate, ChangedByUserId, DateOfChange, LifeCycleStepFg, CurrentStatusFg, ConcurrencyId, StatusHistoryId, 'U', getdate(), @StampUser
	FROM TStatusHistory 
	WHERE PolicyBusinessId = @PolicyBusinessId
	AND CurrentStatusFg = 1

	Update TStatusHistory Set CurrentStatusFG = 0 Where PolicyBusinessId = @PolicyBusinessId AND CurrentStatusFg = 1

  INSERT INTO TStatusHistory (
    PolicyBusinessId, 
    StatusId, 
    StatusReasonId, 
    ChangedToDate, 
    ChangedByUserId, 
    DateOfChange, 
    LifeCycleStepFG, 
    CurrentStatusFG, 
    ConcurrencyId ) 
  VALUES (
    @PolicyBusinessId, 
    @StatusId, 
    @StatusReasonId, 
    @ChangedToDate, 
    @ChangedByUserId, 
    @DateOfChange, 
    @LifeCycleStepFG, 
    1, 
    1) 

  SELECT @StatusHistoryId = SCOPE_IDENTITY()
  INSERT INTO TStatusHistoryAudit (
    PolicyBusinessId, 
    StatusId, 
    StatusReasonId, 
    ChangedToDate, 
    ChangedByUserId, 
    DateOfChange, 
    LifeCycleStepFG, 
    CurrentStatusFG, 
    ConcurrencyId,
    StatusHistoryId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.PolicyBusinessId, 
    T1.StatusId, 
    T1.StatusReasonId, 
    T1.ChangedToDate, 
    T1.ChangedByUserId, 
    T1.DateOfChange, 
    T1.LifeCycleStepFG, 
    T1.CurrentStatusFG, 
    T1.ConcurrencyId,
    T1.StatusHistoryId,
    'C',
    GetDate(),
    @StampUser

  FROM TStatusHistory T1
 WHERE T1.StatusHistoryId=@StatusHistoryId
  EXEC SpRetrieveStatusHistoryById @StatusHistoryId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
