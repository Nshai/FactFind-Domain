SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveCertificateWithUserKyUserIdByUserId]
@UserId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.CertificateId AS [Certificate!1!CertificateId], 
    T1.UserId AS [Certificate!1!UserId], 
    T1.CRMContactId AS [Certificate!1!CRMContactId], 
    ISNULL(T1.Issuer, '') AS [Certificate!1!Issuer], 
    ISNULL(T1.Subject, '') AS [Certificate!1!Subject], 
    ISNULL(CONVERT(varchar(24), T1.ValidFrom, 120),'') AS [Certificate!1!ValidFrom], 
    ISNULL(CONVERT(varchar(24), T1.ValidUntil, 120),'') AS [Certificate!1!ValidUntil], 
    ISNULL(T1.SerialNumber, '') AS [Certificate!1!SerialNumber], 
    ISNULL(T1.IsRevoked, '') AS [Certificate!1!IsRevoked], 
    ISNULL(T1.HasExpired, '') AS [Certificate!1!HasExpired], 
    ISNULL(CONVERT(varchar(24), T1.LastCheckedOn, 120),'') AS [Certificate!1!LastCheckedOn], 
    T1.ConcurrencyId AS [Certificate!1!ConcurrencyId], 
    NULL AS [User!2!UserId], 
    NULL AS [User!2!Identifier], 
    NULL AS [User!2!Password], 
    NULL AS [User!2!PasswordHistory], 
    NULL AS [User!2!Email], 
    NULL AS [User!2!Telephone], 
    NULL AS [User!2!Status], 
    NULL AS [User!2!GroupId], 
    NULL AS [User!2!SyncPassword], 
    NULL AS [User!2!ExpirePasswordOn], 
    NULL AS [User!2!SuperUser], 
    NULL AS [User!2!SuperViewer], 
    NULL AS [User!2!FinancialPlanningAccess], 
    NULL AS [User!2!FailedAccessAttempts], 
    NULL AS [User!2!WelcomePage], 
    NULL AS [User!2!Reference], 
    NULL AS [User!2!CRMContactId], 
    NULL AS [User!2!SearchData], 
    NULL AS [User!2!RecentData], 
    NULL AS [User!2!RecentWork], 
    NULL AS [User!2!IndigoClientId], 
    NULL AS [User!2!SupportUserFg], 
    NULL AS [User!2!ActiveRole], 
    NULL AS [User!2!CanLogCases], 
    NULL AS [User!2!RefUserTypeId], 
    NULL AS [User!2!Guid], 
    NULL AS [User!2!IsMortgageBenchEnabled], 
    NULL AS [User!2!ConcurrencyId]
  FROM TCertificate T1

  WHERE (T1.UserId = @UserId)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.CertificateId, 
    T1.UserId, 
    T1.CRMContactId, 
    ISNULL(T1.Issuer, ''), 
    ISNULL(T1.Subject, ''), 
    ISNULL(CONVERT(varchar(24), T1.ValidFrom, 120),''), 
    ISNULL(CONVERT(varchar(24), T1.ValidUntil, 120),''), 
    ISNULL(T1.SerialNumber, ''), 
    ISNULL(T1.IsRevoked, ''), 
    ISNULL(T1.HasExpired, ''), 
    ISNULL(CONVERT(varchar(24), T1.LastCheckedOn, 120),''), 
    T1.ConcurrencyId, 
    T2.UserId, 
    T2.Identifier, 
    T2.Password, 
    ISNULL(T2.PasswordHistory, ''), 
    T2.Email, 
    ISNULL(T2.Telephone, ''), 
    T2.Status, 
    T2.GroupId, 
    ISNULL(T2.SyncPassword, ''), 
    ISNULL(CONVERT(varchar(24), T2.ExpirePasswordOn, 120),''), 
    T2.SuperUser, 
    T2.SuperViewer, 
    T2.FinancialPlanningAccess, 
    T2.FailedAccessAttempts, 
    T2.WelcomePage, 
    ISNULL(T2.Reference, ''), 
    ISNULL(T2.CRMContactId, ''), 
    NULL, 
    NULL, 
    NULL, 
    ISNULL(T2.IndigoClientId, ''), 
    T2.SupportUserFg, 
    ISNULL(T2.ActiveRole, ''), 
    T2.CanLogCases, 
    T2.RefUserTypeId, 
    T2.Guid, 
    T2.IsMortgageBenchEnabled, 
    T2.ConcurrencyId
  FROM TUser T2
  INNER JOIN TCertificate T1
  ON T2.UserId = T1.UserId

  WHERE (T1.UserId = @UserId)

  ORDER BY [Certificate!1!CertificateId], [User!2!UserId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
