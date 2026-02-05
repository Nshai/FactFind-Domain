SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomUpdateFinancialPlanningScenarioContribution]    
@FinancialPlanningScenarioId bigint,    
@contribution decimal(18,2),    
@IsMonthly bit,    
@IsMonthlyModelling bit,    
@stampuser varchar(255)    
    
as    
    
exec SpNAuditFinancialPlanningScenario @stampuser,@FinancialPlanningScenarioId,'U'    
    
if(@contribution > 0 and @IsMonthly = 0 and @IsMonthlyModelling = 1)    
 select @contribution = cast(@contribution/12 as decimal(18,2))    
else if(@contribution < 0)    
 select @contribution = 0    
    
    
if(@IsMonthlyModelling = 1) begin    
 Update fps    
 set  MonthlyContribution2 = @contribution,    
   InitialLumpSum2 = 0    
 from TFinancialPlanningScenario fps     
 where FinancialPlanningScenarioId = @FinancialPlanningScenarioId    
end    
else begin    
 Update fps    
 set  InitialLumpSum2 = @contribution,    
   MonthlyContribution2= 0    
 from TFinancialPlanningScenario fps     
 where FinancialPlanningScenarioId = @FinancialPlanningScenarioId    
end    
GO
