USE [policymanagement]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Drop the existing view if it exists
IF EXISTS (SELECT * FROM policymanagement.sys.views WHERE name = 'VAdviceCaseAssociatedPlans')
BEGIN
    DROP VIEW VAdviceCaseAssociatedPlans;
END
GO


CREATE VIEW [dbo].[VAdviceCaseAssociatedPlans]  
AS  

SELECT
	T1.AdviceCasePlanId  
    , T1.AdviceCaseId  
    , T2.PolicyBusinessId  
    , T2.IndigoClientId AS TenantId  
    , T2.SequentialRef  
	, T5.RefProdProviderId As ProviderId
    , T6.CorporateName AS ProviderName  
    , T9.PlanTypeName AS PlanType  
    , Case When IsNull(pst.ProdSubTypeName,'') = ''   
		Then T9.PlanTypeName   
		Else T9.PlanTypeName + ' (' + pst.ProdSubTypeName + ')'  
	  End AS PlanTypeIncludingProductSubType  
    , ISNULL(T2.PolicyNumber, '') AS PlanNumber  
    , TS.Name AS [Status]  
    , T7.DateOfChange As StatusChangeDate  
    , T8.RefPlanTypeId  
    , CASE T10.IntelligentOfficeAdviceType   
		WHEN 'Pre-Existing'   
        THEN 1   
        ELSE 0   
	   END AS IsPreExisting    
	, T2.PolicyStartDate AS StartDate 
	, owner.OwnerId1 AS Owner1PartyId
	, owner.OwnerId2 AS Owner2PartyId
      
  
FROM
	CRM.dbo.TAdviceCasePlan AS T1 INNER JOIN    
	PolicyManagement.dbo.TPolicyBusiness AS T2 ON T1.PolicyBusinessId = T2.PolicyBusinessId INNER JOIN    
	PolicyManagement.dbo.TPolicyDetail AS T3 ON T2.PolicyDetailId = T3.PolicyDetailId INNER JOIN    
	PolicyManagement.dbo.TPlanDescription AS T4 ON T3.PlanDescriptionId = T4.PlanDescriptionId INNER JOIN    
	PolicyManagement.dbo.TRefProdProvider AS T5 ON T4.RefProdProviderId = T5.RefProdProviderId INNER JOIN    
	crm.dbo.TCRMContact AS T6 ON T5.CRMContactId = T6.CRMContactId INNER JOIN    
	PolicyManagement.dbo.TStatusHistory AS T7 ON T2.PolicyBusinessId = T7.PolicyBusinessId AND T7.CurrentStatusFG = 1 INNER JOIN    
	PolicyManagement.dbo.TStatus AS TS ON T7.StatusId = TS.StatusId INNER JOIN    
	PolicyManagement.dbo.TRefPlanType2ProdSubType AS T8 ON T4.RefPlanType2ProdSubTypeId = T8.RefPlanType2ProdSubTypeId INNER JOIN    
	PolicyManagement.dbo.TRefPlanType AS T9 ON T8.RefPlanTypeId = T9.RefPlanTypeId INNER JOIN    
	PolicyManagement.dbo.TAdviceType AS T10 ON T2.AdviceTypeId = T10.AdviceTypeId    
	LEFT JOIN Policymanagement.dbo.TProdSubType AS pst ON pst.ProdSubTypeId = T8.ProdSubTypeId  
	INNER JOIN 
	(
		Select
			Min(PO.CRMContactId) AS OwnerId1,
			Case
				When Max(PO.CRMContactId) = Min(PO.CRMContactId) Then Null
				Else Max(PO.CRMContactId)
			End AS OwnerId2,
			PB.PolicyBusinessId AS PolicyBusinessId
		From
			Policymanagement..TPolicyOwner PO With(Nolock)
			Inner Join Policymanagement..TPolicyBusiness PB With(Nolock) ON PO.PolicyDetailId = PB.PolicyDetailId
		Group
			By PO.PolicyDetailId, PB.PolicyBusinessId
	) As owner on owner.PolicyBusinessId = t1.PolicyBusinessId
  
GO
