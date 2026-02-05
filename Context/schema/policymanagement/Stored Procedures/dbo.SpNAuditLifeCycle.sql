SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditLifeCycle]
	@StampUser varchar (255),
	@LifeCycleId bigint,
	@StampAction char(1)
AS

INSERT INTO TLifeCycleAudit (
	Name, Descriptor, [Status], PreQueueBehaviour,
	PostQueueBehaviour, CreatedDate, CreatedUser, IndigoClientId,
	ConcurrencyId, LifeCycleId, StampAction, StampDateTime, StampUser,
	[IgnorePostCheckIfPreHasBeenCompleted])
SELECT 
	Name, Descriptor, [Status], PreQueueBehaviour,
	PostQueueBehaviour, CreatedDate, CreatedUser, IndigoClientId,
	ConcurrencyId, LifeCycleId, @StampAction, GETDATE(), @StampUser,
	[IgnorePostCheckIfPreHasBeenCompleted]
FROM 
	TLifeCycle
WHERE 
	LifeCycleId = @LifeCycleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
