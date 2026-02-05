SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAttachment]
	@StampUser varchar (255),
	@AttachmentId bigint,
	@StampAction char(1)
AS

INSERT INTO TAttachmentAudit 
( EmailId, AttachmentSize, AttachmentName, AttachmentDocId, 
		ConcurrencyId, 
	AttachmentId, StampAction, StampDateTime, StampUser) 
Select EmailId, AttachmentSize, AttachmentName, AttachmentDocId, 
		ConcurrencyId, 
	AttachmentId, @StampAction, GetDate(), @StampUser
FROM TAttachment
WHERE AttachmentId = @AttachmentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
