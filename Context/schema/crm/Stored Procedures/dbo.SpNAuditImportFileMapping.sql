SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditImportFileMapping]
	@StampUser varchar (255),
	@ImportFileMappingId bigint,
	@StampAction char(1)
AS

INSERT INTO TImportFileMappingAudit 
( ImportFileId, ColumnName, ImportTypeMappingColumnId, ConcurrencyId, 
		
	ImportFileMappingId, StampAction, StampDateTime, StampUser) 
Select ImportFileId, ColumnName, ImportTypeMappingColumnId, ConcurrencyId, 
		
	ImportFileMappingId, @StampAction, GetDate(), @StampUser
FROM TImportFileMapping
WHERE ImportFileMappingId = @ImportFileMappingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
