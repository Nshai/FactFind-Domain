SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveOrganiserActivityById]
	@OrganiserActivityId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.OrganiserActivityId AS [OrganiserActivity!1!OrganiserActivityId], 
	ISNULL(T1.AppointmentId, '') AS [OrganiserActivity!1!AppointmentId], 
	ISNULL(T1.ActivityCategoryParentId, '') AS [OrganiserActivity!1!ActivityCategoryParentId], 
	ISNULL(T1.ActivityCategoryId, '') AS [OrganiserActivity!1!ActivityCategoryId], 
	ISNULL(T1.TaskId, '') AS [OrganiserActivity!1!TaskId], 
	T1.CompleteFG AS [OrganiserActivity!1!CompleteFG], 
	ISNULL(T1.PolicyId, '') AS [OrganiserActivity!1!PolicyId], 
	ISNULL(T1.FeeId, '') AS [OrganiserActivity!1!FeeId], 
	ISNULL(T1.RetainerId, '') AS [OrganiserActivity!1!RetainerId], 
	ISNULL(T1.OpportunityId, '') AS [OrganiserActivity!1!OpportunityId], 
	ISNULL(T1.EventListActivityId, '') AS [OrganiserActivity!1!EventListActivityId], 
	ISNULL(T1.CRMContactId, '') AS [OrganiserActivity!1!CRMContactId], 
	ISNULL(T1.IndigoClientId, '') AS [OrganiserActivity!1!IndigoClientId], 
	ISNULL(T1.AdviceCaseId, '') AS [OrganiserActivity!1!AdviceCaseId], 
	T1.ConcurrencyId AS [OrganiserActivity!1!ConcurrencyId]
	FROM TOrganiserActivity T1
	
	WHERE T1.OrganiserActivityId = @OrganiserActivityId
	ORDER BY [OrganiserActivity!1!OrganiserActivityId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
