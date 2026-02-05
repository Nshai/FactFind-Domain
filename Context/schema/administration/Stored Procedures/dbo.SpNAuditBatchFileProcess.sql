SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditBatchFileProcess]
	@StampUser varchar (255),
	@BatchFileProcessId bigint,
	@StampAction char(1)
AS

INSERT INTO TBatchFileProcessAudit
( [BatchFileProcessId] , [Name], [Description], [NotificationEmails], [ApplicationLinkId], [IndigoClientId],  [ConcurrencyId], [StampAction], [StampDateTime], [StampUser]) 
SELECT [BatchFileProcessId] , [Name], [Description], [NotificationEmails], [ApplicationLinkId], [IndigoClientId],  [ConcurrencyId], @StampAction, GetDate(), @StampUser
FROM TBatchFileProcess
WHERE BatchFileProcessId = @BatchFileProcessId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO