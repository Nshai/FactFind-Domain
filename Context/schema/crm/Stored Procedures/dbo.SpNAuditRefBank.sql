SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefBank]
	@StampUser varchar (255),
	@RefBankId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefBankAudit 
( Name, ConcurrencyId, 
	RefBankId, StampAction, StampDateTime, StampUser) 
Select Name, ConcurrencyId, 
	RefBankId, @StampAction, GetDate(), @StampUser
FROM TRefBank
WHERE RefBankId = @RefBankId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
