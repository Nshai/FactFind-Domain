SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomFinancialPlanningResetChangedFunds] 

@StampUser varchar(50), 
@FinancialPlanningId bigint

as


insert into TFinancialPlanningAdditionalFundAudit
(FundId,
FinancialPlanningId,
UnitQuantity,
UnitPrice,
FundDetails,
ConcurrencyId,
FinancialPlanningAdditionalFundId,
StampAction,
StampDateTime,
StampUser)
select 
FundId,
FinancialPlanningId,
UnitQuantity,
UnitPrice,
FundDetails,
ConcurrencyId,
FinancialPlanningAdditionalFundId,
'D',
getdate(),
@StampUser
from TFinancialPlanningAdditionalFund
where	FinancialPlanningId = @FinancialPlanningId

delete a
from TFinancialPlanningAdditionalFund a
where	FinancialPlanningId = @FinancialPlanningId


insert into TFinancialPlanningSelectedFundsRevisedAudit
(FinancialPlanningSelectedFundsId,
PolicyBusinessFundId,
RevisedValue,
RevisedPercentage,
IsLocked,
IsExecuted,
ConcurrencyId,
FinancialPlanningSelectedFundsRevisedId,
StampAction,
StampDateTime,
StampUser)
select
a.FinancialPlanningSelectedFundsId,
a.PolicyBusinessFundId,
a.RevisedValue,
a.RevisedPercentage,
a.IsLocked,
a.IsExecuted,
a.ConcurrencyId,
a.FinancialPlanningSelectedFundsRevisedId,
'D',
getdate(),
@StampUser
from TFinancialPlanningSelectedFundsRevised a
inner join TFinancialPlanningSelectedFunds b on b.FinancialPlanningSelectedFundsId = a.FinancialPlanningSelectedFundsId
inner join TFinancialPlanningSelectedInvestments c on c.FinancialPlanningSelectedInvestmentsId = b.FinancialPlanningSelectedInvestmentsId
where FinancialPlanningId = @FinancialPlanningId
	
delete a	
from TFinancialPlanningSelectedFundsRevised a
inner join TFinancialPlanningSelectedFunds b on b.FinancialPlanningSelectedFundsId = a.FinancialPlanningSelectedFundsId
inner join TFinancialPlanningSelectedInvestments c on c.FinancialPlanningSelectedInvestmentsId = b.FinancialPlanningSelectedInvestmentsId
where FinancialPlanningId = @FinancialPlanningId
GO
