SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefXMLMessageType]
	@StampUser varchar (255),
	@RefXMLMessageTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefXMLMessageTypeAudit 
( Identifier, IsArchived, ConcurrencyId, 
	RefXMLMessageTypeId, StampAction, StampDateTime, StampUser) 
Select Identifier, IsArchived, ConcurrencyId, 
	RefXMLMessageTypeId, @StampAction, GetDate(), @StampUser
FROM TRefXMLMessageType
WHERE RefXMLMessageTypeId = @RefXMLMessageTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
