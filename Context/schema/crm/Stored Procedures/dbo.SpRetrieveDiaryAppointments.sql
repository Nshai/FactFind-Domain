SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveDiaryAppointments]
	@TenantId BIGINT,
	@PartyId BIGINT,
	@StartTime DATETIME2,
	@EndTime DATETIME2
AS

SELECT
	oa.OrganiserActivityId AS OrgId,
	a.AppointmentId,
	a.[Subject],
	a.StartTime,
	a.EndTime,
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

GO
