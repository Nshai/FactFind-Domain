SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLifeCycle2RefPlanType]
	@StampUser varchar (255),
	@LifeCycle2RefPlanTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TLifeCycle2RefPlanTypeAudit 
( LifeCycleId, RefPlanTypeId, AdviceTypeId, ConcurrencyId, 
		
	LifeCycle2RefPlanTypeId, StampAction, StampDateTime, StampUser) 
Select LifeCycleId, RefPlanTypeId, AdviceTypeId, ConcurrencyId, 
		
	LifeCycle2RefPlanTypeId, @StampAction, GetDate(), @StampUser
FROM TLifeCycle2RefPlanType
WHERE LifeCycle2RefPlanTypeId = @LifeCycle2RefPlanTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
