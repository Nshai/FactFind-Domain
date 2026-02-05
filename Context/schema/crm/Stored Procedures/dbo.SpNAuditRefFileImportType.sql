SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpNAuditRefFileImportType
	@StampUser varchar (255),
	@RefFileImportTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefFileImportTypeAudit 
( RefFileImportTypeId, Name, ConcurrencyId, StampAction, StampDateTime, StampUser) 
Select RefFileImportTypeId, Name, ConcurrencyId,  @StampAction, GetDate(), @StampUser
FROM TRefFileImportType
WHERE RefFileImportTypeId = @RefFileImportTypeId 

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
