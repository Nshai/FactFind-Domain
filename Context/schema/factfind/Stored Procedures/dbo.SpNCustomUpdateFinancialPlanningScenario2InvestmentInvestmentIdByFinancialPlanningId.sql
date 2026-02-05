SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].SpNCustomUpdateFinancialPlanningScenario2InvestmentInvestmentIdByFinancialPlanningId 
@StampUser varchar (255),
@FinancialPlanningId bigint,
@InvestmentId int

as

insert into TFinancialPlanningScenario2InvestmentAudit
(FinancialPlanningScenarioId,
InvestmentId,
InvestmentType,
ConcurrencyId,
FinancialPlanningScenario2InvestmentId,
StampAction,
StampDateTime,
StampUser)
select	
si.FinancialPlanningScenarioId,
si.InvestmentId,
si.InvestmentType,
si.ConcurrencyId,
si.FinancialPlanningScenario2InvestmentId,
'U',
getdate(),
@StampUser
from	TFinancialPlanningScenario2Investment si
inner join TFinancialPlanningScenario  s on s.FinancialPlanningScenarioId = si.FinancialPlanningScenarioId
where	s.FinancialPlanningId = @FinancialPlanningId

update	si
set		si.investmentid = @InvestmentId 
from	TFinancialPlanningScenario2Investment si
inner join TFinancialPlanningScenario  s on s.FinancialPlanningScenarioId = si.FinancialPlanningScenarioId
where	s.FinancialPlanningId = @FinancialPlanningId
GO
