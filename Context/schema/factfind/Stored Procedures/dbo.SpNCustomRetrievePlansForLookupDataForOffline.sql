SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePlansForLookupDataForOffline]
	@TenantId bigint,
	@CRMContactId bigint = 0,    
	@CRMContactId2 bigint = 0
AS    

select 
		1 as tag,
		null as parent,
		null as [Plans!1!],
		null as [Plan!2!id],		
		null as [Plan!2!description],
		null as [Plan!2!typeid]
union all

select 
		2 as Tag ,
		1 as parent,
		null,
		dt.id,
		dt.description,
		dt.typeid
from
	(SELECT DISTINCT
		T3.PolicyBusinessId AS [id],    
		T3.SequentialRef + ': ' + T10.CorporateName + ' - ' + T8.PlanTypeName + ISNULL(' (' + T3.PolicyNumber + ')', '') AS [description],
		CASE WHEN T2.CRMContactId = @CRMContactId THEN 'Client 1'
		     ELSE 'Client 2' END as [typeid]
	FROM 
		PolicyManagement..TPolicyOwner T2    
		JOIN PolicyManagement..TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId     
		JOIN PolicyManagement..TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId     
		-- is this a pre-xeisting plan defect #2562    
		JOIN PolicyManagement..TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1    
		JOIN PolicyManagement..TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'    
		JOIN PolicyManagement..TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId     
		JOIN PolicyManagement..TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId     
		JOIN PolicyManagement..TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId     
		JOIN PolicyManagement..TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId     
		JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId    
	WHERE
		T3.IndigoClientId = @TenantId
		AND T2.CRMContactId IN (@CRMContactId, @CRMContactId2)

	UNION

	SELECT DISTINCT
		T3.PolicyBusinessId AS [id],    
		T3.SequentialRef + ': ' + T10.CorporateName + ' - ' + T8.PlanTypeName + ISNULL(' (' + T3.PolicyNumber + ')', '') AS [description],
		'Joint' as [typeid]
	FROM 
		PolicyManagement..TPolicyOwner T2    
		JOIN PolicyManagement..TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId     
		JOIN PolicyManagement..TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId     
		-- is this a pre-xeisting plan defect #2562    
		JOIN PolicyManagement..TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1    
		JOIN PolicyManagement..TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'    
		JOIN PolicyManagement..TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId     
		JOIN PolicyManagement..TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId     
		JOIN PolicyManagement..TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId     
		JOIN PolicyManagement..TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId     
		JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId    
	WHERE
		T3.IndigoClientId = @TenantId
		AND T2.CRMContactId IN (@CRMContactId, @CRMContactId2)
     
	UNION
	SELECT DISTINCT
		T2.PolicyBusinessId AS [PlanId],    
		T2.SequentialRef + ': ' + T10.CorporateName + ' - ' + T8.PlanTypeName + ISNULL(' (' + T2.PolicyNumber + ')', '') AS [LongName],
		CASE WHEN T99.CRMContactId = @CRMContactId THEN 'Client 1'
		     ELSE 'Client 2' END as [typeid] 
	FROM 
		PolicyManagement..TAdditionalOwner T99 
		JOIN PolicyManagement..TPolicyBusiness T2 on T2.PolicyBusinessId  = T99.PolicyBusinessId
		JOIN PolicyManagement..TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId     
		JOIN PolicyManagement..TStatusHistory T4 ON T2.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1    
		JOIN PolicyManagement..TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'    
		JOIN PolicyManagement..TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId     
		JOIN PolicyManagement..TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId     
		JOIN PolicyManagement..TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId     
		JOIN PolicyManagement..TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId     
		JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId    
	WHERE 
		T2.IndigoClientId = @TenantId
		AND T99.CRMContactId IN (@CRMContactId, @CRMContactId2)

	UNION
	SELECT DISTINCT
		T2.PolicyBusinessId AS [PlanId],    
		T2.SequentialRef + ': ' + T10.CorporateName + ' - ' + T8.PlanTypeName + ISNULL(' (' + T2.PolicyNumber + ')', '') AS [LongName],
		'Joint' as [typeid]
	FROM 
		PolicyManagement..TAdditionalOwner T99 
		JOIN PolicyManagement..TPolicyBusiness T2 on T2.PolicyBusinessId  = T99.PolicyBusinessId
		JOIN PolicyManagement..TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId     
		JOIN PolicyManagement..TStatusHistory T4 ON T2.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1    
		JOIN PolicyManagement..TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'    
		JOIN PolicyManagement..TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId     
		JOIN PolicyManagement..TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId     
		JOIN PolicyManagement..TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId     
		JOIN PolicyManagement..TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId     
		JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId    
	WHERE 
		T2.IndigoClientId = @TenantId
		AND T99.CRMContactId IN (@CRMContactId, @CRMContactId2)
     
	UNION
	SELECT DISTINCT
		T2.PolicyBusinessId AS [PlanId],    
		T2.SequentialRef + ': ' + T10.CorporateName + ' - ' + T8.PlanTypeName + ISNULL(' (' + T2.PolicyNumber + ')', '') AS [LongName],
		CASE WHEN T99.CRMContactId = @CRMContactId THEN 'Client 1'
		     ELSE 'Client 2' END as [typeid]       
	FROM 
		PolicyManagement..TAdditionalOwner T99 
		JOIN PolicyManagement..TPolicyBusiness T2 on T2.PolicyBusinessId  = T99.PolicyBusinessId
		JOIN PolicyManagement..TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId     
		JOIN PolicyManagement..TStatusHistory T4 ON T2.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1    
		JOIN PolicyManagement..TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'    
		JOIN PolicyManagement..TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId     
		JOIN PolicyManagement..TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId     
		JOIN PolicyManagement..TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId     
		JOIN PolicyManagement..TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId     
		JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId    
	WHERE 
		T2.IndigoClientId = @TenantId
		AND T99.CRMContactId IN (@CRMContactId, @CRMContactId2)

	UNION
	
	SELECT DISTINCT
		T2.PolicyBusinessId AS [PlanId],    
		T2.SequentialRef + ': ' + T10.CorporateName + ' - ' + T8.PlanTypeName + ISNULL(' (' + T2.PolicyNumber + ')', '') AS [LongName],
		'Joint' as [typeid]     
	FROM 
		PolicyManagement..TAdditionalOwner T99 
		JOIN PolicyManagement..TPolicyBusiness T2 on T2.PolicyBusinessId  = T99.PolicyBusinessId
		JOIN PolicyManagement..TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId     
		JOIN PolicyManagement..TStatusHistory T4 ON T2.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1    
		JOIN PolicyManagement..TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'    
		JOIN PolicyManagement..TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId     
		JOIN PolicyManagement..TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId     
		JOIN PolicyManagement..TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId     
		JOIN PolicyManagement..TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId     
		JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId    
	WHERE 
		T2.IndigoClientId = @TenantId
		AND T99.CRMContactId IN (@CRMContactId, @CRMContactId2)) dt
	ORDER BY [Plan!2!id]

FOR XML explicit
GO
