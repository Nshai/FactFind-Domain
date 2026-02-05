SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomRetrievePlansForCRMContact]    
   @CRMContactId bigint,    
   @NotOnRiskFG bit =0,    
   @IsPdfOutput bit=0,    
   @IsWrapFG bit=0,
   @IsSippFG bit=0
  
AS    

SELECT distinct   
    1 AS Tag,    
    NULL AS Parent,    
    REPLICATE ('0' , 20-len(100000000000 - T3.PolicyBusinessId )) + convert(varchar(20), 100000000000 - T3.PolicyBusinessId) AS [Plan!1!SortId], --used to sort the data    
    T3.PolicyBusinessId AS [Plan!1!PlanId],    
    T3.PolicyNumber AS [Plan!1!Number],     
 T3.PractitionerId AS [Plan!1!SellingPractitionerId],     
    T5.Name AS [Plan!1!Status],     
    T8.RefPlanTypeId as [Plan!1!RefPlanTypeId],    
    T8.PlanTypeName + ISNULL(' (' + T11.ProdSubTypeName + ')','') AS [Plan!1!PlanTypeName],    
 T8.IsWrapperFg AS [Plan!1!IsWrapperFg],     
 ISNULL(wrapProv.WrapAllowOtherProvidersFg, 0)  AS [Plan!1!WrapAllowOtherProvidersFg],      
 ISNULL(wrapProv.SippAllowOtherProvidersFg, 0)  AS [Plan!1!SippAllowOtherProvidersFg],      
 case when T8.PlanTypeName = 'wrap' and T8.IsWrapperFg = 1     
  then 1    
  else 0    
 end as [Plan!1!IsWrapWrapper],     
 case when T8.PlanTypeName <> 'wrap' and T8.IsWrapperFg = 1     
  then 1    
  else 0    
 end as [Plan!1!IsNonWrapWrapper],    
 T8.AdditionalOwnersFg AS [Plan!1!AdditionalOwnersFg],     
    T9.RefProdProviderId AS [Plan!1!ProviderId],    
    T10.CorporateName AS [Plan!1!ProviderName],     
    T3.PolicyBusinessId AS [Plan!1!PolicyBusinessId],     
    T1.PolicyDetailId AS [Plan!1!PolicyDetailId] ,    
    Case When T3.PolicyBusinessId = TPB.PolicyBusinessId Then 0 Else 1 End AS [Plan!1!IsTopUp],    
    ISNULL(T11.ProdSubTypeName,'') AS [Plan!1!ProdSubTypeName],    
    T4.ChangedToDate AS [Plan!1!ChangedToDate],    
    Case When ISNULL(T6.SchemeOwnerCRMContactId,0) = 0 Then 0 Else 1 End [Plan!1!IsScheme],    
    Case When Adt.IntelligentOfficeAdviceType='Pre-Existing' Then 1 Else 0 End [Plan!1!ExistingPolicy],       
    T3.SequentialRef AS [Plan!1!SequentialRef],    
    ISNULL(wrapolbus.SequentialRef, '') AS [Plan!1!LinkedToSequentialRef],    
    ISNULL(wrapolbus.PolicyBusinessId, '0') AS [Plan!1!LinkedToPolicyBusinessId],     
    T13.FirstName + ' ' + T13.LastName AS [Plan!1!AdviserFullName],    
    CASE    
 WHEN (ISNULL(T3.PolicyNumber,'0') = '0' OR T3.PolicyNumber = NULL OR T3.PolicyNumber = ' ' ) AND @IsPdfOutput=0     
  THEN ISNULL(T3.SequentialRef,'') + ': ' + ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'')    
 WHEN (ISNULL(T3.PolicyNumber,'0') = '0' OR T3.PolicyNumber = NULL OR T3.PolicyNumber = ' ' ) AND @IsPdfOutput=1    
  THEN ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'')    
 WHEN ISNULL(T3.PolicyNumber,'0') <> '0' AND T3.PolicyNumber IS NOT NULL AND @IsPdfOutput=0    
  THEN ISNULL(T3.SequentialRef,'') + ' : ' + ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'') + ' (' + T3.PolicyNumber + ')'    
 WHEN ISNULL(T3.PolicyNumber,'0') <> '0' AND T3.PolicyNumber IS NOT NULL AND @IsPdfOutput=1    
  THEN ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'') + ' (' + T3.PolicyNumber + ')'    
    END AS [Plan!1!LongName]    
    
  FROM TPolicyOwner T2    
  INNER JOIN TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId     
  INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId     
