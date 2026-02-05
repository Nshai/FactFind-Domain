SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEntity]
	@StampUser varchar (255),
	@EntityId bigint,
	@StampAction char(1)
AS

INSERT INTO TEntityAudit 
( Identifier, Descriptor, Db, ConcurrencyId, 
		
	EntityId, StampAction, StampDateTime, StampUser) 
Select Identifier, Descriptor, Db, ConcurrencyId, 
		
	EntityId, @StampAction, GetDate(), @StampUser
FROM TEntity
WHERE EntityId = @EntityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
