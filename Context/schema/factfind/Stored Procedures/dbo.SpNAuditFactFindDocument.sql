SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFactFindDocument]
	@StampUser varchar (255),
	@FactFindDocumentId bigint,
	@StampAction char(1)
AS

INSERT INTO TFactFindDocumentAudit 
( FactFindDocumentTypeId, DocVersionId, CrmContactId, CreatedDate, 
		Creator, IsFull, ConcurrencyId, 
	FactFindDocumentId, StampAction, StampDateTime, StampUser, MigrationRef) 
Select FactFindDocumentTypeId, DocVersionId, CrmContactId, CreatedDate, 
		Creator, IsFull, ConcurrencyId, 
	FactFindDocumentId, @StampAction, GetDate(), @StampUser, MigrationRef
FROM TFactFindDocument
WHERE FactFindDocumentId = @FactFindDocumentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