--  LEFT JOIN TPolicyExpectedCommission T14 ON T3.PolicyBusinessId = T14.PolicyBusinessId AND T14.ExpectedCommissionType = 0 --CommissionType 0 = Inital Commission    
  INNER JOIN [CRM]..TPractitioner  T12 ON T12.PractitionerId = T3.PractitionerId    
  INNER JOIN [CRM]..TCRMContact T13 ON T13.CRMContactId = T12.CRMContactId    
-- is this a pre-xeisting plan defect #2562    
  INNER JOIN TAdviceType AdT on T3.AdviceTypeId=AdT.AdviceTypeId    
  INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1    
  INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'    
  INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId     
  INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId     
  LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId    
  INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId     
  INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId     
  LEFT JOIN TWrapperProvider wrapProv ON T6.RefProdProviderId = wrapProv.RefProdProviderId  
		--added for sipp
		and wrapProv.RefPlanTypeId = t8.RefPlanTypeId 
  INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId    
  INNER JOIN (SELECT A.PolicyDetailId,    
 Min(PolicyBusinessId) AS PolicyBusinessId     
       From TPolicyBusiness A    
 JOIN TPolicyDetail B ON A.PolicyDetailId=B.PolicyDetailId    
 JOIN TPolicyOwner C ON B.PolicyDetailId=C.PolicyDetailId
 WHERE C.CRMContactId=@CRMContactId
       Group By A.PolicyDetailId) AS TPB     
  ON TPB.PolicyDetailId = T1.PolicyDetailId
  LEFT JOIN TWrapperPolicyBusiness wrapPol ON T3.PolicyBusinessId = wrapPol.PolicyBusinessId    
  LEFT JOIN TPolicyBusiness wrapolbus ON wrapPol.ParentPolicyBusinessId = wrapolbus.PolicyBusinessId    
  WHERE T2.CRMContactId=@CRMContactId AND @CRMContactId>0     
 and ((@IsWrapFg = 0) or (@IsWrapFg = 1 and T8.PlanTypeName = 'wrap'))
 and ((@IsSippFg = 0) or (@IsSippFg = 1 and T8.PlanTypeName = 'sipp'))
     
--SP - Added to pull back plans for Additional Owners (SIPP Enhancement)
	union

