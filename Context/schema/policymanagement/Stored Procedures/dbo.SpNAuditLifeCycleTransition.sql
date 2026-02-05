SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLifeCycleTransition]
	@StampUser varchar (255),
	@LifeCycleTransitionId bigint,
	@StampAction char(1)
AS

INSERT INTO TLifeCycleTransitionAudit 
( LifeCycleStepId, ToLifeCycleStepId, OrderNumber, Type, 
		HideStep, AddToCommissionsFg, ConcurrencyId, 
	LifeCycleTransitionId, StampAction, StampDateTime, StampUser) 
Select LifeCycleStepId, ToLifeCycleStepId, OrderNumber, Type, 
		HideStep, AddToCommissionsFg, ConcurrencyId, 
	LifeCycleTransitionId, @StampAction, GetDate(), @StampUser
FROM TLifeCycleTransition
WHERE LifeCycleTransitionId = @LifeCycleTransitionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
