SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningLock]
	@StampUser varchar (255),
	@FinancialPlanningLockId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningLockAudit 
(FinancialPlanningId, LockDate, ConcurrencyId,
	FinancialPlanningLockId, StampAction, StampDateTime, StampUser)
SELECT  FinancialPlanningId, LockDate, ConcurrencyId,
	FinancialPlanningLockId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningLock
WHERE FinancialPlanningLockId = @FinancialPlanningLockId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
