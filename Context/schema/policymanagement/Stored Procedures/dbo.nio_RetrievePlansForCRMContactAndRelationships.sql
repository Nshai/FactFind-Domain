SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[nio_RetrievePlansForCRMContactAndRelationships]

@CRMContactId bigint,
@TenantId bigint,
@PlanCategoryName varchar (255) = 'All',
@PlanOwner varchar (255) = 'All'

as

set transaction isolation level read uncommitted

--Main Clients Plans
select	t3.policybusinessid as PolicyBusinessId,
		T8.PlanTypeName + ISNULL(' (' + T11.ProdSubTypeName + ')','') AS PlanType,      
		PolicyNumber,
		T10.CorporateName as Provider,
		T12.Firstname + ' ' + T12.Lastname as Owner,
		SequentialRef,
		'MainClient' as PlanOwner 	,
		PlanCategoryName
FROM TPolicyOwner T2      
INNER JOIN TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId       
INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId    
INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId       
INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId       
inner JOIN  TRefPlanType2ProdSubTypeCategory T5a ON T5a.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId
INNER JOIN TPlanCategory T1a ON T5a.PlanCategoryId = T1a.PlanCategoryId  
LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId      
INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId
INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId       
INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId  
INNER JOIN [CRM].[dbo].TCRMContact T12 ON  T2.CRMContactId = T12.CRMContactId  
INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1      
INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'      
where	t2.crmcontactid = @CRMContactId and 
		t1a.IndigoClientId = @TenantId and
		(@PlanCategoryName = 'All' or @PlanCategoryName = PlanCategoryName)


union

select	t3.policybusinessid,
		T8.PlanTypeName + ISNULL(' (' + T11.ProdSubTypeName + ')','') AS PlanType,      
		PolicyNumber,
		T10.CorporateName as Provider,
		T12.Firstname + ' ' + T12.Lastname as Owner,
		SequentialRef,
		case when IsPartnerFg = 1 then 'Partner' when IsFamilyFg = 1 then 'Family' end as PlanOwner,
		PlanCategoryName
FROM TPolicyOwner T2      
INNER JOIN TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId       
INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId    
INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId       
INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId       
inner JOIN  TRefPlanType2ProdSubTypeCategory T5a ON T5a.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId
INNER JOIN TPlanCategory T1a ON T5a.PlanCategoryId = T1a.PlanCategoryId  
LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId      
INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId
INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId       
INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId  
INNER JOIN [CRM].[dbo].TCRMContact T12 ON  T2.CRMContactId = T12.CRMContactId
inner join crm..TRelationship r on r.crmcontacttoid = t2.crmcontactid
INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1      
INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'       
where r.crmcontactfromid = @CRMContactId and t1a.IndigoClientId = @TenantId and		
		(@PlanCategoryName = 'All' or @PlanCategoryName = PlanCategoryName) and		
		(
			--all plans
			@PlanOwner = 'Show all Related Parties Plans' or 		
			--partners plans
			(@PlanOwner = 'Include Partner''s Plans' and IsPartnerFg = 1 ) or
			--family plans
			(@PlanOwner = 'Include Family''s Plans' and (IsFamilyFg = 1 or IsPartnerFg = 1))
		)
		
order by SequentialRef desc



GO
