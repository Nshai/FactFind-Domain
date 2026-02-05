SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditBatchFileParsed]
	@StampUser varchar (255),
	@BatchFileParsedId bigint,
	@StampAction char(1)
AS

INSERT INTO TBatchFileParsedAudit
( BatchFileParsedId, [FileName], IsSuccess, StatusDescription, DateProcessed, IndigoClientId, BatchFileProcessId, ConcurrencyId, StampAction, StampDateTime, StampUser) 
SELECT BatchFileParsedId, [FileName], IsSuccess, StatusDescription, DateProcessed, IndigoClientId, BatchFileProcessId, ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM TBatchFileParsed
WHERE BatchFileParsedId = @BatchFileParsedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO