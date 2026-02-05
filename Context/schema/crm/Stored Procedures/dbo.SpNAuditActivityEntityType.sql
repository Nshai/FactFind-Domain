SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditActivityEntityType]
	@StampUser varchar (255),
	@ActivityEntityTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TActivityEntityTypeAudit 
( ActivityEntityTypeName, ConcurrencyId, 
	ActivityEntityTypeId, StampAction, StampDateTime, StampUser) 
Select ActivityEntityTypeName, ConcurrencyId, 
	ActivityEntityTypeId, @StampAction, GetDate(), @StampUser
FROM TActivityEntityType
WHERE ActivityEntityTypeId = @ActivityEntityTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
