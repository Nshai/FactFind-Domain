SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomRetrievePlansForCRMContactAuthor]            
   @CRMContactId1 bigint,            
   @CRMContactId2 bigint,            
   @NotOnRiskFG bit =0            
AS            
SELECT            
    1 AS Tag,            
    NULL AS Parent,            
    T3.PolicyBusinessId AS [Plan!1!PlanId],          
    ISNULL(T3.ProductName,'') as [Plan!1!ProductName],          
    T3.PolicyNumber AS [Plan!1!Number],             
    T5.Name AS [Plan!1!Status],             
    T8.RefPlanTypeId as [Plan!1!RefPlanTypeId],            
    T8.PlanTypeName AS [Plan!1!Name],              
    T10.CorporateName AS [Plan!1!Provider],             
    T3.PolicyBusinessId AS [Plan!1!PolicyBusinessId],             
    T1.PolicyDetailId AS [Plan!1!PolicyDetailId] ,            
    Case When T3.PolicyBusinessId = TPB.PolicyBusinessId Then 0 Else 1 End AS [Plan!1!IsTopUp],            
    ISNULL(T11.ProdSubTypeName,'') AS [Plan!1!ProdSubTypeName],      
    T8.PlanTypeName + ISNULL(' (' + T11.ProdSubTypeName + ')','') AS [Plan!1!PlanTypeFullName],    
    T4.ChangedToDate AS [Plan!1!ChangedToDate],            
    Case When ISNULL(T6.SchemeOwnerCRMContactId,0) = 0 Then 0 Else 1 End [Plan!1!IsScheme],            
    Case When Adt.IntelligentOfficeAdviceType='Pre-Existing' Then 1 Else 0 End [Plan!1!ExistingPolicy],            
    T3.SequentialRef AS [Plan!1!SequentialRef],            
    T13.FirstName + ' ' + T13.LastName AS [Plan!1!AdviserFullName],            
    CASE WHEN ISNULL(CI.Amount,0) = 0 THEN 0 ELSE 1 END [Plan!1!CICFg],            
    convert(decimal(16,2), ISNULL(CI.Amount,0)) AS [Plan!1!CICAmount],            
    ISNULL(CI.Term,0) AS [Plan!1!CICTerm],            
    convert(decimal(16,2), ISNULL(ben.PHIAmount,0)) AS [Plan!1!PHIAmount],            
    ISNULL(ben.PHITerm,0) AS [Plan!1!PHITerm],            
    ISNULL(T3.TotalRegularPremium,0) AS [Plan!1!PremiumAmount],            
    ISNULL(T3.PremiumType,'') AS [Plan!1!PremiumFrequency],            
    ISNULL(ben.LifeCoverTerm, 0) AS [Plan!1!LifeCoverTerm],            
    convert(decimal(16,2), ISNULL(ben.LifeCoverAmount, 0)) AS [Plan!1!LifeCoverAmount],            
    NULL AS [Plan!1!WaiverDeferredFg],            
    ISNULL(ben.BenefitDeferredPeriod,'') AS [Plan!1!WaiverDeferredPeriod],            
    ISNULL(T1.TermYears,0) AS [Plan!1!TermYears],           
    ISNULL(m.MortgageTermMonths,0) AS [Plan!1!TermMonths],           
    ISNULL(tpv.PlanValue,0) AS [Plan!1!PlanValue],          
    ISNULL(convert(varchar(10),tpv.PlanValueDate,103),'')  as [Plan!1!PlanValueDate], 
    ISNULL(dbo.FnRetrievePlanOwnerListForAuthor(t3.PolicyBusinessId),'') as [Plan!1!PlanOwners],         
    ISNULL(dbo.FnRetrieveLifeAssuredListForAuthor(t3.PolicyBusinessId),'') as [Plan!1!LivesAssured],   
    NULL as [Fund!2!PolicyFundId],            
    NULL as [Fund!2!FundName],          
    NULL as [Fund!2!CategoryName],          
    NULL as [Fund!2!CurrentUnitQuantity],          
    NULL as [Fund!2!CurrentPrice],          
    NULL as [Fund!2!Value],          
    NULL as [Fund!2!LastPriceChangeDate]  ,          
    NULL as [Contribution!3!PolicyMoneyInId],          
    NULL as [Contribution!3!Amount],          
    NULL as [Contribution!3!FrequencyName],          
    NULL as [Contribution!3!RefContributionTypeName],          
    NULL as [Contribution!3!RefContributorTypeName],          
    NULL as [Contribution!3!StartDate],          
    NULL as [Contribution!3!StopDate]  ,          
    NULL as [Withdrawal!4!PolicyMoneyOutId],          
    NULL as [Withdrawal!4!Amount],          
    NULL as [Withdrawal!4!FrequencyName],          
    NULL as [Withdrawal!4!StartDate],          
    NULL as [Withdrawal!4!StopDate],          
    NULL as [Withdrawal!4!WithdrawalType],          
    
    NULL as [FundProposal!5!FundProposalId],
    NULL as [FundProposal!5!FundName],
    NULL as [FundProposal!5!Percentage]
    
             
  FROM TPolicyDetail T1             
  INNER JOIN TPolicyOwner T2 ON T1.PolicyDetailId = T2.PolicyDetailId AND T2.CRMContactId in (@CRMContactId1, @CRMContactId2)            
  INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId             
  INNER JOIN [CRM]..TPractitioner  T12 ON T12.PractitionerId = T3.PractitionerId            
  INNER JOIN [CRM]..TCRMContact T13 ON T13.CRMContactId = T12.CRMContactId            
  INNER JOIN TAdviceType AdT on T3.AdviceTypeId=AdT.AdviceTypeId            
  INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1            
  INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'            
  INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId             
  INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId             
  LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId            
  INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId             
  INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId             
  INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId            
  INNER JOIN (          
 SELECT PolicyDetailId,            
 Min(PolicyBusinessId) AS PolicyBusinessId             
 From TPolicyBusiness             
 Group By PolicyDetailId          
  ) AS TPB    ON TPB.PolicyDetailId = T1.PolicyDetailId             
  LEFT JOIN(            
       SELECT PMO.PolicyBusinessId,PMO.Amount,RF.FrequencyName            
       FROM  TPolicyMoneyIn  PMO   INNER JOIN TRefFrequency RF            
       ON PMO.RefFrequencyId=RF.RefFrequencyId) PMO            
  ON T3.PolicyBusinessId=PMO.PolicyBusinessId            
  LEFT JOIN            
 (   
 select PB.PolicyBusinessId, P.ProtectionId AS ProtectionId, P.CriticalIllnessSumAssured As Amount, P.CriticalIllnessTermValue As Term  
 from TPolicyBusiness PB  
 Inner Join TPolicyOwner PO On PB.PolicyDetailId = PO.PolicyDetailId  
 Inner Join TProtection P On P.PolicyBusinessId = PB.PolicyBusinessId  
 WHERE PO.CRMContactId in (@CRMContactId1, @CRMContactId2)  
    
 ) CI    ON T3.PolicyBusinessId=CI.PolicyBusinessId            

  LEFT JOIN                
 (       
	select   
  		PB.PolicyBusinessId,   
  		B.BenefitId,   
		P.LifeCoverSumAssured As LifeCoverAmount, 
  		Case   
			When P.LifeCoverSumAssured Is Null Then Null 
			Else p.TermValue 
		End As LifeCoverTerm,    
		B.BenefitAmount As PHIAmount, 
		Case   
			When B.BenefitAmount Is Null Then Null 
			Else p.TermValue 
		End As PHITerm,  
		b.BenefitDeferredPeriod    
        
	from TPolicyBusiness PB      
	Inner Join TPolicyOwner PO On PB.PolicyDetailId = PO.PolicyDetailId      
	Inner Join TProtection P On P.PolicyBusinessId = PB.PolicyBusinessId      
	JOIN (select ProtectionId, min(AssuredLifeId) as LifeAssured1 FROM TAssuredLife GROUP BY ProtectionId) firstLife on firstLife.ProtectionId = p.ProtectionId
	Inner Join TAssuredLife AL On al.AssuredLifeId = firstLife.LifeAssured1
	Inner Join TBenefit B on B.BenefitId = AL.BenefitId        
	WHERE PO.CRMContactId in (@CRMContactId1, @CRMContactId2)         
  ) ben    ON T3.PolicyBusinessId=ben.PolicyBusinessId 
        
  LEFT JOIN           
 (          
 SELECT max(PlanValuationId) as PlanValuationId, PolicyBusinessId          
 FROM TPlanValuation          
 GROUP BY PolicyBusinessId          
 ) maxVal ON maxVal.PolicyBusinessId = t3.PolicyBusinessId          
  LEFT JOIN TPlanValuation tpv ON tpv.PlanValuationId = maxVal.PlanValuationId          

 LEFT JOIN PolicyManagement..TMortgage M ON M.PolicyBusinessId = T3.PolicyBusinessId

          
 UNION            
            
            
