SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VwPlanTypeAndProvider] 
AS


Select A.IndigoClientId, A.PolicyBusinessId, A.PolicyDetailId, 
	ISNULL(F.CorporateName, '') as ProviderName, 
	Case  
		When (T11.ProdSubTypeName) Is Not Null 
		Then  ISNULL(T8.PlanTypeName, '') + '  (' + ISNULL(T11.ProdSubTypeName, '')  + ')'  
		Else  ISNULL(T8.PlanTypeName, '')   
	End as PlanType 
 from TPolicyBusiness A
-- Plan type
INNER JOIN TPolicyDetail pd  on A.IndigoClientId = pd.IndigoClientId and A.PolicyDetailId = pd.PolicyDetailId
INNER JOIN TPlanDescription pdesc  ON pd.PlanDescriptionId = pdesc.PlanDescriptionId
INNER JOIN TRefPlanType2ProdSubType T7  ON pdesc.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId 
LEFT JOIN TProdSubType T11  ON T7.ProdSubTypeId=T11.ProdSubTypeId
INNER JOIN TRefPlanType T8  ON T7.RefPlanTypeId = T8.RefPlanTypeId 

-- Provider 	
INNER JOIN TRefProdProvider E ON pdesc.RefProdProviderId = E.RefProdProviderId
INNER JOIN CRM..TCRMContact F ON E.CRMContactId = F.CRMContactId