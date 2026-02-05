SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditImportType]
	@StampUser varchar (255),
	@ImportTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TImportTypeAudit 
( InternalIdentifier, ImportTypeName, DTOObjectName, ConcurrencyId, 
		
	ImportTypeId, StampAction, StampDateTime, StampUser) 
Select InternalIdentifier, ImportTypeName, DTOObjectName, ConcurrencyId, 
		
	ImportTypeId, @StampAction, GetDate(), @StampUser
FROM TImportType
WHERE ImportTypeId = @ImportTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
