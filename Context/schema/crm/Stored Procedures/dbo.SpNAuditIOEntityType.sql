SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditIOEntityType]
	@StampUser varchar (255),
	@IOEntityTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TIOEntityTypeAudit 
( EntityTypeName, ConcurrencyId, 
	IOEntityTypeId, StampAction, StampDateTime, StampUser) 
Select EntityTypeName, ConcurrencyId, 
	IOEntityTypeId, @StampAction, GetDate(), @StampUser
FROM TIOEntityType
WHERE IOEntityTypeId = @IOEntityTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
