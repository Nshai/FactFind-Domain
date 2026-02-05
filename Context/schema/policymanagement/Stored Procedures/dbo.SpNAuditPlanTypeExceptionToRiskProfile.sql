SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--drop PROCEDURE [dbo].[SpNAuditPlanTypeExceptionToRiskProfile]
CREATE PROCEDURE [dbo].[SpNAuditPlanTypeExceptionToRiskProfile]
	@StampUser varchar (255),
	@PlanTypeExceptionToRiskProfileId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanTypeExceptionToRiskProfileAudit
(PlanTypeExceptionToRiskProfileId, PlanTypeExceptionId, RiskProfileGuid, TenantId, ConcurrencyId,
	StampAction, StampDateTime, StampUser)
SELECT PlanTypeExceptionToRiskProfileId, PlanTypeExceptionId, RiskProfileGuid, TenantId, ConcurrencyId,
	@StampAction, GetDate(), @StampUser
FROM TPlanTypeExceptionToRiskProfile
WHERE PlanTypeExceptionToRiskProfileId = @PlanTypeExceptionToRiskProfileId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
