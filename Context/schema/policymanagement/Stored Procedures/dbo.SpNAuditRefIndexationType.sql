SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefIndexationType]
	@StampUser varchar (255),
	@RefIndexationTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefIndexationTypeAudit 
( IndexationTypeName, OrigoRef, FixedAmountFg, RetireFg, 
		ConcurrencyId, 
	RefIndexationTypeId, StampAction, StampDateTime, StampUser) 
Select IndexationTypeName, OrigoRef, FixedAmountFg, RetireFg, 
		ConcurrencyId, 
	RefIndexationTypeId, @StampAction, GetDate(), @StampUser
FROM TRefIndexationType
WHERE RefIndexationTypeId = @RefIndexationTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
