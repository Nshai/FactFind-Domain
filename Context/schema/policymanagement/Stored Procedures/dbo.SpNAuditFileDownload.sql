SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFileDownload]
	@StampUser varchar (255),
	@FileDownloadId bigint,
	@StampAction char(1)
AS

INSERT INTO TFileDownloadAudit 
( QuoteId, Status, Url, FileType, 
		StatusTime, ConcurrencyId, 
	FileDownloadId, StampAction, StampDateTime, StampUser) 
Select QuoteId, Status, Url, FileType, 
		StatusTime, ConcurrencyId, 
	FileDownloadId, @StampAction, GetDate(), @StampUser
FROM TFileDownload
WHERE FileDownloadId = @FileDownloadId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
