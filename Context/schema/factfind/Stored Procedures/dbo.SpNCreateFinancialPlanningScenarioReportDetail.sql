SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFinancialPlanningScenarioReportDetail]      
 @StampUser varchar (255),      
 @FinancialPlanningId bigint,       
 @FinancialPlanningScenarioId bigint,       
 @IsRebalance varchar(50)  = NULL,       
 @StartDate varchar(50)  = NULL,       
 @TargetDate varchar(50)  = NULL,       
 @TaxWrapper varchar(50)  = NULL,       
 @InitialLumpSum varchar(50)  = NULL,       
 @MonthlyContribution varchar(50)  = NULL,       
 @AnnualWithdrawal varchar(50)  = NULL,       
 @AnnualWithdrawalPercent varchar(50)  = NULL,       
 @AnnualWithdrawalIncrease varchar(50)  = NULL,      
 @TaxWrapper2 varchar(50)  = NULL,       
 @InitialLumpSum2 varchar(50)  = NULL,       
 @MonthlyContribution2 varchar(50)  = NULL,       
 @AnnualWithdrawal2 varchar(50)  = NULL,       
 @AnnualWithdrawalPercent2 varchar(50)  = NULL,       
 @AnnualWithdrawalIncrease2 varchar(50)  = NULL,      
 @RiskProfile  varchar(50)  = NULL,      
 @IsFinal bit = 0       
AS      
      
      
DECLARE @FinancialPlanningScenarioReportDetailId bigint, @Result int      
         
       
INSERT INTO TFinancialPlanningScenarioReportDetail      
(FinancialPlanningId, FinancialPlanningScenarioId, IsRebalance, StartDate, TargetDate, TaxWrapper,   TaxWrapper2,    
 InitialLumpSum, MonthlyContribution, AnnualWithdrawal, AnnualWithdrawalPercent, AnnualWithdrawalIncrease,IsFinal, ConcurrencyId    
 ,InitialLumpSum2,MonthlyContribution2,AnnualWithdrawal2,AnnualWithdrawalPercent2,AnnualWithdrawalIncrease2 , Riskprofile   
 )      
VALUES(@FinancialPlanningId, @FinancialPlanningScenarioId, @IsRebalance, @StartDate, @TargetDate, @TaxWrapper, @TaxWrapper2,      
 @InitialLumpSum, @MonthlyContribution, @AnnualWithdrawal, @AnnualWithdrawalPercent, @AnnualWithdrawalIncrease,@IsFinal, 1,    
 @InitialLumpSum2,@MonthlyContribution2,@AnnualWithdrawal2,@AnnualWithdrawalPercent2,@AnnualWithdrawalIncrease2,@Riskprofile)      
      
SELECT @FinancialPlanningScenarioReportDetailId = SCOPE_IDENTITY(), @Result = @@ERROR      
      
Execute @Result = dbo.SpNAuditFinancialPlanningScenarioReportDetail @StampUser, @FinancialPlanningScenarioReportDetailId, 'C'      
      
      
RETURN (0)   
GO
