Create PROCEDURE [dbo].[SpNAuditFileImportQueuedFile]
	@StampUser varchar (255),
	@FileImportQueuedFileId uniqueidentifier,
	@StampAction char(1)
AS

INSERT INTO TFileImportQueuedFileAudit 
( TenantId, UserId, EntryDate, DeferUntil, 
		SerializedJobData, FileImportHeaderId, NumberOfRecords, 
		EstimatedStartDate,
	FileImportQueuedFileId, StampAction, StampDateTime, StampUser) 
Select TenantId, UserId, EntryDate, DeferUntil, 
		SerializedJobData, FileImportHeaderId, NumberOfRecords, 
		EstimatedStartDate, 
	FileImportQueuedFileId, @StampAction, GetDate(), @StampUser
FROM TFileImportQueuedFile
WHERE FileImportQueuedFileId = @FileImportQueuedFileId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)