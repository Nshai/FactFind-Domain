SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditExpenditureChange]
	@StampUser varchar (255),
	@ExpenditureChangeId bigint,
	@StampAction char(1)
AS

INSERT INTO TExpenditureChangeAudit (ExpenditureChangeId, ConcurrencyId, CRMContactId, CRMContactId2, IsRise, Amount, Frequency, StartDate, [Description], StampAction, StampDateTime, StampUser)
SELECT ExpenditureChangeId, ConcurrencyId, CRMContactId, CRMContactId2, IsRise, Amount, Frequency, StartDate, [Description], @StampAction, GETDATE(), @StampUser
FROM TExpenditureChange
WHERE ExpenditureChangeId = @ExpenditureChangeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
