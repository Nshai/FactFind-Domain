create view [dbo].[vPV_AllSuccessfulValuationForLast24Hours]
as
--All successful valuation traffic
select WhoUpdatedDateTime,RefProdProviderId,RefPLanTypeId,IndigoClientId,sum(PlanValue) as PlanValue,count(1) as Plancount,RefPlanValueTypeId,'Successful' as Status
from
(select distinct convert(date,WhoUpdatedDateTime) as WhoUpdatedDateTime,G.RefProdProviderId,f.RefPLanTypeId,a.IndigoClientId,max(ZRef.RefPlanValueTypeId)  over (partition by Z.PolicyBusinessId)  as RefPlanValueTypeId,max(Z.PlanValue) over (partition by Z.PolicyBusinessId) as PlanValue,Z.PolicyBusinessId
From policymanagement.dbo.TPolicyBusiness a 
Join policymanagement.dbo.TPolicyDetail c  On A.PolicyDetailId = c.PolicyDetailId
Join policymanagement.dbo.TPlanDescription d  On c.PlanDescriptionId = d.PlanDescriptionId
Join policymanagement.dbo.TRefPlanType2ProdSubType e  on d.RefPlanType2ProdSubTypeId = e.RefPlanType2ProdSubTypeId
Join policymanagement.dbo.TRefPlanType f  on e.RefPLanTypeId = f.RefPLanTypeId
Join policymanagement.dbo.TRefProdProvider g  on d.RefProdProviderId = g.RefProdProviderId
Join CRM.dbo.TCrmContact h  on g.CrmContactId = h.CrmContactId
join policymanagement.dbo.TPlanValuation Z  on (A.PolicyBusinessId = Z.PolicyBusinessId)
join policymanagement.dbo.TRefPlanValueType ZRef  on (Z.RefPlanValueTypeId = ZRef.RefPlanValueTypeId)
join Administration.dbo.v_activetenants AT on A.IndigoClientId = AT.IndigoClientId
where Z.WhoUpdatedDateTime between convert(date,getdate()-1) and convert(date,getdate())
) X
group by WhoUpdatedDateTime,RefProdProviderId,RefPLanTypeId,IndigoClientId,RefPlanValueTypeId
