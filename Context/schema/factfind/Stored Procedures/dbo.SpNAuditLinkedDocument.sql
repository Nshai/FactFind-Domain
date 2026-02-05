SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLinkedDocument]
	@StampUser varchar (255),
	@LinkedDocumentId bigint,
	@StampAction char(1)
AS

INSERT INTO TLinkedDocumentAudit 
( FactFindTypeId, FolderId, DocumentId, DateLinked, 
		LinkedByUserId, ConcurrencyId, 
	LinkedDocumentId, StampAction, StampDateTime, StampUser) 
Select FactFindTypeId, FolderId, DocumentId, DateLinked, 
		LinkedByUserId, ConcurrencyId, 
	LinkedDocumentId, @StampAction, GetDate(), @StampUser
FROM TLinkedDocument
WHERE LinkedDocumentId = @LinkedDocumentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
