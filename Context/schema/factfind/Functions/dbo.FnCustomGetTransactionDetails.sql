SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION dbo.FnCustomGetTransactionDetails
(
@ServicaseId int
)    
RETURNS     
@TransactionDetails TABLE     
(    
 -- Add the column definitions for the TABLE variable here    
 ActionPlanId int Not null,  
 ActionPlanContributionId int null,  
 ActionPlanWithdrawalId int null,  
 ContributionAmount decimal(18,2) null,     
 WithdrawalAmount decimal(18,2) null,    
 ContributionType varchar(50) null,    
 WithdrawalType varchar(50) null,
 ContributionFrequency varchar(50) null,    
 WithdrawalFrequency varchar(50) null,
 IsWithdrawalIncreased bit null,
 IsContributionIncreased bit null,   
 IsEncashment bit null 
)    
AS    
BEGIN    
 -- Fill the table variable with the rows for your result set    
 DECLARE @TempTransactionDetailsTable TABLE    
 (    
 ActionPlanId int,  
 ActionPlanContributionId int null,  
 ActionPlanWithdrawalId int null,  
 ContributionAmount decimal(18,2) null,      
 ContributionType varchar(50) null,    
 ContributorType varchar(50) null,    
 WithdrawalAmount decimal(18,2) null,    
 WithdrawalType varchar(50) null,
 ContributionFrequency varchar(50) null,    
 WithdrawalFrequency varchar(50) null,
 IsWithdrawalIncreased bit null,
 IsContributionIncreased bit null,   
 IsEncashment bit null   
 )   
  
 --Contributions  
 INSERT INTO @TempTransactionDetailsTable    
 SELECT AP.ActionPlanId, APC.ActionPlanContributionId, Null, APC.ContributionAmount, RCT.RefContributionTypeName,  
 RCRT.RefContributorTypeName, Null, Null, apc.ContributionFrequency, null, null, apc.IsIncreased, null  
 FROM  TFinancialPlanningSession fps		
 INNER JOIN TFinancialPlanningScenario fpsc	ON fpsc.FinancialPlanningId = fps.FinancialPlanningId
 INNER JOIN TActionPlan AP 	ON ap.ScenarioId = fpsc.FinancialPlanningScenarioId AND (AP.IsNewProposal = 1 OR AP.TopupParentPolicyBusinessId > 0)  
 INNER JOIN TActionPlanContribution APC   ON apc.ActionPlanId = ap.ActionPlanId
 INNER JOIN policymanagement..TRefContributionType RCT 	ON APC.RefContributionTypeId =RCT.RefContributionTypeId    
 INNER JOIN policymanagement..TRefContributorType RCRT 	ON APC.RefContributorTypeId = RCRT.RefContributorTypeId    
 WHERE fps.ServiceCaseId = @ServicaseId
 
   
  --Withdrawals  
 INSERT INTO @TempTransactionDetailsTable    
 SELECT AP.ActionPlanId, Null, APW.ActionPlanWithdrawalId, Null, Null,  
 Null, APW.WithdrawalAmount, APW.WithdrawalType, null, apw.WithdrawalFrequency, apw.IsIncreased,null , apw.IsEncashment  
 FROM  TFinancialPlanningSession fps		
 INNER JOIN TFinancialPlanningScenario fpsc	ON fpsc.FinancialPlanningId = fps.FinancialPlanningId
 Inner join TActionPlan AP on ap.ScenarioId = fpsc.FinancialPlanningScenarioId  AND (AP.IsNewProposal = 1 OR AP.TopupParentPolicyBusinessId > 0)    
 INNER JOIN TActionPlanWithdrawal APW ON apw.ActionPlanId = ap.ActionPlanId 
 WHERE fps.ServiceCaseId = @ServicaseId
   
   --Self regular from new plans
  INSERT INTO @TransactionDetails    
  SELECT ActionPlanId, ActionPlanContributionId, Null, ContributionAmount, Null,  
  ContributionType, Null, ContributionFrequency, null, null, IsContributionIncreased, null FROM @TempTransactionDetailsTable   
  Where ContributionType = 'Regular' and ContributorType = 'Self'   
   
   --Employer regular from new plans
  INSERT INTO @TransactionDetails    
  SELECT ttd.ActionPlanId, ttd.ActionPlanContributionId, Null, ttd.ContributionAmount, Null,  
  ttd.ContributionType, Null,ttd.ContributionFrequency, null, null, ttd.IsContributionIncreased, null  FROM @TempTransactionDetailsTable ttd 
  Left join @TransactionDetails td on td.ActionPlanId = ttd.ActionPlanId 
  Where ttd.ContributionType = 'Regular' and ttd.ContributorType = 'Employer' and td.ActionPlanId is null  
   
      --Lump sum from new plan or top up's
  INSERT INTO @TransactionDetails    
  SELECT ttd.ActionPlanId, ttd.ActionPlanContributionId, Null, ttd.ContributionAmount, Null,  
  ttd.ContributionType, Null,ttd.ContributionFrequency, null, null, ttd.IsContributionIncreased, null FROM @TempTransactionDetailsTable ttd   
  Left join @TransactionDetails td on td.ActionPlanId = ttd.ActionPlanId 
  Where ttd.ContributionType = 'Lump Sum' and td.ActionPlanId is null 
  
   --All withdrawals
  INSERT INTO @TransactionDetails    
  SELECT ttd.ActionPlanId, Null, ttd.ActionPlanWithdrawalId, Null, ttd.WithdrawalAmount,  
  Null, ttd.WithdrawalType,null, ttd.WithdrawalFrequency, ttd.IsWithdrawalIncreased, null, ttd.IsEncashment FROM @TempTransactionDetailsTable ttd  
  Left join @TransactionDetails td on td.ActionPlanId = ttd.ActionPlanId 
  Where ttd.ActionPlanWithdrawalId > 0 and td.ActionPlanId is null  
  
  INSERT INTO @TransactionDetails    
  SELECT AP.ActionPlanId, Null, APW.ActionPlanWithdrawalId, Null, APW.WithdrawalAmount, null, 
  APW.WithdrawalType,null, APW.WithdrawalFrequency, apw.IsIncreased, null, apw.IsEncashment  
  FROM  TFinancialPlanningSession fps		
  INNER JOIN TFinancialPlanningScenario fpsc ON fpsc.FinancialPlanningId = fps.FinancialPlanningId
  Inner join TActionPlan AP ON ap.ScenarioId = fpsc.FinancialPlanningScenarioId  AND (AP.IsNewProposal = 0 OR AP.TopupParentPolicyBusinessId is null)    
  INNER JOIN TActionPlanWithdrawal APW  ON apw.ActionPlanId = ap.ActionPlanId 
  LEFT JOIN @TransactionDetails td ON td.ActionPlanId = AP.ActionPlanId 
  WHERE fps.ServiceCaseId = @ServicaseId and  td.ActionPlanId is null  
		
  INSERT INTO @TransactionDetails    
  SELECT AP.ActionPlanId, APC.ActionPlanContributionId, Null, APC.ContributionAmount,  null,
  RCT.RefContributionTypeName,   null, APC.ContributionFrequency, null, null, apc.IsIncreased, null
  FROM  TFinancialPlanningSession fps		
  INNER JOIN TFinancialPlanningScenario fpsc ON fpsc.FinancialPlanningId = fps.FinancialPlanningId
  INNER JOIN TActionPlan AP ON ap.ScenarioId = fpsc.FinancialPlanningScenarioId AND (AP.IsNewProposal = 0 OR AP.TopupParentPolicyBusinessId is null)  
  INNER JOIN TActionPlanContribution APC  ON apc.ActionPlanId = ap.ActionPlanId
  INNER JOIN policymanagement..TRefContributionType RCT ON APC.RefContributionTypeId =RCT.RefContributionTypeId    
  INNER JOIN policymanagement..TRefContributorType RCRT ON APC.RefContributorTypeId = RCRT.RefContributorTypeId    
  LEFT JOIN @TransactionDetails td on td.ActionPlanId = AP.ActionPlanId 
  WHERE fps.ServiceCaseId = @ServicaseId AND  td.ActionPlanId is null  
    
    
 RETURN;    
END    
GO
