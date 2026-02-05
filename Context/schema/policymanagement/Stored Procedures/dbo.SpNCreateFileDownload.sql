SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFileDownload]
	@StampUser varchar (255),
	@QuoteId bigint, 
	@Status varchar(50)  = NULL, 
	@Url varchar(512)  = NULL, 
	@FileType varchar(50)  = NULL, 
	@StatusTime datetime = NULL	
AS


DECLARE @FileDownloadId bigint, @Result int
			
	
INSERT INTO TFileDownload
(QuoteId, Status, Url, FileType, StatusTime, ConcurrencyId)
VALUES(@QuoteId, @Status, @Url, @FileType, @StatusTime, 1)

SELECT @FileDownloadId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh

Execute @Result = dbo.SpNAuditFileDownload @StampUser, @FileDownloadId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveFileDownloadByFileDownloadId @FileDownloadId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
