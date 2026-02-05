SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefWithdrawalType]
	@StampUser varchar (255),
	@RefWithdrawalTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefWithdrawalTypeAudit 
( WithdrawalName, RetireFg, ConcurrencyId, 
	RefWithdrawalTypeId, StampAction, StampDateTime, StampUser) 
Select WithdrawalName, RetireFg, ConcurrencyId, 
	RefWithdrawalTypeId, @StampAction, GetDate(), @StampUser
FROM TRefWithdrawalType
WHERE RefWithdrawalTypeId = @RefWithdrawalTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
