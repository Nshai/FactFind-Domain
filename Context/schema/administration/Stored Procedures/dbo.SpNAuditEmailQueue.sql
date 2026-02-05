SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEmailQueue]
	@StampUser varchar (255),
	@EmailQueueId bigint,
	@StampAction char(1)
AS

INSERT INTO TEmailQueueAudit 
( IndigoClientId, OwnerId, QueueDescription, Subject, 
		StatusId, ToAddress, FromAddress, CcAddress, 
		BccAddress, Body, PreMergedFg, Guid, 
		MergeData, AddedDate, ConcurrencyId, 
	EmailQueueId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, OwnerId, QueueDescription, Subject, 
		StatusId, ToAddress, FromAddress, CcAddress, 
		BccAddress, Body, PreMergedFg, Guid, 
		MergeData, AddedDate, ConcurrencyId, 
	EmailQueueId, @StampAction, GetDate(), @StampUser
FROM TEmailQueue
WHERE EmailQueueId = @EmailQueueId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
