SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIncome]
	@StampUser varchar (255),
	@IncomeId bigint,
	@StampAction char(1)
AS

INSERT INTO TIncomeAudit 
(ConcurrencyId, CRMContactId, IsChangeExpected, IsRiseExpected, ChangeAmount, ChangeReason,
	IncomeId, StampAction, StampDateTime, StampUser)
SELECT  ConcurrencyId, CRMContactId, IsChangeExpected, IsRiseExpected, ChangeAmount, ChangeReason,
	IncomeId, @StampAction, GetDate(), @StampUser
FROM TIncome
WHERE IncomeId = @IncomeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
