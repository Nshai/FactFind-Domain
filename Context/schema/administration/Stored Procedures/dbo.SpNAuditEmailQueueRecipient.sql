SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEmailQueueRecipient]
	@StampUser varchar (255),
	@EmailQueueRecipientId bigint,
	@StampAction char(1)
AS

INSERT INTO TEmailQueueRecipientAudit 
( EmailQueueId, CRMContactId, PolicyBusinessId, FeeId, StatusId, Leadid,
		AddedToQueueDate, SentDate, SentBody, ConcurrencyId, 
		
	EmailQueueRecipientId, StampAction, StampDateTime, StampUser) 
Select EmailQueueId, CRMContactId, PolicyBusinessId, FeeId, StatusId, Leadid,
		AddedToQueueDate, SentDate, SentBody, ConcurrencyId, 
		
	EmailQueueRecipientId, @StampAction, GetDate(), @StampUser
FROM TEmailQueueRecipient
WHERE EmailQueueRecipientId = @EmailQueueRecipientId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
