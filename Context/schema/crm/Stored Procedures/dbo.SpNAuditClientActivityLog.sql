SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditClientActivityLog]
	@StampUser varchar (255),
	@ClientActivityLogId bigint,
	@StampAction char(1)
AS

INSERT INTO TClientActivityLogAudit 
( CRMContactId, Activity, Application, TimeStamp, 
		ConcurrencyId, 
	ClientActivityLogId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Activity, Application, TimeStamp, 
		ConcurrencyId, 
	ClientActivityLogId, @StampAction, GetDate(), @StampUser
FROM TClientActivityLog
WHERE ClientActivityLogId = @ClientActivityLogId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
