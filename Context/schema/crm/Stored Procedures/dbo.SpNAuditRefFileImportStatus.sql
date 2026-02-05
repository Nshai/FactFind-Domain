SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpNAuditRefFileImportStatus
	@StampUser varchar (255),
	@RefFileImportStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefFileImportStatusAudit 
( RefFileImportStatusId, Name, ConcurrencyId, StampAction, StampDateTime, StampUser) 
Select RefFileImportStatusId, Name, ConcurrencyId,  @StampAction, GetDate(), @StampUser
FROM TRefFileImportStatus
WHERE RefFileImportStatusId = @RefFileImportStatusId 

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
