SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningActiveScenario]
	@StampUser varchar (255),
	@FinancialPlanningActiveScenarioId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningActiveScenarioAudit 
(FinancialPlanningId, FinancialPlanningScenarioId, ConcurrencyId,
	FinancialPlanningActiveScenarioId, StampAction, StampDateTime, StampUser)
SELECT  FinancialPlanningId, FinancialPlanningScenarioId, ConcurrencyId,
	FinancialPlanningActiveScenarioId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningActiveScenario
WHERE FinancialPlanningActiveScenarioId = @FinancialPlanningActiveScenarioId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
