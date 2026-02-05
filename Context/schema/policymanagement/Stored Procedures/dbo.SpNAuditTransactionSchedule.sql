SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditTransactionSchedule]
	@StampUser varchar (255),
	@TransactionScheduleId bigint,
	@StampAction char(1)
AS

INSERT INTO TTransactionScheduleAudit 
	( TransactionScheduleId, IndigoClientId, RefProdProviderId, RefGroupId, RunForDate, 
		ValScheduleId, IsLocked, ConcurrencyId, StampAction, StampDateTime, StampUser) 
SELECT TransactionScheduleId, IndigoClientId, RefProdProviderId, RefGroupId, RunForDate, ValScheduleId, IsLocked, ConcurrencyId
		, @StampAction, GetDate(), @StampUser
FROM TTransactionSchedule
WHERE TransactionScheduleId = @TransactionScheduleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
