SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrievePractitionerById]
	@PractitionerId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.PractitionerId AS [Practitioner!1!PractitionerId], 
	T1.IndClientId AS [Practitioner!1!IndClientId], 
	ISNULL(T1.PersonId, '') AS [Practitioner!1!PersonId], 
	ISNULL(T1.CRMContactId, '') AS [Practitioner!1!CRMContactId], 
	ISNULL(T1.TnCCoachId, '') AS [Practitioner!1!TnCCoachId], 
	T1.AuthorisedFG AS [Practitioner!1!AuthorisedFG], 
	ISNULL(T1.PIARef, '') AS [Practitioner!1!PIARef], 
	ISNULL(CONVERT(varchar(24), T1.AuthorisedDate, 120), '') AS [Practitioner!1!AuthorisedDate], 
	ISNULL(T1.ExperienceLevel, '') AS [Practitioner!1!ExperienceLevel], 
	T1.FSAReference AS [Practitioner!1!FSAReference], 
	T1.MultiTieFg AS [Practitioner!1!MultiTieFg], 
	T1.OffPanelFg AS [Practitioner!1!OffPanelFg], 
	ISNULL(T1.ManagerId,'') AS [Practitioner!1!ManagerId],
	ISNULL(T1.PractitionerTypeId, '') AS [Practitioner!1!PractitionerTypeId], 
	ISNULL(tpt.Description, '') as [Practitioner!1!PractitionerTypeDescription],
	ISNULL(T1._ParentId, '') AS [Practitioner!1!_ParentId], 
	ISNULL(T1._ParentTable, '') AS [Practitioner!1!_ParentTable], 
	ISNULL(T1._ParentDb, '') AS [Practitioner!1!_ParentDb], 
	ISNULL(T1._OwnerId, '') AS [Practitioner!1!_OwnerId], 
	T1.ConcurrencyId AS [Practitioner!1!ConcurrencyId],
	ISNULL(Tc.FirstName,'') + ' ' + ISNULL(Tc.LastName,'') AS [Practitioner!1!ManagerName]
	 
	FROM TPractitioner T1
	
	LEFT JOIN TPractitionerType tpt ON t1.PractitionerTypeId = tpt.PractitionerTypeId
	LEFT JOIN administration..TUser Tu ON T1.ManagerId = Tu.userId
	LEFT JOIN Tcrmcontact Tc ON Tu.crmcontactId=Tc.crmContactId


	WHERE T1.PractitionerId = @PractitionerId
	ORDER BY [Practitioner!1!PractitionerId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
