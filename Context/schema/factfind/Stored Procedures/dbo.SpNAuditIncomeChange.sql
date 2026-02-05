SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIncomeChange]
	@StampUser varchar (255),
	@IncomeChangeId bigint,
	@StampAction char(1)
AS

INSERT INTO TIncomeChangeAudit (IncomeChangeId, ConcurrencyId, CRMContactId, IsRise, Amount, Frequency, StartDate, [Description], [IsOwnerSelected], StampAction, StampDateTime, StampUser)
SELECT IncomeChangeId, ConcurrencyId, CRMContactId, IsRise, Amount, Frequency, StartDate, [Description], [IsOwnerSelected], @StampAction, GETDATE(), @StampUser
FROM TIncomeChange
WHERE IncomeChangeId = @IncomeChangeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
