SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrievePractitionerByPractitionerId]
	@PractitionerId bigint
AS

SELECT T1.PractitionerId, T1.IndClientId, T1.PersonId, T1.CRMContactId, T1.TnCCoachId, T1.AuthorisedFG, 
	T1.PIARef, T1.AuthorisedDate, T1.ExperienceLevel, T1.FSAReference, T1.MultiTieFg, T1.OffPanelFg, 
	T1.ManagerId, T1.PractitionerTypeId, T1._ParentId, T1._ParentTable, T1._ParentDb, T1._OwnerId, T1.ConcurrencyId
FROM TPractitioner  T1
WHERE T1.PractitionerId = @PractitionerId
GO
