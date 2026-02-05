SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditObjectiveType]
	@StampUser varchar (255),
	@ObjectiveTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TObjectiveTypeAudit 
( Identifier, Archived, ConcurrencyId, 
	ObjectiveTypeId, StampAction, StampDateTime, StampUser) 
Select Identifier, Archived, ConcurrencyId, 
	ObjectiveTypeId, @StampAction, GetDate(), @StampUser
FROM TObjectiveType
WHERE ObjectiveTypeId = @ObjectiveTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
