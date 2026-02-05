SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchUserByNameAndIdentifier]    
@Identifier varchar (64)='',    
@FirstName varchar(50) = '',    
@LastName varchar(50) = '',    
@GroupId bigint=0,    
@Status varchar(50)='',    
@Email varchar(128)='',    
@IndigoClientId bigint,    
@_TopN int = 0  
/*  
@Identifier1 varchar (64)='',    
@FirstName1 varchar(50) = '',    
@LastName1 varchar(50) = '',    
@GroupId1 bigint=0,    
@Status1 varchar(50)='',    
@Email1 varchar(128)='',    
@IndigoClientId1 bigint,    
@_TopN1 int = 0    */
With Recompile  
AS    
    /*
Declare @Identifier varchar (64),    
@FirstName varchar(50),    
@LastName varchar(50) ,    
@GroupId bigint,    
@Status varchar(50),    
@Email varchar(128),    
@IndigoClientId bigint,    
@_TopN int   
  
Select @Identifier = @Identifier1,  
@FirstName = @FirstName1,  
@LastName = @LastName1,  
@GroupId = @GroupId1,  
@Status = @Status1,  
@Email = @Email1,  
@IndigoClientId = @IndigoClientId1,  
@_TopN = @_TopN1  
  
  */
  
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
    NULL AS [Group!3!ConcurrencyId],    
    NULL AS [Membership!4!MembershipId],     
    NULL AS [Membership!4!UserId],     
    NULL AS [Membership!4!RoleId],     
    NULL AS [Membership!4!ConcurrencyId],    
    NULL AS [Role!5!RoleId],    
    NULL AS [Role!5!Identifier],    
    NULL AS [Role!5!GroupingId],    
    NULL AS [Role!5!SuperUser],    
    NULL AS [Role!5!IndigoClientId],    
    NULL AS [Role!5!ConcurrencyId]    
  FROM TUser T1 With(NoLock)    
  INNER JOIN [CRM].[dbo].TCRMContact T2  With(NoLock)    
 ON T1.CRMContactId=T2.CRMContactId    
   WHERE  
 T1.RefUserTypeId = 1 AND    
 (T2.FirstName LIKE '%' + @Firstname + '%' Or @Firstname='') AND    
 (T2.LastName LIKE '%' + @Lastname + '%' Or @Lastname='') AND    
 (T1.Identifier LIKE '%' + @Identifier + '%' OR @Identifier='') AND    
 (T1.Status LIKE '%' + @Status + '%' OR @Status='')AND    
 (T1.GroupId=@GroupId OR @GroupId=0)AND    
 (T1.Email LIKE '%' + @Email + '%' OR @Email='')AND      
 (T1.IndigoClientId = @IndigoClientId)    
    
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
  FROM [CRM].[dbo].TCRMContact T2 With(NoLock)    
  INNER JOIN TUser T1 With(NoLock)    
 ON T2.CRMContactId = T1.CRMContactId    
  WHERE    
  (T2.FirstName LIKE '%' + @Firstname + '%' Or @Firstname='') AND    
  (T2.LastName LIKE '%' + @Lastname + '%' Or @Lastname='') AND    
  (T1.Identifier LIKE '%' + @Identifier + '%' OR @Identifier='') AND    
  (T1.Status LIKE '%' + @Status + '%' OR @Status='')AND    
  (T1.Email LIKE '%' + @Email + '%' OR @Email='')AND     
  (T1.GroupId=@GroupId OR @GroupId=0)AND    
  T1.RefUserTypeId = 1 AND  
  (T1.IndigoClientId = @IndigoClientId)    
    
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
    T3.ConcurrencyId,    
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
  FROM TGroup T3 With(NoLock)    
  INNER JOIN TUser T1 With(NoLock)    
 ON T3.GroupId = T1.GroupId    
  INNER JOIN [CRM].[dbo].TCRMContact T2 With(NoLock)    
 ON T1.CRMContactId=T2.CRMContactId    
    
  WHERE     
 (T2.FirstName LIKE '%' + @Firstname + '%' Or @Firstname='') AND    
 (T2.LastName LIKE '%' + @Lastname + '%' Or @Lastname='') AND    
 (T1.Identifier LIKE '%' + @Identifier + '%' OR @Identifier='') AND    
 (T1.Status LIKE '%' + @Status + '%' OR @Status='')AND    
 (T1.Email LIKE '%' + @Email + '%' OR @Email='')AND    
 (T1.GroupId=@GroupId OR @GroupId=0)AND    
 T1.RefUserTypeId = 1 AND  
 (T1.IndigoClientId = @IndigoClientId)    
    
    
  UNION ALL    
    
  SELECT    
    4 AS Tag,    
    1 AS Parent,    
    T1.UserId AS [User!1!UserId],     
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
    T4.MembershipId,    
    T4.UserId,    
    T4.RoleId,    
    T4.ConcurrencyId,    
    NULL,     
    NULL,    
    NULL,     
    NULL,     
    NULL,     
    NULL    
    
  FROM TGroup T3 With(NoLock)    
  INNER JOIN TUser T1 With(NoLock)    
 ON T3.GroupId = T1.GroupId    
  INNER JOIN [CRM].[dbo].TCRMContact T2 With(NoLock)    
 ON T1.CRMContactId=T2.CRMContactId    
  JOIN TMembership T4  With(NoLock)    
 ON T1.UserId = T4.UserId    
    
  WHERE     
 (T2.FirstName LIKE '%' + @Firstname + '%' Or @Firstname='') AND    
 (T2.LastName LIKE '%' + @Lastname + '%' Or @Lastname='') AND    
 (T1.Identifier LIKE '%' + @Identifier + '%' OR @Identifier='') AND    
 (T1.Status LIKE '%' + @Status + '%' OR @Status='')AND    
 (T1.Email LIKE '%' + @Email + '%' OR @Email='')AND    
 (T1.GroupId=@GroupId OR @GroupId=0)AND    
 T1.RefUserTypeId = 1 AND  
 (T1.IndigoClientId = @IndigoClientId)    
    
  UNION ALL    
    
  SELECT    
    5 AS Tag,    
    4 AS Parent,    
    T1.UserId AS [User!1!UserId],     
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
    T4.MembershipId,    
    NULL,    
    NULL,    
    NULL,    
    T5.RoleId,    
    ISNULL(T5.Identifier,''),    
    T5.GroupingId,    
    T5.SuperUser,    
    T5.IndigoClientId,    
    T5.ConcurrencyId    
  FROM TGroup T3 With(NoLock)    
  INNER JOIN TUser T1 With(NoLock)    
 ON T3.GroupId = T1.GroupId    
  INNER JOIN [CRM].[dbo].TCRMContact T2 With(NoLock)    
 ON T1.CRMContactId=T2.CRMContactId    
   JOIN TMembership T4  With(NoLock)    
 ON T1.UserId = T4.UserId    
   JOIN TRole T5  With(NoLock)    
 ON T5.RoleId = T4.RoleId    
    
  WHERE     
 (T2.FirstName LIKE '%' + @Firstname + '%' Or @Firstname='') AND    
 (T2.LastName LIKE '%' + @Lastname + '%' Or @Lastname='') AND    
 (T1.Identifier LIKE '%' + @Identifier + '%' OR @Identifier='') AND    
 (T1.Status LIKE '%' + @Status + '%' OR @Status='')AND    
 (T1.Email LIKE '%' + @Email + '%' OR @Email='')AND    
 (T1.GroupId=@GroupId OR @GroupId=0)AND    
 T1.RefUserTypeId = 1 AND  
 (T1.IndigoClientId = @IndigoClientId)    
    
  ORDER BY [User!1!UserId], [Group!3!GroupId], [CRMContact!2!CRMContactId],[Membership!4!MembershipId],[Role!5!RoleId]    
  FOR XML EXPLICIT     
    
  IF (@_TopN > 0) SET ROWCOUNT 0    
    
END    
  
GO
