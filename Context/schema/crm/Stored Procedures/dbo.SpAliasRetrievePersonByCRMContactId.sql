SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpAliasRetrievePersonByCRMContactId]
@CRMContactId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.CRMContactId AS [CRMContact!1!CRMContactId], 
    ISNULL(T1.RefCRMContactStatusId, '') AS [CRMContact!1!RefCRMContactStatusId], 
    ISNULL(T1.PersonId, '') AS [CRMContact!1!PersonId], 
    ISNULL(T1.CorporateId, '') AS [CRMContact!1!CorporateId], 
    ISNULL(T1.TrustId, '') AS [CRMContact!1!TrustId], 
    ISNULL(T1.AdvisorRef, '') AS [CRMContact!1!AdvisorRef], 
    ISNULL(T1.RefSourceOfClientId, '') AS [CRMContact!1!RefSourceOfClientId], 
    ISNULL(T1.SourceValue, '') AS [CRMContact!1!SourceValue], 
    ISNULL(T1.Notes, '') AS [CRMContact!1!Notes], 
    ISNULL(T1.ArchiveFg, '') AS [CRMContact!1!ArchiveFg], 
    ISNULL(T1.LastName, '') AS [CRMContact!1!LastName], 
    ISNULL(T1.FirstName, '') AS [CRMContact!1!FirstName], 
    ISNULL(T1.CorporateName, '') AS [CRMContact!1!CorporateName], 
    ISNULL(CONVERT(varchar(24), T1.DOB, 120),'') AS [CRMContact!1!DOB], 
    ISNULL(T1.Postcode, '') AS [CRMContact!1!Postcode], 
    T1.OriginalAdviserCRMId AS [CRMContact!1!OriginalAdviserCRMId], 
    T1.CurrentAdviserCRMId AS [CRMContact!1!CurrentAdviserCRMId], 
    ISNULL(T1.CurrentAdviserName, '') AS [CRMContact!1!CurrentAdviserName], 
    T1.CRMContactType AS [CRMContact!1!CRMContactType], 
    T1.IndClientId AS [CRMContact!1!IndClientId], 
    ISNULL(T1.FactFindId, '') AS [CRMContact!1!FactFindId], 
    ISNULL(T1.InternalContactFG, '') AS [CRMContact!1!InternalContactFG], 
    ISNULL(T1.RefServiceStatusId, '') AS [CRMContact!1!RefServiceStatusId], 
    ISNULL(T1.MigrationRef, '') AS [CRMContact!1!MigrationRef], 
    CONVERT(varchar(24), T1.CreatedDate, 120) AS [CRMContact!1!CreatedDate], 
    ISNULL(T1.ExternalReference, '') AS [CRMContact!1!ExternalReference], 
    ISNULL(T1.CampaignDataId, '') AS [CRMContact!1!CampaignDataId], 
    ISNULL(T1.AdditionalRef, '') AS [CRMContact!1!AdditionalRef], 
    ISNULL(T1._ParentId, '') AS [CRMContact!1!_ParentId], 
    ISNULL(T1._ParentTable, '') AS [CRMContact!1!_ParentTable], 
    ISNULL(T1._ParentDb, '') AS [CRMContact!1!_ParentDb], 
    ISNULL(T1._OwnerId, '') AS [CRMContact!1!_OwnerId], 
    T1.ConcurrencyId AS [CRMContact!1!ConcurrencyId], 
    ISNULL(TNote.Note, '') AS [CRMContact!1!_note], 
    NULL AS [Person!2!PersonId], 
    NULL AS [Person!2!Title], 
    NULL AS [Person!2!FirstName], 
    NULL AS [Person!2!MiddleName], 
    NULL AS [Person!2!LastName], 
    NULL AS [Person!2!MaidenName], 
    NULL AS [Person!2!DOB], 
    NULL AS [Person!2!GenderType], 
    NULL AS [Person!2!NINumber], 
    NULL AS [Person!2!IsSmoker], 
    NULL AS [Person!2!UKResident], 
    NULL AS [Person!2!ResidentIn], 
    NULL AS [Person!2!Salutation], 
    NULL AS [Person!2!RefSourceTypeId], 
    NULL AS [Person!2!IntroducerSource], 
    NULL AS [Person!2!MaritalStatus], 
    NULL AS [Person!2!MarriedOn], 
    NULL AS [Person!2!Residency], 
    NULL AS [Person!2!UKDomicile], 
    NULL AS [Person!2!Domicile], 
    NULL AS [Person!2!TaxCode], 
    NULL AS [Person!2!Nationality], 
    NULL AS [Person!2!ArchiveFG], 
    NULL AS [Person!2!IndClientId], 
    NULL AS [Person!2!ConcurrencyId]
  FROM TCRMContact T1
  -- Note clause
  LEFT JOIN TCRMContactNote TNote
  ON TNote.CRMContactId = T1.CRMContactId AND TNote.IsLatest=1

  WHERE (T1.CRMContactId = @CRMContactId)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.CRMContactId, 
    ISNULL(T1.RefCRMContactStatusId, ''), 
    ISNULL(T1.PersonId, ''), 
    ISNULL(T1.CorporateId, ''), 
    ISNULL(T1.TrustId, ''), 
    ISNULL(T1.AdvisorRef, ''), 
    ISNULL(T1.RefSourceOfClientId, ''), 
    ISNULL(T1.SourceValue, ''), 
    ISNULL(T1.Notes, ''), 
    ISNULL(T1.ArchiveFg, ''), 
    ISNULL(T1.LastName, ''), 
    ISNULL(T1.FirstName, ''), 
    ISNULL(T1.CorporateName, ''), 
    ISNULL(CONVERT(varchar(24), T1.DOB, 120),''), 
    ISNULL(T1.Postcode, ''), 
    T1.OriginalAdviserCRMId, 
    T1.CurrentAdviserCRMId, 
    ISNULL(T1.CurrentAdviserName, ''), 
    T1.CRMContactType, 
    T1.IndClientId, 
    ISNULL(T1.FactFindId, ''), 
    ISNULL(T1.InternalContactFG, ''), 
    ISNULL(T1.RefServiceStatusId, ''), 
    ISNULL(T1.MigrationRef, ''), 
    CONVERT(varchar(24), T1.CreatedDate, 120), 
    ISNULL(T1.ExternalReference, ''), 
    ISNULL(T1.CampaignDataId, ''), 
    ISNULL(T1.AdditionalRef, ''), 
    ISNULL(T1._ParentId, ''), 
    ISNULL(T1._ParentTable, ''), 
    ISNULL(T1._ParentDb, ''), 
    ISNULL(T1._OwnerId, ''), 
    T1.ConcurrencyId, 
    NULL,
    T2.PersonId, 
    ISNULL(T2.Title, ''), 
    T2.FirstName, 
    ISNULL(T2.MiddleName, ''), 
    T2.LastName, 
    ISNULL(T2.MaidenName, ''), 
    ISNULL(CONVERT(varchar(24), T2.DOB, 120),''), 
    ISNULL(T2.GenderType, ''), 
    ISNULL(T2.NINumber, ''), 
    ISNULL(T2.IsSmoker, ''), 
    ISNULL(T2.UKResident, ''), 
    ISNULL(T2.ResidentIn, ''), 
    ISNULL(T2.Salutation, ''), 
    ISNULL(T2.RefSourceTypeId, ''), 
    ISNULL(T2.IntroducerSource, ''), 
    ISNULL(T2.MaritalStatus, ''), 
    ISNULL(CONVERT(varchar(24), T2.MarriedOn, 120),''), 
    ISNULL(T2.Residency, ''), 
    ISNULL(T2.UKDomicile, ''), 
    ISNULL(T2.Domicile, ''), 
    ISNULL(T2.TaxCode, ''), 
    ISNULL(T2.Nationality, ''), 
    T2.ArchiveFG, 
    T2.IndClientId, 
    T2.ConcurrencyId
  FROM TPerson T2
  INNER JOIN TCRMContact T1
  ON T2.PersonId = T1.PersonId

  WHERE (T1.CRMContactId = @CRMContactId)

  ORDER BY [CRMContact!1!CRMContactId], [Person!2!PersonId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
