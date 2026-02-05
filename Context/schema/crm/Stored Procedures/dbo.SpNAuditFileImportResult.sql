SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpNAuditFileImportResult
	@StampUser varchar (255),
	@FileImportResultId bigint,
	@StampAction char(1)
AS

INSERT INTO TFileImportResultAudit 
( FileImportId, LineNumber, Descriptor, RefFileImportTypeId, Result, Identifier,
		 ConcurrencyId, FileImportResultId, StampAction, StampDateTime, StampUser) 
Select FileImportId, LineNumber, Descriptor,RefFileImportTypeId, Result, Identifier,
		 ConcurrencyId, FileImportResultId, @StampAction, GetDate(), @StampUser
FROM TFileImportResult
WHERE FileImportResultId = @FileImportResultId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
