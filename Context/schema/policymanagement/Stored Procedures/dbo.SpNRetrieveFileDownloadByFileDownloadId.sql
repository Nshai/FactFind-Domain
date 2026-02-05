SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveFileDownloadByFileDownloadId]
	@FileDownloadId bigint
AS

SELECT T1.FileDownloadId, T1.QuoteId, T1.Status, T1.Url, T1.FileType, T1.StatusTime, T1.ConcurrencyId
FROM TFileDownload  T1
WHERE T1.FileDownloadId = @FileDownloadId
GO
