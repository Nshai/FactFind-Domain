SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPlanValuation]
	@StampUser varchar (255),
	@PlanValuationId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanValuationAudit 
( PolicyBusinessId, PlanValue, PlanValueDate, RefPlanValueTypeId, 
		WhoUpdatedValue, WhoUpdatedDateTime, SurrenderTransferValue, ConcurrencyId, 
		
	PlanValuationId, StampAction, StampDateTime, StampUser, [ValuationMigrationRef]) 
Select PolicyBusinessId, PlanValue, PlanValueDate, RefPlanValueTypeId, 
		WhoUpdatedValue, WhoUpdatedDateTime, SurrenderTransferValue, ConcurrencyId, 
		
	PlanValuationId, @StampAction, GetDate(), @StampUser, [ValuationMigrationRef]
FROM TPlanValuation
WHERE PlanValuationId = @PlanValuationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
