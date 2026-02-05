create view [dbo].[vPV_Statistics_UnderlyingData]
as
--Plan statistics Total Plans | Potential Plans | Valued Plans
select B.IndigoClientId,B2.RefProdProviderId,PP.ValuationProviderId ,f.RefPLanTypeId,B.PolicyBusinessId, case when EF.valuationproviderid is null then null else PP.ValPotentialPlanId end as ValPotentialPlanId, case when B.PlanMigrationRef is not null then 1 else 0 end as DIFlag, max(PlanValuationId) as PlanValuationId
from policymanagement.dbo.TStatusHistory A
join policymanagement.dbo.TPolicyBusiness B on A.PolicyBusinessId = B.PolicyBusinessId and A.CurrentStatusFG = 1
join policymanagement.dbo.TPolicyDetail B1 on B.PolicyDetailId = B1.PolicyDetailId
join policymanagement.dbo.TPlanDescription B2 on B1.PlanDescriptionId = B2.PlanDescriptionId
Join policymanagement.dbo.TRefPlanType2ProdSubType e  on B2.RefPlanType2ProdSubTypeId = e.RefPlanType2ProdSubTypeId
Join policymanagement.dbo.TRefPlanType f  on e.RefPLanTypeId = f.RefPLanTypeId
join administration.dbo.v_activetenants X on B.IndigoClientId = X.IndigoClientId 
join policymanagement.dbo.TStatus C on A.StatusId = C.StatusId and B.IndigoClientId = C.IndigoClientId
left join policymanagement.dbo.TPlanValuation V on B.PolicyBusinessId = V.PolicyBusinessId and V.RefPlanValueTypeId not in (1,4)
left join policymanagement.dbo.TValPotentialPlan PP on (A.PolicyBusinessId = PP.PolicyBusinessId and PP.ValuationProviderId != 2572)
left join policymanagement.dbo.vPV_PlanEligibilityByProvider ef on (ef.criteria_tobeconsidered & pp.EligibilityMask =  ef.criteria_tobeconsidered and ef.valuationproviderid = pp.ValuationProviderId)
where C.IntelligentOfficeStatusType in ('Fund Switch','Paid Up','In force')
and A.ChangedToDate <= getdate() and isnull(B.TotalRegularPremium,0) between 0 and 10000000 and isnull(B.TotalLumpSum,0) between 0 and 10000000 
group by B.IndigoClientId,B2.RefProdProviderId,PP.ValuationProviderId ,f.RefPLanTypeId,B.PolicyBusinessId, case when EF.valuationproviderid is null then null else PP.ValPotentialPlanId end,case when B.PlanMigrationRef is not null then 1 else 0 end
go