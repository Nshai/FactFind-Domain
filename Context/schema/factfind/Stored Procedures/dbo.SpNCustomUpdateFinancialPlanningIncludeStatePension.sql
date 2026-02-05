SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomUpdateFinancialPlanningIncludeStatePension] 
@StampUser varchar (255),
@FinancialPlanningId bigint,
@Include bit

as

insert into TFinancialPlanningExtAudit
(FinancialPlanningId,
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
StampUser)
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
getDate(),
@StampUser
from	TFinancialPlanningExt
where	FinancialPlanningId = @FinancialPlanningId


update	TFinancialPlanningExt
set		StatePension = @Include,
		ConcurrencyId = ConcurrencyId +1
where	FinancialPlanningId = @FinancialPlanningId



GO
