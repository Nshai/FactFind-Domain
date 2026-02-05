SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefProdProviderWithCRMContactOnCRMKyCRMContactIdById]
@RefProdProviderId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefProdProviderId AS [RefProdProvider!1!RefProdProviderId], 
    ISNULL(T1.CRMContactId, '') AS [RefProdProvider!1!CRMContactId], 
    ISNULL(T1.FundProviderId, '') AS [RefProdProvider!1!FundProviderId], 
    ISNULL(T1.NewProdProviderId, '') AS [RefProdProvider!1!NewProdProviderId], 
    T1.RetireFg AS [RefProdProvider!1!RetireFg], 
    T1.ConcurrencyId AS [RefProdProvider!1!ConcurrencyId], 
    NULL AS [CRMContact!2!CRMContactId], 
    NULL AS [CRMContact!2!RefCRMContactStatusId], 
    NULL AS [CRMContact!2!PersonId], 
    NULL AS [CRMContact!2!CorporateId], 
    NULL AS [CRMContact!2!TrustId], 
    NULL AS [CRMContact!2!AdvisorRef], 
    NULL AS [CRMContact!2!RefSourceOfClientId], 
    NULL AS [CRMContact!2!SourceValue], 
    NULL AS [CRMContact!2!Notes], 
    NULL AS [CRMContact!2!ArchiveFg], 
    NULL AS [CRMContact!2!LastName], 
    NULL AS [CRMContact!2!FirstName], 
    NULL AS [CRMContact!2!CorporateName], 
    NULL AS [CRMContact!2!DOB], 
    NULL AS [CRMContact!2!Postcode], 
    NULL AS [CRMContact!2!OriginalAdviserCRMId], 
    NULL AS [CRMContact!2!CurrentAdviserCRMId], 
    NULL AS [CRMContact!2!CurrentAdviserName], 
    NULL AS [CRMContact!2!CRMContactType], 
    NULL AS [CRMContact!2!IndClientId], 
    NULL AS [CRMContact!2!FactFindId], 
    NULL AS [CRMContact!2!InternalContactFG], 
    NULL AS [CRMContact!2!RefServiceStatusId], 
    NULL AS [CRMContact!2!MigrationRef], 
    NULL AS [CRMContact!2!ConcurrencyId]
  FROM TRefProdProvider T1

  WHERE (T1.RefProdProviderId = @RefProdProviderId)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.RefProdProviderId, 
    ISNULL(T1.CRMContactId, ''), 
    ISNULL(T1.FundProviderId, ''), 
    ISNULL(T1.NewProdProviderId, ''), 
    T1.RetireFg, 
    T1.ConcurrencyId, 
    T2.CRMContactId, 
    ISNULL(T2.RefCRMContactStatusId, ''), 
    ISNULL(T2.PersonId, ''), 
    ISNULL(T2.CorporateId, ''), 
    ISNULL(T2.TrustId, ''), 
    ISNULL(T2.AdvisorRef, ''), 
    ISNULL(T2.RefSourceOfClientId, ''), 
    ISNULL(T2.SourceValue, ''), 
    ISNULL(T2.Notes, ''), 
    ISNULL(T2.ArchiveFg, ''), 
    ISNULL(T2.LastName, ''), 
    ISNULL(T2.FirstName, ''), 
    ISNULL(T2.CorporateName, ''), 
    ISNULL(CONVERT(varchar(24), T2.DOB, 120),''), 
    ISNULL(T2.Postcode, ''), 
    T2.OriginalAdviserCRMId, 
    T2.CurrentAdviserCRMId, 
    ISNULL(T2.CurrentAdviserName, ''), 
    T2.CRMContactType, 
    T2.IndClientId, 
    ISNULL(T2.FactFindId, ''), 
    ISNULL(T2.InternalContactFG, ''), 
    ISNULL(T2.RefServiceStatusId, ''), 
    ISNULL(T2.MigrationRef, ''), 
    T2.ConcurrencyId
  FROM [CRM].[dbo].TCRMContact T2
  INNER JOIN TRefProdProvider T1
  ON T2.CRMContactId = T1.CRMContactId

  WHERE (T1.RefProdProviderId = @RefProdProviderId)

  ORDER BY [RefProdProvider!1!RefProdProviderId], [CRMContact!2!CRMContactId]

  FOR XML EXPLICIT

END
RETURN (0)



GO
