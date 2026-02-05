SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditImportFile]
	@StampUser varchar (255),
	@ImportFileId bigint,
	@StampAction char(1)
AS

INSERT INTO TImportFileAudit 
( TenantId, ImportTypeId, PartyId, EntryDate, 
		OriginalFileName, OriginalFilePath, FileSize, DocVersionId, 
		ProcessedTimeStamp, ProcessStartTimeStamp, PotentialImports, NumberImported, 
		NumberFailed, NumberDuplicates, IsDeferred, IsAllowDuplicates, 
		ConcurrencyId, 
	ImportFileId, StampAction, StampDateTime, StampUser) 
Select TenantId, ImportTypeId, PartyId, EntryDate, 
		OriginalFileName, OriginalFilePath, FileSize, DocVersionId, 
		ProcessedTimeStamp, ProcessStartTimeStamp, PotentialImports, NumberImported, 
		NumberFailed, NumberDuplicates, IsDeferred, IsAllowDuplicates, 
		ConcurrencyId, 
	ImportFileId, @StampAction, GetDate(), @StampUser
FROM TImportFile
WHERE ImportFileId = @ImportFileId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
