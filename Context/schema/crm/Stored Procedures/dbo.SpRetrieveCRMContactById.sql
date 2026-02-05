SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveCRMContactById]
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
    ISNULL(TNote.Note, '') AS [CRMContact!1!_note]
  FROM TCRMContact T1
  -- Note clause
  LEFT JOIN TCRMContactNote TNote
  ON TNote.CRMContactId = T1.CRMContactId AND TNote.IsLatest=1

  WHERE (T1.CRMContactId = @CRMContactId)

  ORDER BY [CRMContact!1!CRMContactId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
