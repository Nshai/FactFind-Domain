create view [dbo].[vPV_FailedBulkValuationForLast24Hours]
as
--All not matched bulk valuation
select A.Qtimestamp as WhoUpdatedDateTime,RefProdProviderId,null as RefPlanTypeId,IndigoClientId,null as sum_amount,convert(real,count(distinct PortfolioReference))/count(RefProdProviderId) over(partition by Qtimestamp,RefProdProviderId,IndigoClientId) as plan_count, B.RefPlanValueTypeId,'BV '+MatchingDescription  as status
from (  select distinct convert(date,A.Qtimestamp) as Qtimestamp,B.RefProdProviderId,A.IndigoclientId,PortfolioReference,case when ScheduledLevel = 'firm' then 'Electronic - Bulk Valuation' when ScheduledLevel = 'bulkmanual' then 'Manual - Bulk Valuation' else ScheduledLevel end as ScheduledLevel, PlanMatched, D.MatchingDescription
                from policymanagement..TValBulkNotMatched A 
                join policymanagement..TValSchedule B on A.ValScheduleId = B.ValScheduleId 
                join policymanagement..TValMatchingCriteria C on B.RefProdProviderId = C.ValuationProviderId 
                join policymanagement..VProvider C1 on B.RefProdProviderId = C1.RefProdProviderId
                cross apply policymanagement..TValRefMatchingFlag D 
                where C.MatchingMask &D.MatchingFlag = D.MatchingFlag 
                and A.Qtimestamp is not null
                and A.Qtimestamp between convert(date,getdate()-1) and convert(date,getdate())
                ) A
join PolicyManagement.dbo.TRefPlanValueType B on A.ScheduledLevel = B.RefPlanValueType
group by Qtimestamp,RefProdProviderId,IndigoClientId, B.RefPlanValueTypeId, 'BV '+MatchingDescription 
go