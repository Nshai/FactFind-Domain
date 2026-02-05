SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditBatchFileLineError]
	@StampUser varchar (255),
	@BatchFileLineErrorId bigint,
	@StampAction char(1)
AS

INSERT INTO TBatchFileLineErrorAudit
( BatchFileLineErrorId, LineNumber, Error, LineData, BatchFileParsedId, Identifier, RecordType, ConcurrencyId, StampAction, StampDateTime, StampUser) 
SELECT BatchFileLineErrorId, LineNumber, Error, LineData, BatchFileParsedId, Identifier, RecordType, ConcurrencyId,  @StampAction, GetDate(), @StampUser
FROM TBatchFileLineError
WHERE BatchFileLineErrorId = @BatchFileLineErrorId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO

