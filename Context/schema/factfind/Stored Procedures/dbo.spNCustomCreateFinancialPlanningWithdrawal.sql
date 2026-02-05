SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomCreateFinancialPlanningWithdrawal]
@FinancialPlanningId bigint,
@PolicyBusinessId bigint,
@Withdrawal decimal,
@StampUser varchar(255)

as

declare @RefFrequencyId bigint,
		@RefWithdrawalTypeId bigint,
		@StartDate datetime,
		@EndDate datetime

select @RefFrequencyId = 8,
	   @RefWithdrawalTypeId = 1

select  @StartDate = StartDate,
		@EndDate = TargetDate
from	TFinancialPLanningScenario
where	FinancialPlanningId = @FinancialPlanningId and
		PrefferedScenario = 1

if(@StartDate is null) begin
	select @StartDate = getdate()
	select @EndDate = max(TargetDate)
						 from TFinancialPlanningSelectedGoals g  
						 inner join TObjective o on o.objectiveid = g.objectiveid  
						 where g.FinancialPlanningId = @FinancialPlanningId  
end

exec policymanagement..SpCreatePolicyMoneyOut
@StampUser = @StampUser,
@PolicyBusinessId = @PolicyBusinessId,
@Amount = @Withdrawal,
@PaymentStartDate = @StartDate,
@PaymentStopDate = @EndDate,
@RefFrequencyId = @RefFrequencyId,
@RefWithdrawalTypeId = @RefWithdrawalTypeId 




GO
