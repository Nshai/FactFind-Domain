SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAttributeList]
	@StampUser varchar (255),
	@AttributeListId bigint,
	@StampAction char(1)
AS

INSERT INTO TAttributeListAudit 
( Name, Type, ConcurrencyId, 
	AttributeListId, StampAction, StampDateTime, StampUser) 
Select Name, Type, ConcurrencyId, 
	AttributeListId, @StampAction, GetDate(), @StampUser
FROM TAttributeList
WHERE AttributeListId = @AttributeListId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
