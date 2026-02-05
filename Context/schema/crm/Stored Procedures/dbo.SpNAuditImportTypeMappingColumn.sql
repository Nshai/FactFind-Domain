SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditImportTypeMappingColumn]
	@StampUser varchar (255),
	@ImportTypeMappingColumnId bigint,
	@StampAction char(1)
AS

INSERT INTO TImportTypeMappingColumnAudit 
( ImportTypeId, ColumnName, DisplayName, PropertyName, 
		IsRequired, ConcurrencyId, 
	ImportTypeMappingColumnId, StampAction, StampDateTime, StampUser) 
Select ImportTypeId, ColumnName, DisplayName, PropertyName, 
		IsRequired, ConcurrencyId, 
	ImportTypeMappingColumnId, @StampAction, GetDate(), @StampUser
FROM TImportTypeMappingColumn
WHERE ImportTypeMappingColumnId = @ImportTypeMappingColumnId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