SELECT distinct   
    1 AS Tag,    
    NULL AS Parent,    
    REPLICATE ('0' , 20-len(100000000000 - T3.PolicyBusinessId )) + convert(varchar(20), 100000000000 - T3.PolicyBusinessId) AS [Plan!1!SortId], --used to sort the data    
    T3.PolicyBusinessId AS [Plan!1!PlanId],    
    T3.PolicyNumber AS [Plan!1!Number],     
 T3.PractitionerId AS [Plan!1!SellingPractitionerId],     
    T5.Name AS [Plan!1!Status],     
    T8.RefPlanTypeId as [Plan!1!RefPlanTypeId],    
    T8.PlanTypeName AS [Plan!1!PlanTypeName],     
 T8.IsWrapperFg AS [Plan!1!IsWrapperFg],     
 ISNULL(wrapProv.WrapAllowOtherProvidersFg, 0)  AS [Plan!1!WrapAllowOtherProvidersFg],      
 ISNULL(wrapProv.SippAllowOtherProvidersFg, 0)  AS [Plan!1!SippAllowOtherProvidersFg],      
 case when T8.PlanTypeName = 'wrap' and T8.IsWrapperFg = 1     
  then 1    
  else 0    
 end as [Plan!1!IsWrapWrapper],     
 case when T8.PlanTypeName <> 'wrap' and T8.IsWrapperFg = 1     
  then 1    
  else 0    
 end as [Plan!1!IsNonWrapWrapper],    
 T8.AdditionalOwnersFg AS [Plan!1!AdditionalOwnersFg],     
    T9.RefProdProviderId AS [Plan!1!ProviderId],    
    T10.CorporateName AS [Plan!1!ProviderName],     
    T3.PolicyBusinessId AS [Plan!1!PolicyBusinessId],     
    T1.PolicyDetailId AS [Plan!1!PolicyDetailId] ,    
    Case When T3.PolicyBusinessId = TPB.PolicyBusinessId Then 0 Else 1 End AS [Plan!1!IsTopUp],    
    ISNULL(T11.ProdSubTypeName,'') AS [Plan!1!ProdSubTypeName],    
    T4.ChangedToDate AS [Plan!1!ChangedToDate],    
    Case When ISNULL(T6.SchemeOwnerCRMContactId,0) = 0 Then 0 Else 1 End [Plan!1!IsScheme],    
    Case When Adt.IntelligentOfficeAdviceType='Pre-Existing' Then 1 Else 0 End [Plan!1!ExistingPolicy],       
    T3.SequentialRef AS [Plan!1!SequentialRef],    
    ISNULL(wrapolbus.SequentialRef, '') AS [Plan!1!LinkedToSequentialRef],    
    ISNULL(wrapolbus.PolicyBusinessId, '0') AS [Plan!1!LinkedToPolicyBusinessId],     
    T13.FirstName + ' ' + T13.LastName AS [Plan!1!AdviserFullName],    
    CASE    
 WHEN (ISNULL(T3.PolicyNumber,'0') = '0' OR T3.PolicyNumber = NULL OR T3.PolicyNumber = ' ' ) AND @IsPdfOutput=0     
  THEN ISNULL(T3.SequentialRef,'') + ': ' + ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'')    
 WHEN (ISNULL(T3.PolicyNumber,'0') = '0' OR T3.PolicyNumber = NULL OR T3.PolicyNumber = ' ' ) AND @IsPdfOutput=1    
  THEN ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'')    
 WHEN ISNULL(T3.PolicyNumber,'0') <> '0' AND T3.PolicyNumber IS NOT NULL AND @IsPdfOutput=0    
  THEN ISNULL(T3.SequentialRef,'') + ' : ' + ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'') + ' (' + T3.PolicyNumber + ')'    
 WHEN ISNULL(T3.PolicyNumber,'0') <> '0' AND T3.PolicyNumber IS NOT NULL AND @IsPdfOutput=1    
  THEN ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'') + ' (' + T3.PolicyNumber + ')'    
    END AS [Plan!1!LongName]        
  FROM TAdditionalOwner T99 
  Inner join TPolicyBusiness T2 on T2.PolicyBusinessId  = T99.PolicyBusinessId
  INNER JOIN TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId     
  INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId     
--  LEFT JOIN TPolicyExpectedCommission T14 ON T3.PolicyBusinessId = T14.PolicyBusinessId AND T14.ExpectedCommissionType = 0 --CommissionType 0 = Inital Commission    
  INNER JOIN [CRM]..TPractitioner  T12 ON T12.PractitionerId = T3.PractitionerId    
  INNER JOIN [CRM]..TCRMContact T13 ON T13.CRMContactId = T12.CRMContactId    
