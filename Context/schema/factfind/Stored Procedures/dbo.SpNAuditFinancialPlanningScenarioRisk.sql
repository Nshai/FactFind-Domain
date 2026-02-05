SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningScenarioRisk]
	@StampUser varchar (255),
	@FinancialPlanningScenarioRiskId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningScenarioRiskAudit 
(FinancialPlanningId, ScenarioId, RiskDescription, RiskNumber, ConcurrencyId,
	FinancialPlanningScenarioRiskId, StampAction, StampDateTime, StampUser)
SELECT  FinancialPlanningId, ScenarioId, RiskDescription, RiskNumber, ConcurrencyId,
	FinancialPlanningScenarioRiskId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningScenarioRisk
WHERE FinancialPlanningScenarioRiskId = @FinancialPlanningScenarioRiskId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
