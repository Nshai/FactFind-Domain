SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefReturnDeathType]
	@StampUser varchar (255),
	@RefReturnDeathTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefReturnDeathTypeAudit 
( RefReturnDeathTypeName, RetireFg, ConcurrencyId, 
	RefReturnDeathTypeId, StampAction, StampDateTime, StampUser) 
Select RefReturnDeathTypeName, RetireFg, ConcurrencyId, 
	RefReturnDeathTypeId, @StampAction, GetDate(), @StampUser
FROM TRefReturnDeathType
WHERE RefReturnDeathTypeId = @RefReturnDeathTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
