SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditArrears]
	@StampUser varchar (255),
	@ArrearsId bigint,
	@StampAction char(1)
AS

INSERT INTO TArrearsAudit 
( CRMContactId, arrDateFirst, arrMissedNo, arrStillNo, 
		arrDateClear, arrWillBeClearedFg, arrApp1, arrApp2, 
		arrOutstanding, ConcurrencyId, 
	ArrearsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, arrDateFirst, arrMissedNo, arrStillNo, 
		arrDateClear, arrWillBeClearedFg, arrApp1, arrApp2, 
		arrOutstanding, ConcurrencyId, 
	ArrearsId, @StampAction, GetDate(), @StampUser
FROM TArrears
WHERE ArrearsId = @ArrearsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
