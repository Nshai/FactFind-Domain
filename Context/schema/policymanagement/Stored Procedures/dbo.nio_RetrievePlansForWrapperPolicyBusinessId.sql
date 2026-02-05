SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_RetrievePlansForWrapperPolicyBusinessId]
   @WrapperPolicyBusinessId bigint
AS

-- Exec nio_RetrievePlansForWrapperPolicyBusinessId @WrapperPolicyBusinessId = 0

SELECT

    T3.PolicyBusinessId ,
    T3.PolicyNumber  ,
    T5.Name AS StatusName, 
    T8.RefPlanTypeId as RefPlanTypeId,
     T8.PlanTypeName + ISNULL(' (' + T11.ProdSubTypeName + ')','') AS PlanTypeName, 
	T8.IsWrapperFg AS IsWrapperFg, 	
	case when T8.PlanTypeName = 'wrap' and T8.IsWrapperFg = 1 
		then 1
		else 0
	end as IsWrapWrapper, 
	case when T8.PlanTypeName <> 'wrap' and T8.IsWrapperFg = 1 
		then 1
		else 0
	end as IsNonWrapWrapper,
	T8.AdditionalOwnersFg AS AdditionalOwnersFg, 
    T9.RefProdProviderId AS ProviderId,
    T10.CorporateName AS ProviderName, 
    T3.PolicyDetailId AS PolicyDetailId ,    
    ISNULL(T11.ProdSubTypeName,'') AS ProdSubTypeName,
    Case When Adt.IntelligentOfficeAdviceType='Pre-Existing' Then 1 Else 0 End  ExistingPolicy,
    T3.SequentialRef AS SequentialRef,
	Case When T3.PolicyBusinessId = TPB.PolicyBusinessId Then 0 Else 1 End AS IsTopUp,
	Case When ISNULL(T6.SchemeOwnerCRMContactId,0) = 0 Then 0 Else 1 End IsScheme,
	T13.FirstName + ' ' + T13.LastName AS AdviserFullName 

  FROM TWrapperPolicyBusiness T2  
  INNER JOIN TPolicyBusiness T3 ON T2.PolicyBusinessId = T3.PolicyBusinessId 
	INNER JOIN TPolicyDetail T1 ON T1.PolicyDetailId = T3.PolicyDetailId 
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
  INNER JOIN (SELECT A.PolicyDetailId,Min(A.PolicyBusinessId) AS PolicyBusinessId 
      	From TPolicyBusiness A
	inner JOIN TPolicyDetail B ON A.PolicyDetailId=B.PolicyDetailId
	inner JOIN TPolicyOwner C ON B.PolicyDetailId=C.PolicyDetailId
	inner join TWrapperPolicyBusiness D on D.PolicyBusinessId = A.PolicyBusinessId
	WHERE D.ParentPolicyBusinessId = @WrapperPolicyBusinessId
      	Group By A.PolicyDetailId) AS TPB 
	ON	TPB.PolicyDetailId = T1.PolicyDetailId	
  WHERE T2.ParentPolicyBusinessId = @WrapperPolicyBusinessId


GO
