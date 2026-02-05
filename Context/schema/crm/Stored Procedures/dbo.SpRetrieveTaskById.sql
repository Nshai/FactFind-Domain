SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveTaskById]
	@TaskId int, @TenantId int
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.TaskId AS [Task!1!TaskId], 
	ISNULL(CONVERT(varchar(24), T1.StartDate, 120), '') AS [Task!1!StartDate], 
	ISNULL(CONVERT(varchar(24), T1.DueDate, 120), '') AS [Task!1!DueDate], 
	T1.PercentComplete AS [Task!1!PercentComplete], 
	ISNULL(T1.Notes, '') AS [Task!1!Notes], 
	ISNULL(T1.AssignedUserId, '') AS [Task!1!AssignedUserId], 
	ISNULL(T1.PerformedUserId, '') AS [Task!1!PerformedUserId], 
	ISNULL(T1.AssignedToUserId, '') AS [Task!1!AssignedToUserId], 
	ISNULL(T1.AssignedToRoleId, '') AS [Task!1!AssignedToRoleId], 
	ISNULL(T1.ReminderId, '') AS [Task!1!ReminderId], 
	ISNULL(T1.Subject, '') AS [Task!1!Subject], 
	ISNULL(T1.RefPriorityId, '') AS [Task!1!RefPriorityId], 
	ISNULL(T1.Other, '') AS [Task!1!Other], 
	ISNULL(T1.PrivateFg, '') AS [Task!1!PrivateFg], 
	ISNULL(CONVERT(varchar(24), T1.DateCompleted, 120), '') AS [Task!1!DateCompleted], 
	ISNULL(T1.EstimatedTimeHrs, '') AS [Task!1!EstimatedTimeHrs], 
	ISNULL(T1.EstimatedTimeMins, '') AS [Task!1!EstimatedTimeMins], 
	ISNULL(T1.ActualTimeHrs, '') AS [Task!1!ActualTimeHrs], 
	ISNULL(T1.ActualTimeMins, '') AS [Task!1!ActualTimeMins], 
	ISNULL(T1.CRMContactId, '') AS [Task!1!CRMContactId], 
	ISNULL(T1.URL, '') AS [Task!1!URL], 
	ISNULL(T1.RefTaskStatusId, '') AS [Task!1!RefTaskStatusId], 
	ISNULL(T1.ActivityOutcomeId, '') AS [Task!1!ActivityOutcomeId], 
	T1.IndigoClientId AS [Task!1!IndigoClientId], 
	ISNULL(T1.ReturnToRoleId, '') AS [Task!1!ReturnToRoleId], 
	T1.ConcurrencyId AS [Task!1!ConcurrencyId],
	ISNULL(T1.SequentialRef, '') AS [Task!1!SequentialRef]
	FROM TTask T1
	
	WHERE T1.TaskId = @TaskId AND T1.IndigoClientId = @TenantId
	ORDER BY [Task!1!TaskId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