-- is this a pre-xeisting plan defect #2562    
  INNER JOIN TAdviceType AdT on T3.AdviceTypeId=AdT.AdviceTypeId    
  INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1    
  INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'    
  INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId     
  INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId     
  LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId    
  INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId     
  INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId     
  LEFT JOIN TWrapperProvider wrapProv ON T6.RefProdProviderId = wrapProv.RefProdProviderId    
	--added for sipp
	and wrapProv.RefPlanTypeId = t8.RefPlanTypeId 
  INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId    
  INNER JOIN (SELECT A.PolicyDetailId,    
 Min(A.PolicyBusinessId) AS PolicyBusinessId     
FROM TAdditionalOwner T99 
Inner join TPolicyBusiness A on A.PolicyBusinessId  = T99.PolicyBusinessId
JOIN TPolicyDetail B ON A.PolicyDetailId=B.PolicyDetailId    
WHERE T99.CRMContactId=@CRMContactId
       Group By A.PolicyDetailId) AS TPB     
  ON TPB.PolicyDetailId = T1.PolicyDetailId
  LEFT JOIN TWrapperPolicyBusiness wrapPol ON T3.PolicyBusinessId = wrapPol.PolicyBusinessId    
  LEFT JOIN TPolicyBusiness wrapolbus ON wrapPol.ParentPolicyBusinessId = wrapolbus.PolicyBusinessId    
  WHERE T99.CRMContactId=@CRMContactId AND @CRMContactId>0     
and ((@IsWrapFg = 0) or (@IsWrapFg = 1 and T8.PlanTypeName = 'wrap'))
 and ((@IsSippFg = 0) or (@IsSippFg = 1 and T8.PlanTypeName = 'sipp'))
     
--SP - Added to pull back plans for Members (SIPP Enhancement)  
union

SELECT distinct   
    1 AS Tag,    
    NULL AS Parent,    
    REPLICATE ('0' , 20-len(100000000000 - T3.PolicyBusinessId )) + convert(varchar(20), 100000000000 - T3.PolicyBusinessId) AS [Plan!1!SortId], --used to sort the data    
    T3.PolicyBusinessId AS [Plan!1!PlanId],    
    T3.PolicyNumber AS [Plan!1!Number],     
 T3.PractitionerId AS [Plan!1!SellingPractitionerId],     
    T5.Name AS [Plan!1!Status],     
    T8.RefPlanTypeId as [Plan!1!RefPlanTypeId],    
    T8.PlanTypeName AS [Plan!1!PlanTypeName],     
 T8.IsWrapperFg AS [Plan!1!IsWrapperFg],     
 ISNULL(wrapProv.WrapAllowOtherProvidersFg, 0)  AS [Plan!1!WrapAllowOtherProvidersFg],      
 ISNULL(wrapProv.SippAllowOtherProvidersFg, 0)  AS [Plan!1!SippAllowOtherProvidersFg],      
 case when T8.PlanTypeName = 'wrap' and T8.IsWrapperFg = 1     
  then 1    
  else 0    
 end as [Plan!1!IsWrapWrapper],     
 case when T8.PlanTypeName <> 'wrap' and T8.IsWrapperFg = 1     
  then 1    
  else 0    
 end as [Plan!1!IsNonWrapWrapper],    
 T8.AdditionalOwnersFg AS [Plan!1!AdditionalOwnersFg],     
    T9.RefProdProviderId AS [Plan!1!ProviderId],    
    T10.CorporateName AS [Plan!1!ProviderName],     
    T3.PolicyBusinessId AS [Plan!1!PolicyBusinessId],     
    T1.PolicyDetailId AS [Plan!1!PolicyDetailId] ,    
    Case When T3.PolicyBusinessId = TPB.PolicyBusinessId Then 0 Else 1 End AS [Plan!1!IsTopUp],    
    ISNULL(T11.ProdSubTypeName,'') AS [Plan!1!ProdSubTypeName],    
    T4.ChangedToDate AS [Plan!1!ChangedToDate],    
    Case When ISNULL(T6.SchemeOwnerCRMContactId,0) = 0 Then 0 Else 1 End [Plan!1!IsScheme],    
    Case When Adt.IntelligentOfficeAdviceType='Pre-Existing' Then 1 Else 0 End [Plan!1!ExistingPolicy],       
    T3.SequentialRef AS [Plan!1!SequentialRef],    
    ISNULL(wrapolbus.SequentialRef, '') AS [Plan!1!LinkedToSequentialRef],    
    ISNULL(wrapolbus.PolicyBusinessId, '0') AS [Plan!1!LinkedToPolicyBusinessId],     
    T13.FirstName + ' ' + T13.LastName AS [Plan!1!AdviserFullName],    
    CASE    
 WHEN (ISNULL(T3.PolicyNumber,'0') = '0' OR T3.PolicyNumber = NULL OR T3.PolicyNumber = ' ' ) AND @IsPdfOutput=0     
  THEN ISNULL(T3.SequentialRef,'') + ': ' + ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'')    
 WHEN (ISNULL(T3.PolicyNumber,'0') = '0' OR T3.PolicyNumber = NULL OR T3.PolicyNumber = ' ' ) AND @IsPdfOutput=1    
  THEN ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'')    
 WHEN ISNULL(T3.PolicyNumber,'0') <> '0' AND T3.PolicyNumber IS NOT NULL AND @IsPdfOutput=0    
  THEN ISNULL(T3.SequentialRef,'') + ' : ' + ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'') + ' (' + T3.PolicyNumber + ')'    
 WHEN ISNULL(T3.PolicyNumber,'0') <> '0' AND T3.PolicyNumber IS NOT NULL AND @IsPdfOutput=1    
  THEN ISNULL(T10.CorporateName,'') + ' - ' + ISNULL(T8.PlanTypeName,'') + ' (' + T3.PolicyNumber + ')'    
    END AS [Plan!1!LongName]        
  FROM TMember T99 
  Inner join TPolicyBusiness T2 on T2.PolicyBusinessId  = T99.PolicyBusinessId
  INNER JOIN TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId     
  INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId     
