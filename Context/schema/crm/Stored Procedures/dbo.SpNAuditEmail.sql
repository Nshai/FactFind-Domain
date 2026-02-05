SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditEmail]
	@StampUser varchar (255),
	@EmailId bigint,
	@StampAction char(1)
AS

INSERT INTO TEmailAudit 
( Subject, SentDate, EmailSize, FromAddress, 
		OriginalEmailDocId, AttachmentCount, 
		OrganiserActivityId, OwnerPartyId, ConcurrencyId, 
	EmailId, StampAction, StampDateTime, StampUser, HasHtmlBody, MessageDocId) 
Select Subject, SentDate, EmailSize, FromAddress, 
		OriginalEmailDocId, AttachmentCount, 
		OrganiserActivityId, OwnerPartyId, ConcurrencyId, 
	EmailId, @StampAction, GetDate(), @StampUser, HasHtmlBody, MessageDocId
FROM TEmail
WHERE EmailId = @EmailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
