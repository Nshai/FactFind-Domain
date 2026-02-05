SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefSystemEvent]
	@StampUser varchar (255),
	@RefSystemEventId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefSystemEventAudit 
( Identifier, ConcurrencyId, 
	RefSystemEventId, StampAction, StampDateTime, StampUser) 
Select Identifier, ConcurrencyId, 
	RefSystemEventId, @StampAction, GetDate(), @StampUser
FROM TRefSystemEvent
WHERE RefSystemEventId = @RefSystemEventId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
