SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpNAuditFileImport
	@StampUser varchar (255),
	@FileImportId bigint,
	@StampAction char(1)
AS
INSERT INTO TFileImportAudit 
(  RefFileImportTypeId,IndigoClientId, UserId, EntryDate,
        DocVersionId, FailedDocVersionId, NumberImported, RefFileImportStatusId,
		IsImported, NumberFailed, NumberDuplicates,  StatusDescription,
		ShouldImportDuplicates, ConcurrencyId, 
		FileImportId, StampAction, StampDateTime, StampUser) 
Select RefFileImportTypeId,IndigoClientId, UserId, EntryDate,
        DocVersionId, FailedDocVersionId, NumberImported, RefFileImportStatusId,
		IsImported, NumberFailed, NumberDuplicates,  StatusDescription,
		ShouldImportDuplicates, ConcurrencyId, 
		FileImportId, @StampAction, GetDate(), @StampUser
FROM TFileImport
WHERE FileImportId = @FileImportId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
