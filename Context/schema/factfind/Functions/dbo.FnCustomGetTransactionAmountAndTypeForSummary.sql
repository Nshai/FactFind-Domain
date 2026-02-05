--Function to Return the following for Recommendation Summary
--Contribution and Withdrawal Amount
--Contribution and Withdrawal Frequency
--IO-32105 Add this as part of this. This Function is much similar to Recommendation screen

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function dbo.FnCustomGetTransactionAmountAndTypeForSummary
(
@PartyId bigint,
@ServiceCaseId bigint
)

Returns @TransactionDetails TABLE     

(    

 -- Add the column definitions for the TABLE variable here    

 ActionPlanId bigint Not null,  

 ActionPlanContributionId bigint null,  

 ActionPlanWithdrawalId bigint null,  

 ContributionAmount decimal(18,2) null,     

 WithdrawalAmount decimal(18,2) null,    

 ContributionFrequency varchar(50) null,    

 WithdrawalFrequency varchar(50) null,
 
 WithdrawalType varchar(50) null,

 ContributionType varchar(50) null

)    

As 
Begin
 -- Fill the table variable with the rows for your result set    

 DECLARE @TempTransactionDetailsTable TABLE    

 (    

 ActionPlanId bigint,  

 ActionPlanContributionId bigint null,  

 ActionPlanWithdrawalId bigint null,  

 ContributionAmount decimal(18,2) null,      

 ContributionType varchar(50) null,    

 ContributorType varchar(50) null,    

 WithdrawalAmount decimal(18,2) null,    

 WithdrawalType varchar(50) null,

 ContributionFrequency varchar(50) null,    

 WithdrawalFrequency varchar(50) null     

 )   

  
 --Contributions  

 INSERT INTO @TempTransactionDetailsTable    

 SELECT AP.ActionPlanId, APC.ActionPlanContributionId, Null, APC.ContributionAmount, RCT.RefContributionTypeName,  

 RCRT.RefContributorTypeName, Null, Null , APC.ContributionFrequency, NULL  

 FROM TActionPlanContribution APC    

 Inner join TActionPlan AP on ap.ActionPlanId = APC.ActionPlanId AND (AP.IsNewProposal = 1 OR AP.TopupParentPolicyBusinessId > 0)  
 
 Inner join TFinancialPlanningSession fs on fs.FinancialPlanningId = Ap.FinancialPlanningId

 Inner JOIN policymanagement..TRefContributionType RCT ON APC.RefContributionTypeId =RCT.RefContributionTypeId    

 Inner JOIN policymanagement..TRefContributorType RCRT ON APC.RefContributorTypeId = RCRT.RefContributorTypeId    

 Where fs.CRMContactId = @PartyId and fs.ServiceCaseId = @ServiceCaseId 

   

  --Withdrawals  

 INSERT INTO @TempTransactionDetailsTable    

 SELECT AP.ActionPlanId, Null, APW.ActionPlanWithdrawalId, Null, Null,  

 Null, APW.WithdrawalAmount, APW.WithdrawalType , NULL, APW.WithdrawalFrequency 

 FROM TActionPlanWithdrawal APW    

 Inner join TActionPlan AP on ap.ActionPlanId  = apw.ActionPlanId AND (AP.IsNewProposal = 1 OR AP.TopupParentPolicyBusinessId > 0)    

 Inner join TFinancialPlanningSession fs on fs.FinancialPlanningId = Ap.FinancialPlanningId

 Where fs.CRMContactId = @PartyId and fs.ServiceCaseId = @ServiceCaseId 

   

   --Self regular from new plans

  INSERT INTO @TransactionDetails    

  SELECT ActionPlanId, ActionPlanContributionId, Null, ContributionAmount, Null, ContributionFrequency, NUll,WithdrawalType, ContributionType  

  FROM @TempTransactionDetailsTable   

  Where ContributionType = 'Regular' and ContributorType = 'Self'   

   

   --Employer regular from new plans

  INSERT INTO @TransactionDetails    

  SELECT ttd.ActionPlanId, ttd.ActionPlanContributionId, Null, ttd.ContributionAmount, Null,  

  ttd.ContributionFrequency, Null,ttd.WithdrawalType, ttd.ContributionType FROM @TempTransactionDetailsTable ttd 

  Left join @TransactionDetails td on td.ActionPlanId = ttd.ActionPlanId 

  Where ttd.ContributionType = 'Regular' and ttd.ContributorType = 'Employer' and td.ActionPlanId is null  

   

      --Lump sum from new plan or top up's

  INSERT INTO @TransactionDetails    

  SELECT ttd.ActionPlanId, ttd.ActionPlanContributionId, Null, ttd.ContributionAmount, Null,  

  ttd.ContributionFrequency, Null,ttd.WithdrawalType,ttd.ContributionType FROM @TempTransactionDetailsTable ttd   

  Left join @TransactionDetails td on td.ActionPlanId = ttd.ActionPlanId 

  Where ttd.ContributionType = 'Lump Sum' and td.ActionPlanId is null 

  

   --All withdrawals

  INSERT INTO @TransactionDetails    

  SELECT ttd.ActionPlanId, Null, ttd.ActionPlanWithdrawalId, Null, ttd.WithdrawalAmount,  

  Null, ttd.WithdrawalFrequency,ttd.WithdrawalType,null FROM @TempTransactionDetailsTable ttd  

  Left join @TransactionDetails td on td.ActionPlanId = ttd.ActionPlanId 

  Where ttd.ActionPlanWithdrawalId > 0 and td.ActionPlanId is null  

    

  --SELECT * FROM @TransactionDetails  

 RETURN;    

END    
GO