--  LEFT JOIN TPolicyExpectedCommission T14 ON T3.PolicyBusinessId = T14.PolicyBusinessId AND T14.ExpectedCommissionType = 0 --CommissionType 0 = Inital Commission    
  INNER JOIN [CRM]..TPractitioner  T12 ON T12.PractitionerId = T3.PractitionerId    
  INNER JOIN [CRM]..TCRMContact T13 ON T13.CRMContactId = T12.CRMContactId    
-- is this a pre-xeisting plan defect #2562    
  INNER JOIN TAdviceType AdT on T3.AdviceTypeId=AdT.AdviceTypeId    
  INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1    
  INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'    
  INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId     
  INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId     
  LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId    
  INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId     
  INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId     
  LEFT JOIN TWrapperProvider wrapProv ON T6.RefProdProviderId = wrapProv.RefProdProviderId    
	--added for sipp
	and wrapProv.RefPlanTypeId = t8.RefPlanTypeId 
  INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId    
  INNER JOIN (SELECT A.PolicyDetailId,    
 Min(A.PolicyBusinessId) AS PolicyBusinessId     
FROM TMember T99 
Inner join TPolicyBusiness A on A.PolicyBusinessId  = T99.PolicyBusinessId
JOIN TPolicyDetail B ON A.PolicyDetailId=B.PolicyDetailId    
WHERE T99.CRMContactId=@CRMContactId
       Group By A.PolicyDetailId) AS TPB     
 ON TPB.PolicyDetailId = T1.PolicyDetailId
  LEFT JOIN TWrapperPolicyBusiness wrapPol ON T3.PolicyBusinessId = wrapPol.PolicyBusinessId    
  LEFT JOIN TPolicyBusiness wrapolbus ON wrapPol.ParentPolicyBusinessId = wrapolbus.PolicyBusinessId    
  WHERE T99.CRMContactId=@CRMContactId AND @CRMContactId>0     
and ((@IsWrapFg = 0) or (@IsWrapFg = 1 and T8.PlanTypeName = 'wrap'))
and ((@IsSippFg = 0) or (@IsSippFg = 1 and T8.PlanTypeName = 'sipp'))
  ORDER BY [Plan!1!SortId]    
    
    
  FOR XML EXPLICIT    
GO
