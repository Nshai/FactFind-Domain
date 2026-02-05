SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditMemberBankAccount]
	@StampUser varchar (255),
	@MemberBankAccountId bigint,
	@StampAction char(1)
AS

INSERT INTO TMemberBankAccountAudit 
( PolicyBusinessId, BankAccountName, BankAccountValue, ConcurrencyId, 
		
	MemberBankAccountId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, BankAccountName, BankAccountValue, ConcurrencyId, 
		
	MemberBankAccountId, @StampAction, GetDate(), @StampUser
FROM TMemberBankAccount
WHERE MemberBankAccountId = @MemberBankAccountId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
