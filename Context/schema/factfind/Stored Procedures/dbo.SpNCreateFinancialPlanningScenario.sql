SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFinancialPlanningScenario]
	@StampUser varchar (255),
	@FinancialPlanningId bigint, 
	@Scenario char(1) , 
	@RetirementAge int, 
	@InitialLumpSum money = NULL, 
	@MonthlyContribution money = NULL, 
	@AnnualWithdrawal money = NULL, 
	@AnnualWithdrawalIncrease varchar(50) = NULL,
	@RiskProfile uniqueidentifier = NULL, 
	@AtrPortfolio uniqueidentifier = NULL, 
	@PODGuid uniqueidentifier  = NULL, 
	@EvalueXML xml  = NULL, 
	@PrefferedScenario bit = 0, 
	@Active bit = 0	,
	@StartDate datetime,
	@TargetDate datetime,
	@ScenarioName varchar(50),
	@IsReadOnly bit,
	@IsRebalance bit,
	@RefTaxWrapperId int
AS


DECLARE @FinancialPlanningScenarioId bigint, @Result int ,@RefTaxWrapperId2 int, @planningType int

select @planningType = refplanningtypeid from TFinancialPlanning where financialplanningid = @FinancialPlanningId

if @planningtype = 1 begin
	--investment
	select @RefTaxWrapperId = 5, @RefTaxWrapperId2 = 6	
end
else begin --pension
	select @RefTaxWrapperId = 5, @RefTaxWrapperId2 = 8
end
			
	
INSERT INTO TFinancialPlanningScenario
(FinancialPlanningId, Scenario,ScenarioName, RetirementAge, InitialLumpSum, MonthlyContribution, AnnualWithdrawal,AnnualWithdrawalIncrease,   
RiskProfile,AtrPortfolioGUID,     
 PODGuid, EvalueXML, PrefferedScenario,   
 Active,StartDate,TargetDate,IsReadOnly,  
 RebalanceInvestments,RefTaxWrapperId,ConcurrencyId,  
 RefTaxWrapperId2,InitialLumpSum2, MonthlyContribution2, AnnualWithdrawal2,AnnualWithdrawalIncrease2  
 )    
VALUES(@FinancialPlanningId, @Scenario,@ScenarioName, @RetirementAge,   
0, 0, @AnnualWithdrawal,  
@AnnualWithdrawalIncrease, @RiskProfile, @AtrPortfolio,    
 @PODGuid, @EvalueXML, @PrefferedScenario, @Active, @StartDate,  
  @TargetDate,@IsReadOnly,@IsRebalance,@RefTaxWrapperId,1,  
  @RefTaxWrapperId2,@InitialLumpSum, @MonthlyContribution, @AnnualWithdrawal,@AnnualWithdrawalIncrease    
  )    

SELECT @FinancialPlanningScenarioId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditFinancialPlanningScenario @StampUser, @FinancialPlanningScenarioId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveFinancialPlanningScenarioByFinancialPlanningScenarioId @FinancialPlanningScenarioId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
