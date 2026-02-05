SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefEscalationType]
	@StampUser varchar (255),
	@RefEscalationTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefEscalationTypeAudit 
( EscalationType, RetireFg, ConcurrencyId, 
	RefEscalationTypeId, StampAction, StampDateTime, StampUser) 
Select EscalationType, RetireFg, ConcurrencyId, 
	RefEscalationTypeId, @StampAction, GetDate(), @StampUser
FROM TRefEscalationType
WHERE RefEscalationTypeId = @RefEscalationTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
