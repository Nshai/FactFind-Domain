SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveDiaryTasks]
	@TenantId INT,
	@PartyId BIGINT,
	@StartTime DATETIME2,
	@EndTime DATETIME2
AS

SELECT
	oa.OrganiserActivityId AS OrgId,
	t.TaskId,
	t.[Subject],
	t.StartDate,
	t.DueDate,
	t.TimeZone,
	oa.CompleteFG AS IsComplete,
	oa.RecurrenceSeriesId,
	oa.IsRecurrence,
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
	and t.IndigoClientId = @TenantId
	AND u.CRMContactId = @PartyId
	AND t.ShowInDiary = 1
	AND (
		(oa.IsRecurrence = 1 AND (ar.StartDate IS NULL OR ar.StartDate <= @EndTime) AND (ar.EndDate IS NULL OR ar.EndDate >= @StartTime))
		OR (oa.IsRecurrence = 0 AND t.StartDate <= @EndTime AND t.DueDate >= @StartTime)
	)

GO