SELECT            
    2 AS Tag,            
    1 AS Parent,            
    T3.PolicyBusinessId AS [Plan!1!PlanId],            
    NULL,        
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,        
    NULL,     
    NULL,             
    NULL,             
    NULL,
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,            
    NULL,     
    NULL,             
    NULL,             
    NULL,             
    TPF.PolicyBusinessFundId,            
    TPF.FundName,          
    TPF.CategoryName,          
    isnull(TPF.CurrentUnitQuantity,0),          
    isnull(TPF.CurrentPrice,0),          
    isnull(TPF.CurrentUnitQuantity,0.0) * isnull(TPF.CurrentPrice,0.0),          
    isnull(convert(varchar(10),TPF.LastPriceChangeDate,103),''),          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null ,          
    null,          
    null,          
    null            
            
  FROM TPolicyDetail T1             
  INNER JOIN TPolicyOwner T2 ON T1.PolicyDetailId = T2.PolicyDetailId AND T2.CRMContactId in (@CRMContactId1, @CRMContactId2)            
  INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId             
            
  INNER JOIN TPolicyBusinessFund TPF ON T3.PolicyBusinessId = TPF.PolicyBusinessId            
            
  INNER JOIN [CRM]..TPractitioner  T12 ON T12.PractitionerId = T3.PractitionerId            
  INNER JOIN [CRM]..TCRMContact T13 ON T13.CRMContactId = T12.CRMContactId            
  INNER JOIN TAdviceType AdT on T3.AdviceTypeId=AdT.AdviceTypeId            
  INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1            
  INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'            
  INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId             
  INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId             
  LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId            
  INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId             
  INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId             
  INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId            
  INNER JOIN (SELECT PolicyDetailId,            
 Min(PolicyBusinessId) AS PolicyBusinessId             
       From TPolicyBusiness             
       Group By PolicyDetailId) AS TPB             
  ON TPB.PolicyDetailId = T1.PolicyDetailId             
              
  UNION          
          
