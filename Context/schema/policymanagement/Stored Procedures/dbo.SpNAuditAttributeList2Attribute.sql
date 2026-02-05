SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAttributeList2Attribute]
	@StampUser varchar (255),
	@AttributeList2AttributeId bigint,
	@StampAction char(1)
AS

INSERT INTO TAttributeList2AttributeAudit 
( AttributeListId, AttributeId, ConcurrencyId, 
	AttributeList2AttributeId, StampAction, StampDateTime, StampUser) 
Select AttributeListId, AttributeId, ConcurrencyId, 
	AttributeList2AttributeId, @StampAction, GetDate(), @StampUser
FROM TAttributeList2Attribute
WHERE AttributeList2AttributeId = @AttributeList2AttributeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
