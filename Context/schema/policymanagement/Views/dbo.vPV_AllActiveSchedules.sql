create view [dbo].[vPV_AllActiveSchedules]
as
--Active Schedules
select AT.IndigoClientId, V.RefProdProviderId, s.Frequency,s.ScheduledLevel, count(1) as schedulecount,convert(date,getdate()) dated
FROM PolicyManagement..TValSchedule s 
JOIN PolicyManagement..TValScheduleItem i ON s.ValScheduleId = i.ValScheduleId 
JOIN (SELECT ValuationProviderId, SUM(Flag.EligibilityFlag)  EligibilityMask 
                FROM PolicyManagement..TValEligibilityCriteria Criteria 
                CROSS JOIN PolicyManagement..TValRefEligibilityFlag Flag 
                WHERE Criteria.EligibilityMask & Flag.EligibilityFlag = Flag.EligibilityFlag 
                And Flag.EligibilityLevel = 'plan' 
                GROUP BY ValuationProviderId) EligibilityCriteria ON s.RefProdProviderId = EligibilityCriteria.ValuationProviderId 
join PolicyManagement..VProvider V on s.RefProdProviderId = v.RefProdProviderId
join Administration..v_activetenants AT on S.IndigoClientId = AT.IndigoClientId
WHERE ((coalesce(S.Frequency,'') <> 'Single') OR (s.Frequency = 'Single' AND i.RefValScheduleItemStatusId = 5))
and s.islocked = 0
group by AT.IndigoClientId, V.RefProdProviderId, s.Frequency,s.ScheduledLevel
go