SELECT            
    3 AS Tag,            
    1 AS Parent,            
    T3.PolicyBusinessId AS [Plan!1!PlanId],            
    NULL,             
    NULL,             
    NULL,             
    NULL,             
 NULL,        
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,            
    NULL,     
    NULL,             
    NULL,             
    NULL,          
    NULL,   
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    null,            
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    tpmi.PolicyMoneyInId,          
    isnull(tpmi.Amount,0),          
    isnull(trf.FrequencyName,''),          
    isnull(rcnt.RefContributionTypeName,''),          
    isnull(rcrt.RefContributorTypeName,''),          
    isnull(convert(varchar(10),tpmi.StartDate,103),''),          
    isnull(convert(varchar(10),tpmi.StopDate,103),''),          
    null,          
    null,          
    null,          
    null,          
    null,          
    null ,          
    null,          
    null,          
    null            
           
            
  FROM TPolicyDetail T1             
  INNER JOIN TPolicyOwner T2 ON T1.PolicyDetailId = T2.PolicyDetailId AND T2.CRMContactId in (@CRMContactId1, @CRMContactId2)            
  INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId             
            
  INNER JOIN TPolicyMoneyIn tpmi ON T3.PolicyBusinessId = tpmi.PolicyBusinessId            
  JOIN TRefFrequency trf ON trf.RefFrequencyId = tpmi.RefFrequencyId          
  JOIN TRefContributionType rcnt ON rcnt.RefContributionTypeId = tpmi.RefContributionTypeId          
  JOIN TRefContributorType rcrt ON rcrt.RefContributorTypeId = tpmi.RefContributorTypeId          
          
  INNER JOIN [CRM]..TPractitioner  T12 ON T12.PractitionerId = T3.PractitionerId            
  INNER JOIN [CRM]..TCRMContact T13 ON T13.CRMContactId = T12.CRMContactId            
  INNER JOIN TAdviceType AdT on T3.AdviceTypeId=AdT.AdviceTypeId            
  INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1            
  INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'            
  INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId             
  INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId             
  LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId            
  INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId             
  INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId             
  INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId            
  INNER JOIN (SELECT PolicyDetailId,            
 Min(PolicyBusinessId) AS PolicyBusinessId             
       From TPolicyBusiness             
       Group By PolicyDetailId) AS TPB             
  ON TPB.PolicyDetailId = T1.PolicyDetailId            
          
           
  UNION          
          
