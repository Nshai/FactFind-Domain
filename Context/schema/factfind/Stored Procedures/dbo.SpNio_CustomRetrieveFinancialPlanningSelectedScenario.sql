SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[SpNio_CustomRetrieveFinancialPlanningSelectedScenario] @FinancialPlanningId int  

  

as  

  



select a.FinancialPlanningScenarioId,  

  a.FinancialPlanningId,  

  a.Scenario,  

  a.ScenarioName,  

  RebalanceInvestments,  

  RefTaxWrapperId,  

  isnull(tw.Description,'') as TaxWrapper,  

  RefTaxWrapperId2,  

  isnull(tw2.Description,'') as TaxWrapper2,  

  a.RetirementAge,  

  a.InitialLumpSum,  

  a.MonthlyContribution,  

  a.AnnualWithdrawal,   

  isnull(AnnualWithdrawalPercent,0) as AnnualWithdrawalPercent,   

  a.AnnualWithdrawalIncrease,  

  a.InitialLumpSum2,  

  a.MonthlyContribution2,  

  a.AnnualWithdrawal2,   

  isnull(AnnualWithdrawalPercent2,0) as AnnualWithdrawalPercent2,   

  a.AnnualWithdrawalIncrease2,  

  a.RiskProfile,  

  a.AtrPortfolioGUID,   

  a.PODGuid,  

  a.EvalueXML,  

  a.PrefferedScenario,  

  a.Active,  

  IsReadOnly,  

  RSS.StatusChangeDate as StartDate,  

  TargetDate,  

  RefInvestmentTypeId,  

  a.ConcurrencyId,

  crm1.CRMContactId as Client1Id, 

  LTrim(RTrim(IsNull(crm1.Firstname,'') + ' ' + IsNull(crm1.Lastname,'') + IsNull(crm1.CorporateName,''))) as Client1Name,

  crm1.DOB as Client1Dob, 

  crm2.CRMContactId as Client2Id,

  LTrim(RTrim(IsNull(crm2.Firstname,'') + ' ' + IsNull(crm2.Lastname,'') + IsNull(crm2.CorporateName,''))) as Client2Name,

  crm2.DOB as Client2Dob,

  fp.RefPlanningTypeId,

  fps.Description as FinancialPlanningSessionName

  

from TFinancialPlanningScenario a  

left join TRefFinancialPlanningTaxWrapper tw on a.RefTaxWrapperId = tw.RefFinancialPlanningTaxWrapperId  

left join TRefFinancialPlanningTaxWrapper tw2 on a.RefTaxWrapperId2 = tw2.RefFinancialPlanningTaxWrapperId  

join TFinancialPlanning fp on fp.financialplanningid = a.financialplanningid  

join TFinancialPlanningSession fps on fp.financialplanningid = fps.financialplanningid  

left join TFactFind ff on fp.FactFindId = ff.FactFindId

left join crm..TCRMContact crm1 on ff.CRMContactId1 = crm1.crmcontactid      

left join crm..TCRMContact crm2 on ff.CRMContactId2 = crm2.crmcontactid

left join factfind..TRecommendationSolutionStatus RSS on RSS.FinancialPlanningSessionId = fps.FinancialPlanningSessionId



where a.FinancialPlanningId = @FinancialPlanningId and  

  a.PrefferedScenario = 1  
GO
