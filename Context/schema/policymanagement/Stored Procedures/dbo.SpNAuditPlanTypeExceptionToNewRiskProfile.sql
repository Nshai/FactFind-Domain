SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditPlanTypeExceptionToNewRiskProfile]
	@StampUser varchar (255),
	@PlanTypeExceptionToNewRiskProfileId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanTypeExceptionToNewRiskProfileAudit
(PlanTypeExceptionToRiskProfileId, PlanTypeExceptionId, AtrTemplateId, RiskProfileId, TenantId, ConcurrencyId,
	StampAction, StampDateTime, StampUser)
SELECT PlanTypeExceptionToRiskProfileId, PlanTypeExceptionId, AtrTemplateId, RiskProfileId, TenantId, ConcurrencyId,
	@StampAction, GetDate(), @StampUser
FROM TPlanTypeExceptionToNewRiskProfile
WHERE PlanTypeExceptionToRiskProfileId = @PlanTypeExceptionToNewRiskProfileId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO