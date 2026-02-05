SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[nio_SpCustomGetRepaymentVehicles]  
	@PartyId bigint
	-- , @MortgageId bigint = null  
AS  
  
BEGIN    
  SELECT
    T3.PolicyBusinessId AS PolicyBusinessId,   
    IsNull(T3.PolicyNumber,'') AS PolicyNumber,   
    T3.TotalRegularPremium AS TotalRegularPremium,   
    T3.TotalLumpSum AS TotalLumpSum,   
    T3.MaturityDate AS MaturityDate,   
    ISNULL(T6.CorporateName,'') AS ProviderName,   
    ISNULL(T10.PlanTypeName,'') AS PlanTypeName,  
    ISNULL(T12.[Name],'') AS [Status],  
    ISNULL(T6.CorporateName,'') + ' ' + ISNULL(T10.PlanTypeName,'') AS  [PlanDetails]  
	,T14.MortgageId As MortgageId
  FROM TPolicyBusiness T3  
  INNER JOIN TPolicyDetail T2 ON T3.PolicyDetailId = T2.PolicyDetailId  
  INNER JOIN TPolicyOwner T1 ON T2.PolicyDetailId = T1.PolicyDetailId  
  INNER JOIN TPlanDescription T4 ON T2.PlanDescriptionId=T4.PlanDescriptionId  
  INNER JOIN TRefProdProvider T5 ON T4.RefProdProviderId=T5.RefProdProviderId  
  INNER JOIN CRM..TCRMContact T6 ON T5.CRMContactId=T6.CRMContactId     
  INNER JOIN TRefPlanType2ProdSubType T9 ON T4.RefPlanType2ProdSubTypeId=T9.RefPlanType2ProdSubTypeId  
  INNER JOIN TRefPlanType T10 ON T9.RefPlanTypeId=T10.RefPlanTypeId  
  INNER JOIN TStatusHistory T11 ON T3.PolicyBusinessId=T11.PolicyBusinessId  
  INNER JOIN TStatus T12 ON T11.StatusId=T12.StatusId  
  Left Join TRepaymentVehicle T14 ON T3.PolicyBusinessId = T14.PolicyBusinessId
  WHERE 1=1
	And (T1.CRMContactId = @PartyId) 
	And T11.CurrentStatusFG=1 AND T10.PlanTypeName!='Mortgage'
	AND T12.[Name] NOT IN ('NTU','Out of Force','Rejected','G60 sign off','Deleted') 
	-- And (@MortgageId is null or (@MortgageId is not null and T14.MortgageId = @MortgageId))
  
END  
RETURN (0)  
GO
