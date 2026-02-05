SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditImportResult]
	@StampUser varchar (255),
	@ImportResultId bigint,
	@StampAction char(1)
AS

INSERT INTO TImportResultAudit 
( ImportFileId, LineNumber, Descriptor, Result, 
		IOEntityTypeId, EntityId, ConcurrencyId, 
	ImportResultId, StampAction, StampDateTime, StampUser) 
Select ImportFileId, LineNumber, Descriptor, Result, 
		IOEntityTypeId, EntityId, ConcurrencyId, 
	ImportResultId, @StampAction, GetDate(), @StampUser
FROM TImportResult
WHERE ImportResultId = @ImportResultId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
