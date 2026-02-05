SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditProtection]
	@StampUser varchar (255),
	@ProtectionId bigint,
	@StampAction char(1)
AS

INSERT INTO TProtectionAudit 
( Identifier, Income, LumpSum, Term, 
		BorneBy, Joint, CrmContactId, ConcurrencyId, 
		
	ProtectionId, StampAction, StampDateTime, StampUser) 
Select Identifier, Income, LumpSum, Term, 
		BorneBy, Joint, CrmContactId, ConcurrencyId, 
		
	ProtectionId, @StampAction, GetDate(), @StampUser
FROM TProtection
WHERE ProtectionId = @ProtectionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
