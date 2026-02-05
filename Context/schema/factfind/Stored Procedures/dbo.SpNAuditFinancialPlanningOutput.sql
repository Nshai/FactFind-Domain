SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningOutput]
	@StampUser varchar (255),
	@FinancialPlanningOutputId int,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningOutputAudit 
( 
	Name
	, FinancialPlanningSessionId
	, FinancialPlanningOutputId
	, FinancialPlanningOutputTypeId
	, FinancialPlanningScenarioId
	, ConcurrencyId
	, Ordinal
	, StampAction
	, StampDateTime
	, StampUser) 
Select Name
	, FinancialPlanningSessionId
	, FinancialPlanningOutputId
	, FinancialPlanningOutputTypeId
	, FinancialPlanningScenarioId
	, ConcurrencyId
	, Ordinal
	, @StampAction
	, GetDate()
	, @StampUser
FROM TFinancialPlanningOutput
WHERE FinancialPlanningOutputId = @FinancialPlanningOutputId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
