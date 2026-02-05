SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveDiaryAppointmentsAndTasks]
	@TenantId BIGINT,
	@PartyId BIGINT,
	@StartTime DATETIME2,
	@EndTime DATETIME2
AS

--Select appointments
SELECT
	oa.OrganiserActivityId AS OrgId,
	a.AppointmentId,
	NULL AS TaskId,
	a.[Subject],
	a.StartTime AS StartDate,
	a.EndTime AS DueDate,
	a.TimeZone,
	a.AllDayEventFG AS IsAllDayEvent,
	ac.Colour AS ClassificationColour,
	oa.CompleteFG AS IsComplete,
	oa.RecurrenceSeriesId,
	oa.IsRecurrence,
	oa.CRMContactId AS ClientId,
	oa.JointCRMContactId AS JointClientId,
	ar.ActivityRecurrenceId,
	ar.RFCCode,
	ar.StartDate as RecurrenceStartDate,
	ar.EndDate as RecurrenceEndDate
FROM TOrganiserActivity oa
INNER JOIN TAppointment a ON oa.AppointmentId = a.AppointmentId
INNER JOIN TAttendees att ON oa.AppointmentId = att.AppointmentId
LEFT JOIN TRefClassification ac ON a.RefClassificationId = ac.RefClassificationId
LEFT JOIN TActivityRecurrence ar ON oa.OrganiserActivityId = ar.OrganiserActivityId
WHERE
	oa.IndigoClientId = @TenantId
	AND att.CRMContactId = @PartyId
	AND (
		(oa.IsRecurrence = 1 AND (ar.StartDate IS NULL OR ar.StartDate <= @EndTime) AND (ar.EndDate IS NULL OR ar.EndDate >= @StartTime))
		OR (oa.IsRecurrence = 0 AND a.StartTime <= @EndTime AND a.EndTime >= @StartTime)
	)

UNION ALL

--Select tasks
SELECT
	oa.OrganiserActivityId AS OrgId,
	NULL AS AppointmentId,
	t.TaskId,
	t.[Subject],
	t.StartDate,	
	t.DueDate,
	t.TimeZone,
	NULL AS IsAllDayEvent,
	NULL AS ClassificationColour,
	oa.CompleteFG AS IsComplete,
	oa.RecurrenceSeriesId,
	oa.IsRecurrence,
	NULL AS ClientId,
	oa.JointCRMContactId AS JointClientId,
	ar.ActivityRecurrenceId,
	ar.RFCCode,
	ar.StartDate as RecurrenceStartDate,
	ar.EndDate as RecurrenceEndDate
FROM TOrganiserActivity oa
INNER JOIN TTask t ON oa.TaskId = t.TaskId
LEFT JOIN TActivityRecurrence ar ON oa.OrganiserActivityId = ar.OrganiserActivityId
LEFT JOIN Administration.dbo.TUser u ON u.UserId = t.AssignedToUserId
WHERE
	oa.IndigoClientId = @TenantId
	AND u.CRMContactId = @PartyId
	AND t.ShowInDiary = 1
	AND (
		(oa.IsRecurrence = 1 AND (ar.StartDate IS NULL OR ar.StartDate <= @EndTime) AND (ar.EndDate IS NULL OR ar.EndDate >= @StartTime))
		OR (oa.IsRecurrence = 0 AND t.StartDate <= @EndTime AND t.DueDate >= @StartTime)
	)
OPTION (RECOMPILE) -- Parameter sniffing occurs frequently COPS-1744
GO
