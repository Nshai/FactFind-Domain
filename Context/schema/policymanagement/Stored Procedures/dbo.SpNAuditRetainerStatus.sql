SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRetainerStatus]
	@StampUser varchar (255),
	@RetainerStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TRetainerStatusAudit 
( RetainerId, Status, StatusNotes, StatusDate, 
		UpdatedUserId, ConcurrencyId, 
	RetainerStatusId, StampAction, StampDateTime, StampUser) 
Select RetainerId, Status, StatusNotes, StatusDate, 
		UpdatedUserId, ConcurrencyId, 
	RetainerStatusId, @StampAction, GetDate(), @StampUser
FROM TRetainerStatus
WHERE RetainerStatusId = @RetainerStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
