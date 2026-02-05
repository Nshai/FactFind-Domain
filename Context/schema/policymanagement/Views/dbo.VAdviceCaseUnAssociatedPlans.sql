SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VAdviceCaseUnAssociatedPlans]  
As  
  
SELECT  
 ACP.AdviceCasePlanId,   
 ACP.AdviceCaseId,   
 Owners.OwnerId1 AS Owner1PartyId,   
 Owners.OwnerId2 AS Owner2PartyId,  
 PolicyManagement.dbo.FnRetrievePlanOwnerList(T2.PolicyDetailId,T2.PolicyBusinessId) AS OwnerList,   
 T2.PolicyBusinessId,   
 T2.SequentialRef,   
 T6.CorporateName AS ProviderName,   
 T9.PlanTypeName AS PlanType,   
 Case When IsNull(pst.ProdSubTypeName,'') = ''   
  Then T9.PlanTypeName   
  Else T9.PlanTypeName + ' (' + pst.ProdSubTypeName + ')'  
 End  
 AS PlanTypeIncludingProductSubType,  
 ISNULL(T2.PolicyNumber, '') AS PlanNumber,   
 TS.Name AS Status,   
 CASE T10.IntelligentOfficeAdviceType WHEN 'Pre-Existing' THEN 1 ELSE 0 END AS IsPreExisting,   
   
 AO.OwnerId3 AS Owner3PartyId,  
 AO.OwnerId4 AS Owner4PartyId  
FROM  
 policymanagement.dbo.TPolicyBusiness AS T2   
   
 INNER JOIN  
 (  
     SELECT   
   MIN(CRMContactId) AS OwnerId1,  
   Case   
    When MAX(CRMContactId) = MIN(CRMContactId) Then Null  
    Else MAX(CRMContactId)  
   End AS OwnerId2,  
   PolicyDetailId  
  FROM  
   policymanagement..tpolicyowner  
  GROUP BY  
   PolicyDetailId  
 ) Owners ON Owners.PolicyDetailId = T2.PolicyDetailId  
  
 LEFT JOIN   
 (  
     SELECT   
   MIN(CRMContactId) AS OwnerId3,  
   Case   
    When MAX(CRMContactId) = MIN(CRMContactId) Then Null  
    Else MAX(CRMContactId)  
   End AS OwnerId4,  
   PolicyBusinessId  
  FROM  
   policymanagement..TAdditionalOwner  
  GROUP BY  
   PolicyBusinessId  
 ) AO On AO.PolicyBusinessId = T2.PolicyBusinessId   
  
 INNER JOIN policymanagement.dbo.TPolicyDetail AS T3 ON T2.PolicyDetailId = T3.PolicyDetailId   
 INNER JOIN policymanagement.dbo.TPlanDescription AS T4 ON T3.PlanDescriptionId = T4.PlanDescriptionId   
 INNER JOIN policymanagement.dbo.TRefProdProvider AS T5 ON T4.RefProdProviderId = T5.RefProdProviderId   
 INNER JOIN crm.dbo.TCRMContact AS T6 ON T5.CRMContactId = T6.CRMContactId   
 INNER JOIN policymanagement.dbo.TStatusHistory AS T7 ON T2.PolicyBusinessId = T7.PolicyBusinessId AND T7.CurrentStatusFG = 1   
 INNER JOIN policymanagement.dbo.TStatus AS TS ON T7.StatusId = TS.StatusId   
 INNER JOIN policymanagement.dbo.TRefPlanType2ProdSubType AS T8 ON T4.RefPlanType2ProdSubTypeId = T8.RefPlanType2ProdSubTypeId   
 INNER JOIN policymanagement.dbo.TRefPlanType AS T9 ON T8.RefPlanTypeId = T9.RefPlanTypeId   
 LEFT JOIN policymanagement.dbo.TProdSubType AS pst ON pst.ProdSubTypeId = T8.ProdSubTypeId  
 INNER JOIN policymanagement.dbo.TAdviceType AS T10 ON T2.AdviceTypeId = T10.AdviceTypeId   
 LEFT OUTER JOIN crm.dbo.TAdviceCasePlan AS ACP ON T2.PolicyBusinessId = ACP.PolicyBusinessId  
  
GO
