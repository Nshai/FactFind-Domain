SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNUpdateFinancialPlanningExtByFinancialPlanningId]

@StampUser varchar (50),
@FinancialPlanningId bigint,
@PensionIncrease varchar(50),
@SpousePercentage int,
@GuaranteePeriod varchar(50),
@StatePension bit

as

insert into TFinancialPlanningExtAudit(
FinancialPlanningId,
PensionIncrease,
SpousePercentage,
GuaranteePeriod,
StatePension,
DefaultLumpSum,
DefaultMonthlyPremium,
ConcurrencyId,
FinancialPlanningExtId,
StampAction,
StampDateTime,
StampUser
)
select 
FinancialPlanningId,
PensionIncrease,
SpousePercentage,
GuaranteePeriod,
StatePension,
DefaultLumpSum,
DefaultMonthlyPremium,
ConcurrencyId,
FinancialPlanningExtId,
'U',
getdate(),
@StampUser
from	TFinancialPlanningExt
where	FinancialPlanningId = @FinancialPlanningId

update FPE 
set	FinancialPlanningId = @FinancialPlanningId,
	PensionIncrease = @PensionIncrease,
	SpousePercentage = @SpousePercentage,	
	GuaranteePeriod = @GuaranteePeriod,	
	StatePension = @StatePension,
	ConcurrencyId = ConcurrencyId + 1
from TFinancialPlanningExt FPE
where	FinancialPlanningId = @FinancialPlanningId

SELECT T1.FinancialPlanningId, T1.FactFindId, T1.AdjustValue, T1.RefPlanningTypeId, T1.RefInvestmentTypeId, T1.IncludeAssets, T1.RegularImmediateIncome, T1.ConcurrencyId,
	T2.PensionIncrease,
	T2.SpousePercentage,	
	T2.GuaranteePeriod,
	isnull(T2.StatePension,0) as StatePension,
	DefaultLumpSum,
	DefaultMonthlyPremium
FROM TFinancialPlanning  T1
left join TFinancialPlanningExt T2 on T2.FinancialPlanningId = T1.FinancialPlanningId
WHERE T1.FinancialPlanningId = @FinancialPlanningId

GO
