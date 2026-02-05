SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningEfficientFrontier]
	@StampUser varchar (255),
	@FinancialPlanningEfficientFrontierId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningEfficientFrontierAudit 
(FinancialPlanningId,ChartUrl, Data, OriginalReturn, OriginalRisk, CurrentReturn, CurrentRisk, Term,
	ConcurrencyId, ChartDefinition,
	FinancialPlanningEfficientFrontierId, StampAction, StampDateTime, StampUser)
SELECT  FinancialPlanningId,ChartUrl, Data, OriginalReturn, OriginalRisk, CurrentReturn, CurrentRisk,  Term,
	ConcurrencyId, ChartDefinition,
	FinancialPlanningEfficientFrontierId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningEfficientFrontier
WHERE FinancialPlanningEfficientFrontierId = @FinancialPlanningEfficientFrontierId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
