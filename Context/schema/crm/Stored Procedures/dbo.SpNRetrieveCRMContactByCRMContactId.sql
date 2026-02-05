SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveCRMContactByCRMContactId]
	@CRMContactId bigint
AS

SELECT T1.CRMContactId, T1.RefCRMContactStatusId, T1.PersonId, T1.CorporateId, T1.TrustId, T1.AdvisorRef, 
	T1.RefSourceOfClientId, T1.SourceValue, T1.Notes, T1.ArchiveFg, T1.LastName, T1.FirstName, 
	T1.CorporateName, T1.DOB, T1.Postcode, T1.OriginalAdviserCRMId, T1.CurrentAdviserCRMId, T1.CurrentAdviserName, 
	T1.CRMContactType, T1.IndClientId, T1.FactFindId, T1.InternalContactFG, T1.RefServiceStatusId, T1.MigrationRef, 
	T1.CreatedDate, T1.ExternalReference, T1.CampaignDataId, T1.AdditionalRef, T1._ParentId, T1._ParentTable, 
	T1._ParentDb, T1._OwnerId, T1.ConcurrencyId
FROM TCRMContact  T1
-- Note clause
LEFT JOIN TCRMContactNote TNote
	ON T1.CRMContactId = TNote.CRMContactId AND TNote.IsLatest=1
WHERE T1.CRMContactId = @CRMContactId
GO
