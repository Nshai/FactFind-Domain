SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomDeleteFinancialPlanningInvestmentAssetAllocation]

@StampUser varchar(255), 
@InvestmentId bigint,
@InvestmentType varchar(50)

as

insert into TFinancialPlanningInvestmentAssetAllocationAudit
(
FinancialPlanningId,
InvestmentId,
InvestmentType,
Cash,
[Property],
FixedInterest,
UKEquities,
OverseasEquities,
SpecialistEquities,
ConcurrencyId,
FinancialPlanningInvestmentAssetAllocationId,
StampAction,
StampDateTime,
StampUser
)
select 
FinancialPlanningId,
InvestmentId,
InvestmentType,
Cash,
[Property],
FixedInterest,
UKEquities,
OverseasEquities,
SpecialistEquities,
ConcurrencyId,
FinancialPlanningInvestmentAssetAllocationId,
'D',
getdate(),
@StampUser
from TFinancialPlanningInvestmentAssetAllocation
where	InvestmentId = @InvestmentId and
		InvestmentType = @InvestmentType

delete TFinancialPlanningInvestmentAssetAllocation
where	InvestmentId = @InvestmentId and
		InvestmentType = @InvestmentType

GO
