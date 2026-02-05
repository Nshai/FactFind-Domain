SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPlanTypePurpose]
	@StampUser varchar (255),
	@PlanTypePurposeId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanTypePurposeAudit 
( RefPlanTypeId, PlanPurposeId, DefaultFg, ConcurrencyId, 
		
	PlanTypePurposeId,RefPlanType2ProdSubTypeId, StampAction, StampDateTime, StampUser) 
Select RefPlanTypeId, PlanPurposeId, DefaultFg, ConcurrencyId, 
		
	PlanTypePurposeId,RefPlanType2ProdSubTypeId, @StampAction, GetDate(), @StampUser
FROM TPlanTypePurpose
WHERE PlanTypePurposeId = @PlanTypePurposeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
