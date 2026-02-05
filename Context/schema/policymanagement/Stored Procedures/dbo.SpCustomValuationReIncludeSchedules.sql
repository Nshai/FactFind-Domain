create procedure dbo.SpCustomValuationReIncludeSchedules
as
/*
DATE : 5/02/2019 BY:KK
THIS PROCEDURE IS AN INTERIM SOLUTION TO RE-INCLUDE SCHEDULES, WHEN NONE OF THE PLANS IN IT WERE ATTEMPTED TO VALUE IN THE LAST CYCLE
IT WAS AGREED BETWEEN LAN, ELSA AND KK TO RUN THIS USING SQL JOB
SQL JOB WAS AGREED TO SET EXPIRE BY 01 JUN 2020
EXPECTATION IS THAT BY THEN WE WILL HAVE REDESIGNED THE SYSTE TO AVOID THIS DESIGN GAP

*/
begin
	set transaction isolation level read uncommitted

	if object_id('tempdb..#schedules') is not null drop table #schedules

	select distinct s.valscheduleid
	into #schedules
	from TValSchedule s
		join administration..tindigoclient ic on s.indigoclientid = ic.indigoclientid
		join TValScheduledplan sp on s.valscheduleid = sp.ValScheduleId
		join TPolicyBusiness pb on pb.PolicyBusinessId = sp.policybusinessid
		join TValScheduleitem i on s.ValScheduleId = i.ValScheduleId
		left join TValRequest q on sp.policybusinessid = q.PolicyBusinessId and q.RequestedDate > cast(i.LastOccurrence as date) and q.valuationtype = 'Electronic - Scheduled Request'
	where
		ic.Status = 'active'
		and s.ScheduledLevel in ('adviser', 'client')
		and sp.status = 1
		and Frequency != 'Daily'
		and i.LastOccurrence is not null
		and q.PolicyBusinessId is null
		--and s.refprodproviderid = 294
		--and s.indigoclientid = 12398
	except

	select distinct s.valscheduleid
	from TValSchedule s
		join administration..tindigoclient ic on s.indigoclientid = ic.indigoclientid
		join TValScheduledplan sp on s.valscheduleid = sp.ValScheduleId
		join TPolicyBusiness pb on pb.PolicyBusinessId = sp.policybusinessid
		join TValScheduleitem i on s.ValScheduleId = i.ValScheduleId
		left join TValRequest q on sp.policybusinessid = q.PolicyBusinessId and q.RequestedDate > cast(i.LastOccurrence as date) and q.valuationtype = 'Electronic - Scheduled Request'
	where
		ic.Status = 'active'
		and s.ScheduledLevel in ('adviser', 'client')
		and sp.status = 1
		and Frequency != 'Daily'
		and i.LastOccurrence is not null
		and q.PolicyBusinessId is not null
		--and s.refprodproviderid = 294
		--and s.indigoclientid = 12398

	Update t
		set NextOccurrence = t.LastOccurrence,
		ConcurrencyId = t.ConcurrencyId + 1,
		errormessage = 'schedule re-included by system'
			output
				DELETED.[ValScheduleId], DELETED.[ValQueueId],DELETED.[NextOccurrence],DELETED.[LastOccurrence],
				DELETED.[ErrorMessage],DELETED.[RefValScheduleItemStatusId],DELETED.[SaveAsFilePathAndName],DELETED.[ConcurrencyId],
				DELETED.[ValScheduleItemId], DELETED.[DocVersionId],'u', GETDATE(), 0, deleted.NotificationSentOn
			into
			TValscheduleItemAudit
				([ValScheduleId],[ValQueueId],[NextOccurrence],[LastOccurrence],
				[ErrorMessage],[RefValScheduleItemStatusId],[SaveAsFilePathAndName],[ConcurrencyId],
				[ValScheduleItemId],[DocVersionId],[StampAction],[StampDateTime],[StampUser], NotificationSentOn)
	from TValScheduleItem t join #schedules s on t.ValScheduleId = s.ValScheduleId
end
GO