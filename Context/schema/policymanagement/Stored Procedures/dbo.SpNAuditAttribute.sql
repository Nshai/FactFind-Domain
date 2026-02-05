SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAttribute]
	@StampUser varchar (255),
	@AttributeId bigint,
	@StampAction char(1)
AS

INSERT INTO TAttributeAudit 
( Value, ConcurrencyId, 
	AttributeId, StampAction, StampDateTime, StampUser) 
Select Value, ConcurrencyId, 
	AttributeId, @StampAction, GetDate(), @StampUser
FROM TAttribute
WHERE AttributeId = @AttributeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
