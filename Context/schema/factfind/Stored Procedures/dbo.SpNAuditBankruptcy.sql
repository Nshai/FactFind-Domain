SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditBankruptcy]
	@StampUser varchar (255),
	@BankruptcyId bigint,
	@StampAction char(1)
AS

INSERT INTO TBankruptcyAudit 
( CRMContactId, bankruptcyDischargedFg, bankruptcyDate, bankruptcyApp1, 
		bankruptcyApp2, ConcurrencyId, 
	BankruptcyId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, bankruptcyDischargedFg, bankruptcyDate, bankruptcyApp1, 
		bankruptcyApp2, ConcurrencyId, 
	BankruptcyId, @StampAction, GetDate(), @StampUser
FROM TBankruptcy
WHERE BankruptcyId = @BankruptcyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
