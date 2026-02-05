SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchUserByName.sql]
	@FirstName varchar(255) = '%',
	@LastName varchar(255) = '%',
	@IndigoClientId bigint
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
    T1.FailedAccessAttempts AS [User!1!FailedAccessAttempts], 
    T1.WelcomePage AS [User!1!WelcomePage], 
    ISNULL(T1.Reference, '') AS [User!1!Reference], 
    ISNULL(T1.CRMContactId, '') AS [User!1!CRMContactId], 
    ISNULL(T1.IndigoClientId, '') AS [User!1!IndigoClientId], 
    T1.ConcurrencyId AS [User!1!ConcurrencyId], 
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
    NULL AS [CRMContact!2!FullName], 
    NULL AS [CRMContact!2!FirstName], 
    NULL AS [CRMContact!2!LastName], 
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
    NULL AS [CRMContact!2!_ParentId], 
    NULL AS [CRMContact!2!_ParentTable], 
    NULL AS [CRMContact!2!_ParentDb], 
    NULL AS [CRMContact!2!_OwnerId], 
    NULL AS [CRMContact!2!ConcurrencyId], 
    NULL AS [Group!3!GroupId], 
    NULL AS [Group!3!Identifier], 
    NULL AS [Group!3!GroupingId], 
    NULL AS [Group!3!ParentId], 
    NULL AS [Group!3!CRMContactId], 
    NULL AS [Group!3!IndigoClientId], 
    NULL AS [Group!3!ConcurrencyId]
  FROM TUser T1
  INNER JOIN [CRM].[dbo].TCRMContact T2   ON T1.CRMContactId=T2.CRMContactId
  LEFT JOIN CRM..TPractitioner T3 ON T1.CRMContactId = T3.CRMContactId
   WHERE
 (T2.FirstName LIKE '%' + @Firstname + '%' Or @Firstname='') AND
 (T2.LastName LIKE '%' + @Lastname + '%' Or @Lastname='') AND
 (T1.IndigoClientId = @IndigoClientId)
  AND T3.PractitionerID IS NULL	-- NON ADVISER USERS ONLY

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
    T1.FailedAccessAttempts, 
    T1.WelcomePage, 
    ISNULL(T1.Reference, ''), 
    ISNULL(T1.CRMContactId, ''), 
    ISNULL(T1.IndigoClientId, ''), 
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
    ISNULL(T2.FirstName, '') + ' ' + ISNULL(T2.LastName, ''), 
    ISNULL(T2.FirstName, ''),
    ISNULL(T2.LastName, ''), 
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
    ISNULL(T2._ParentId, ''), 
    ISNULL(T2._ParentTable, ''), 
    ISNULL(T2._ParentDb, ''), 
    ISNULL(T2._OwnerId, ''), 
    T2.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
  FROM [CRM].[dbo].TCRMContact T2
  INNER JOIN TUser T1 ON T2.CRMContactId = T1.CRMContactId
  LEFT JOIN CRM..TPractitioner T3 ON T2.CRMContactId = T3.CRMContactId

  WHERE T1.CRMContactId in (SELECT CRMContactId FROM CRM..TCRMContact
			    WHERE (@FirstName <> '' AND @LastName = '' AND (FirstName LIKE '%' + @FirstName + '%')) OR --First Name only
			          (@FirstName = '' AND @LastName <> ''AND (LastName LIKE '%' + @LastName + '%')) OR	-- Last Name only
			          (@FirstName <> '' AND @LastName <> ''AND ((FirstName LIKE '%' + @FirstName + '%') AND (LastName LIKE '%' + @LastName + '%')))) /*First and Last Name*/ AND
	(T1.IndigoClientId = @IndigoClientId)
	AND T3.PractitionerId IS NULL	-- NON ADVISER USERS ONLY

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
    T1.FailedAccessAttempts, 
    T1.WelcomePage, 
    ISNULL(T1.Reference, ''), 
    ISNULL(T1.CRMContactId, ''), 
    ISNULL(T1.IndigoClientId, ''), 
    T1.ConcurrencyId, 
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
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T3.GroupId, 
    T3.Identifier, 
    T3.GroupingId, 
    ISNULL(T3.ParentId, ''), 
    ISNULL(T3.CRMContactId, ''), 
    T3.IndigoClientId, 
    T3.ConcurrencyId
  FROM TGroup T3
  INNER JOIN TUser T1 ON T3.GroupId = T1.GroupId
  LEFT JOIN CRM..TPractitioner T2 ON T1.CRMContactId = T2.CRMContactId

  WHERE T1.CRMContactId in (SELECT CRMContactId FROM CRM..TCRMContact
			    WHERE (@FirstName <> '' AND @LastName = '' AND (FirstName LIKE '%' + @FirstName + '%')) OR --First Name only
			          (@FirstName = '' AND @LastName <> ''AND (LastName LIKE '%' + @LastName + '%')) OR	-- Last Name only
			          (@FirstName <> '' AND @LastName <> ''AND ((FirstName LIKE '%' + @FirstName + '%') AND (LastName LIKE '%' + @LastName + '%')))) /*First and Last Name*/ AND
	(T1.IndigoClientId = @IndigoClientId)
	AND T2.PractitionerId IS NULL	-- NON ADVISER USERS ONLY2

  ORDER BY [User!1!UserId], [Group!3!GroupId], [CRMContact!2!CRMContactId]

  FOR XML EXPLICIT

END




GO
