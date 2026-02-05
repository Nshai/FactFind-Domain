SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditExpenditure]
	@StampUser varchar (255),
	@ExpenditureId bigint,
	@StampAction char(1)
AS

INSERT INTO TExpenditureAudit 
(ConcurrencyId, CRMContactId, IsDetailed, NetMonthlySummaryAmount, IsChangeExpected, IsRiseExpected, 
	ChangeAmount, ChangeReason,
	ExpenditureId, StampAction, StampDateTime, StampUser,HasFactFindLiabilitiesImported)
SELECT  ConcurrencyId, CRMContactId, IsDetailed, NetMonthlySummaryAmount, IsChangeExpected, IsRiseExpected, 
	ChangeAmount, ChangeReason,
	ExpenditureId, @StampAction, GetDate(), @StampUser,HasFactFindLiabilitiesImported
FROM TExpenditure
WHERE ExpenditureId = @ExpenditureId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
