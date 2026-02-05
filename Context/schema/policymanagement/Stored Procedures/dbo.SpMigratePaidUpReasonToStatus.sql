SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpMigratePaidUpReasonToStatus]
	@IndigoClientId BIGINT,
	@DeleteOffRisk BIT
AS

BEGIN

BEGIN TRAN

DECLARE @StampDateTime DateTime = GETDATE()

-----------------------------------------------------------------------------------------------------
INSERT INTO TStatusHistory
(PolicyBusinessId, StatusId, StatusReasonId, ChangedToDate, ChangedByUserId,
 DateOfChange, LifeCycleStepFG, CurrentStatusFG)
 
	--Auditing -----------------------------------------
	OUTPUT
	INSERTED.PolicyBusinessId, INSERTED.StatusId, INSERTED.StatusReasonId, INSERTED.ChangedToDate, INSERTED.ChangedByUserId,
	INSERTED.DateOfChange, INSERTED.LifeCycleStepFG, INSERTED.CurrentStatusFG, INSERTED.ConcurrencyId, INSERTED.StatusHistoryId, 
	'C', @StampDateTime, '0'
	
	INTO TStatusHistoryAudit
	(PolicyBusinessId, StatusId, StatusReasonId, ChangedToDate, ChangedByUserId,
	 DateOfChange, LifeCycleStepFG, CurrentStatusFG, ConcurrencyId, StatusHistoryId, 
	 StampAction, StampDateTime, StampUser)
	----------------------------------------------------
	
SELECT 
H.PolicyBusinessId, NewStatus.StatusId, NULL, H.ChangedToDate, 0,
@StampDateTime, H.LifeCycleStepFG, 1
FROM TStatusHistory H
INNER JOIN TStatus S ON H.StatusId = S.StatusId AND S.IntelligentOfficeStatusType = 'Off Risk'
INNER JOIN TStatusReason R ON H.StatusReasonId = R.StatusReasonId AND R.IntelligentOfficeStatusType = 'Paid Up'
INNER JOIN TStatus NewStatus ON S.IndigoClientId = NewStatus.IndigoClientId AND NewStatus.IntelligentOfficeStatusType = 'Paid Up'
WHERE H.CurrentStatusFG = 1 AND 
	  S.IndigoClientId = @IndigoClientId AND
	  R.IndigoClientId = @IndigoClientId	  
-----------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------
IF(@DeleteOffRisk = 0)
BEGIN
	UPDATE H
	SET H.CurrentStatusFG = 0

		--Auditing -----------------------------------------
		OUTPUT
		DELETED.PolicyBusinessId, DELETED.StatusId, DELETED.StatusReasonId, DELETED.ChangedToDate, DELETED.ChangedByUserId,
		DELETED.DateOfChange, DELETED.LifeCycleStepFG, DELETED.CurrentStatusFG, DELETED.ConcurrencyId, DELETED.StatusHistoryId, 
		'U', @StampDateTime, '0'
		
		INTO TStatusHistoryAudit
		(PolicyBusinessId, StatusId, StatusReasonId, ChangedToDate, ChangedByUserId,
		 DateOfChange, LifeCycleStepFG, CurrentStatusFG, ConcurrencyId, StatusHistoryId, 
		 StampAction, StampDateTime, StampUser)
		----------------------------------------------------
	
	FROM TStatusHistory H
	INNER JOIN TStatus S ON H.StatusId = S.StatusId AND S.IntelligentOfficeStatusType = 'Off Risk'
	INNER JOIN TStatusReason R ON H.StatusReasonId = R.StatusReasonId AND R.IntelligentOfficeStatusType = 'Paid Up'
	WHERE H.CurrentStatusFG = 1 AND
		  S.IndigoClientId = @IndigoClientId AND
		  R.IndigoClientId = @IndigoClientId
END	
ELSE
BEGIN
	DELETE H
	
		--Auditing -----------------------------------------
		OUTPUT
		DELETED.PolicyBusinessId, DELETED.StatusId, DELETED.StatusReasonId, DELETED.ChangedToDate, DELETED.ChangedByUserId,
		DELETED.DateOfChange, DELETED.LifeCycleStepFG, DELETED.CurrentStatusFG, DELETED.ConcurrencyId, DELETED.StatusHistoryId, 
		'D', @StampDateTime, '0'
		
		INTO TStatusHistoryAudit
		(PolicyBusinessId, StatusId, StatusReasonId, ChangedToDate, ChangedByUserId,
		 DateOfChange, LifeCycleStepFG, CurrentStatusFG, ConcurrencyId, StatusHistoryId, 
		 StampAction, StampDateTime, StampUser)
		----------------------------------------------------
		
	FROM TStatusHistory H
	INNER JOIN TStatus S ON H.StatusId = S.StatusId AND S.IntelligentOfficeStatusType = 'Off Risk'
	INNER JOIN TStatusReason R ON H.StatusReasonId = R.StatusReasonId AND R.IntelligentOfficeStatusType = 'Paid Up'
	WHERE H.CurrentStatusFG = 1 AND
		  S.IndigoClientId = @IndigoClientId AND
		  R.IndigoClientId = @IndigoClientId
END
-----------------------------------------------------------------------------------------------------

COMMIT TRAN

END