SELECT            
    4 AS Tag,            
    1 AS Parent,            
    T3.PolicyBusinessId AS [Plan!1!PlanId],            
    NULL,             
    NULL,             
    NULL,        
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,
    NULL,             
    NULL,            
    NULL,     
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,
    NULL,             
    NULL,             
    NULL,         
    NULL,             
    null,            
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    tpmo.PolicyMoneyOutId,          
    isnull(tpmo.Amount,0),          
    trf.FrequencyName,          
    isnull(convert(varchar(10),tpmo.PaymentStartDate, 103),''),          
    isnull(convert(varchar(10),tpmo.PaymentStopDate, 103),''),          
    rcnt.WithdrawalName ,          
    null,          
    null,          
    null            
              
           
            
  FROM TPolicyDetail T1             
  INNER JOIN TPolicyOwner T2 ON T1.PolicyDetailId = T2.PolicyDetailId AND T2.CRMContactId in (@CRMContactId1, @CRMContactId2)            
  INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId             
            
  INNER JOIN TPolicyMoneyOut tpmo ON T3.PolicyBusinessId = tpmo.PolicyBusinessId            
  JOIN TRefFrequency trf ON trf.RefFrequencyId = tpmo.RefFrequencyId          
  JOIN TRefWithdrawalType rcnt ON rcnt.RefWithdrawalTypeId = tpmo.RefWithdrawalTypeId          
          
          
  INNER JOIN [CRM]..TPractitioner  T12 ON T12.PractitionerId = T3.PractitionerId            
  INNER JOIN [CRM]..TCRMContact T13 ON T13.CRMContactId = T12.CRMContactId            
  INNER JOIN TAdviceType AdT on T3.AdviceTypeId=AdT.AdviceTypeId            
  INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1            
  INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'            
  INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId             
  INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId             
  LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId            
  INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId             
  INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId             
  INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId            
  INNER JOIN (SELECT PolicyDetailId,            
 Min(PolicyBusinessId) AS PolicyBusinessId             
       From TPolicyBusiness             
       Group By PolicyDetailId) AS TPB             
  ON TPB.PolicyDetailId = T1.PolicyDetailId            
   
   UNION
   
   SELECT            
    5 AS Tag,            
    1 AS Parent,            
    T3.PolicyBusinessId AS [Plan!1!PlanId],            
    NULL,             
    NULL,             
    NULL,        
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,
    NULL,             
    NULL,            
    NULL,     
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,             
    NULL,         
    NULL,             
    NULL,             
    null,            
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,          
    null,
    null,
    null,
    null,
    null,
    null,
    fp.FundProposalId,
    case when fp.IsFromSeed = 1 then f.UnitLongName else nff.FundName end,          
    cast(fp.Percentage as money)
              
           
            
  FROM TPolicyDetail T1             
  INNER JOIN TPolicyOwner T2 ON T1.PolicyDetailId = T2.PolicyDetailId AND T2.CRMContactId in (@CRMContactId1, @CRMContactId2)            
  INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId             
  INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1            
  INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'            
  INNER JOIN (SELECT PolicyDetailId,            
 Min(PolicyBusinessId) AS PolicyBusinessId             
       From TPolicyBusiness             
       Group By PolicyDetailId) AS TPB             
  ON TPB.PolicyDetailId = T1.PolicyDetailId            
  JOIN TFundProposal fp on fp.PolicyBusinessId = TPB.PolicyBusinessId
  LEFT JOIN Fund2..TFundUnit f on f.FundUnitId = fp.FundUnitId AND fp.IsFromSeed = 1
  LEFT JOIN TNonFeedFund nff ON nff.NonFeedFundId = fp.FundUnitId AND fp.IsFromSeed = 0
          
  ORDER BY [Plan!1!PlanId],[Fund!2!PolicyFundId], [Contribution!3!PolicyMoneyInId], [Withdrawal!4!PolicyMoneyOutId], [FundProposal!5!FundProposalId]
            
  FOR XML EXPLICIT   

GO
