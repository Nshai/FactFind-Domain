SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditSchemeType]
	@StampUser varchar (255),
	@SchemeTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TSchemeTypeAudit 
( SchemeTypeName, IsRetired, ConcurrencyId, 
	SchemeTypeId, StampAction, StampDateTime, StampUser) 
Select SchemeTypeName, IsRetired, ConcurrencyId, 
	SchemeTypeId, @StampAction, GetDate(), @StampUser
FROM TSchemeType
WHERE SchemeTypeId = @SchemeTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
