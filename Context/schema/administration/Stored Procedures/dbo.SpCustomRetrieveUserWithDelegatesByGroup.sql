SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveUserWithDelegatesByGroup]
@UserId bigint,
@GroupId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.UserId AS [User!1!UserId], 
    T1.Identifier AS [User!1!Identifier], 
    T1.Password AS [User!1!Password], 
    ISNULL(T1.PasswordHistory, '') AS [User!1!PasswordHistory], 
    T1.Email AS [User!1!Email], 
    ISNULL(T1.Telephone, '') AS [User!1!Telephone], 
    T1.Status AS [User!1!Status], 
    T1.GroupId AS [User!1!GroupId], 
    ISNULL(T1.SyncPassword, '') AS [User!1!SyncPassword], 
    ISNULL(CONVERT(varchar(24), T1.ExpirePasswordOn, 120),'') AS [User!1!ExpirePasswordOn], 
    T1.SuperUser AS [User!1!SuperUser], 
    T1.SuperViewer AS [User!1!SuperViewer], 
    T1.FailedAccessAttempts AS [User!1!FailedAccessAttempts], 
    T1.WelcomePage AS [User!1!WelcomePage], 
    ISNULL(T1.Reference, '') AS [User!1!Reference], 
    ISNULL(T1.CRMContactId, '') AS [User!1!CRMContactId], 
    NULL AS [User!1!SearchData], 
    NULL AS [User!1!RecentData], 
    NULL AS [User!1!RecentWork], 
    ISNULL(T1.IndigoClientId, '') AS [User!1!IndigoClientId], 
    T1.ConcurrencyId AS [User!1!ConcurrencyId], 
    NULL AS [Delegate!2!DelegateId], 
    NULL AS [Delegate!2!UserId], 
    NULL AS [Delegate!2!DelegatedUserId], 
    NULL AS [Delegate!2!ConcurrencyId], 
    NULL AS [CRMContact!3!CRMContactId], 
    NULL AS [CRMContact!3!RefCRMContactStatusId], 
    NULL AS [CRMContact!3!PersonId], 
    NULL AS [CRMContact!3!CorporateId], 
    NULL AS [CRMContact!3!TrustId], 
    NULL AS [CRMContact!3!AdvisorRef], 
    NULL AS [CRMContact!3!RefSourceOfClientId], 
    NULL AS [CRMContact!3!SourceValue], 
    NULL AS [CRMContact!3!Notes], 
    NULL AS [CRMContact!3!ArchiveFg], 
    NULL AS [CRMContact!3!LastName], 
    NULL AS [CRMContact!3!FirstName], 
    NULL AS [CRMContact!3!CorporateName], 
    NULL AS [CRMContact!3!DOB], 
    NULL AS [CRMContact!3!Postcode], 
    NULL AS [CRMContact!3!OriginalAdviserCRMId], 
    NULL AS [CRMContact!3!CurrentAdviserCRMId], 
    NULL AS [CRMContact!3!CurrentAdviserName], 
    NULL AS [CRMContact!3!CRMContactType], 
    NULL AS [CRMContact!3!IndClientId], 
    NULL AS [CRMContact!3!FactFindId], 
    NULL AS [CRMContact!3!InternalContactFG], 
    NULL AS [CRMContact!3!RefServiceStatusId], 
    NULL AS [CRMContact!3!MigrationRef], 
    NULL AS [CRMContact!3!ConcurrencyId]
  FROM TUser T1

  WHERE (T1.UserId != @UserId) AND 
        (T1.GroupId = @GroupId)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.UserId, 
    T1.Identifier, 
    T1.Password, 
    ISNULL(T1.PasswordHistory, ''), 
    T1.Email, 
    ISNULL(T1.Telephone, ''), 
    T1.Status, 
    T1.GroupId, 
    ISNULL(T1.SyncPassword, ''), 
    ISNULL(CONVERT(varchar(24), T1.ExpirePasswordOn, 120),''), 
    T1.SuperUser, 
    T1.SuperViewer, 
    T1.FailedAccessAttempts, 
    T1.WelcomePage, 
    ISNULL(T1.Reference, ''), 
    ISNULL(T1.CRMContactId, ''), 
    NULL, 
    NULL, 
    NULL, 
    ISNULL(T1.IndigoClientId, ''), 
    T1.ConcurrencyId, 
    T2.DelegateId, 
    T2.UserId, 
    T2.DelegatedUserId, 
    T2.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
  FROM TDelegate T2
  INNER JOIN TUser T1
  ON T2.UserId = T1.UserId

  WHERE (T1.UserId != @UserId) AND 
        (T1.GroupId = @GroupId)
AND T2.DelegatedUserId = @UserId

  UNION ALL

  SELECT
    3 AS Tag,
    1 AS Parent,
    T1.UserId, 
    T1.Identifier, 
    T1.Password, 
    ISNULL(T1.PasswordHistory, ''), 
    T1.Email, 
    ISNULL(T1.Telephone, ''), 
    T1.Status, 
    T1.GroupId, 
    ISNULL(T1.SyncPassword, ''), 
    ISNULL(CONVERT(varchar(24), T1.ExpirePasswordOn, 120),''), 
    T1.SuperUser, 
    T1.SuperViewer, 
    T1.FailedAccessAttempts, 
    T1.WelcomePage, 
    ISNULL(T1.Reference, ''), 
    ISNULL(T1.CRMContactId, ''), 
    NULL, 
    NULL, 
    NULL, 
    ISNULL(T1.IndigoClientId, ''), 
    T1.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T3.CRMContactId, 
    ISNULL(T3.RefCRMContactStatusId, ''), 
    ISNULL(T3.PersonId, ''), 
    ISNULL(T3.CorporateId, ''), 
    ISNULL(T3.TrustId, ''), 
    ISNULL(T3.AdvisorRef, ''), 
    ISNULL(T3.RefSourceOfClientId, ''), 
    ISNULL(T3.SourceValue, ''), 
    ISNULL(T3.Notes, ''), 
    ISNULL(T3.ArchiveFg, ''), 
    ISNULL(T3.LastName, ''), 
    ISNULL(T3.FirstName, ''), 
    ISNULL(T3.CorporateName, ''), 
    ISNULL(CONVERT(varchar(24), T3.DOB, 120),''), 
    ISNULL(T3.Postcode, ''), 
    T3.OriginalAdviserCRMId, 
    T3.CurrentAdviserCRMId, 
    ISNULL(T3.CurrentAdviserName, ''), 
    T3.CRMContactType, 
    T3.IndClientId, 
    ISNULL(T3.FactFindId, ''), 
    ISNULL(T3.InternalContactFG, ''), 
    ISNULL(T3.RefServiceStatusId, ''), 
    ISNULL(T3.MigrationRef, ''), 
    T3.ConcurrencyId
  FROM [CRM].[dbo].TCRMContact T3
  INNER JOIN TUser T1
  ON T3.CRMContactId = T1.CRMContactId

  WHERE (T1.UserId != @UserId) AND 
        (T1.GroupId = @GroupId)

  ORDER BY [User!1!UserId], [CRMContact!3!CRMContactId], [Delegate!2!DelegateId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
