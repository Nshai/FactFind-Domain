SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpNAuditPlanTypeExceptionToPlanType]
	@StampUser varchar (255),
	@PlanTypeExceptionToPlanTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanTypeExceptionToPlanTypeAudit
(PlanTypeExceptionToPlanTypeId, PlanTypeExceptionId, RefPlanType2ProdSubTypeId, TenantId, ConcurrencyId,
	StampAction, StampDateTime, StampUser)
SELECT PlanTypeExceptionToPlanTypeId, PlanTypeExceptionId, RefPlanType2ProdSubTypeId, TenantId, ConcurrencyId,
	@StampAction, GetDate(), @StampUser
FROM TPlanTypeExceptionToPlanType
WHERE PlanTypeExceptionToPlanTypeId = @PlanTypeExceptionToPlanTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
