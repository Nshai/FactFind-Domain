SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[SpCustomRetrieveDelegateSession]  
@SessionId varchar(128)  
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
    T3.Status AS [User!1!Status],   
    T1.GroupId AS [User!1!GroupId],   
    ISNULL(T1.SyncPassword, '') AS [User!1!SyncPassword],   
    ISNULL(CONVERT(varchar(24), T1.ExpirePasswordOn, 120),'') AS [User!1!ExpirePasswordOn],   
    T1.SuperUser AS [User!1!SuperUser],   
    T1.SuperViewer AS [User!1!SuperViewer],   
    T1.FailedAccessAttempts AS [User!1!FailedAccessAttempts],   
    T1.WelcomePage AS [User!1!WelcomePage],   
    ISNULL(T1.CRMContactId, '') AS [User!1!CRMContactId],   
    ISNULL(T1.IndigoClientId, '') AS [User!1!IndigoClientId],   
    T1.SupportUserFg AS [User!1!SupportUserFg],   
    T1.RefUserTypeId AS [User!1!RefUserTypeId],      
    T1.ConcurrencyId AS [User!1!ConcurrencyId],  
    T2.UserSessionId AS [User!1!UserSessionId],   
    ISNULL(T2.SessionId, '') AS [User!1!SessionId],  
    ISNULL(T2.DelegateId, '') AS [User!1!DelegateId],   
    ISNULL(T2.DelegateSessionId, '') AS [User!1!DelegateSessionId],   
    T2.[Sequence] AS [User!1!Sequence],   
    ISNULL(T2.IP, '') AS [User!1!IP],   
    ISNULL(CONVERT(varchar(24), T2.LastAccess, 120),'') AS [User!1!LastAccess],   
    ISNULL(T2.Search, '') AS [User!1!Search],   
    '' AS [User!1!Recent],   
    '' AS [User!1!RecentWork],   
    T2.ConcurrencyId AS [User!1!SessionConcurrencyId],  
    T3.UserId AS [User!1!ActualUserId]  
  FROM   
 TUser T1  
 JOIN TUserSession T2 ON T2.DelegateId = T1.UserId  
 JOIN TUser T3 ON T3.UserId = T2.UserId  
  WHERE   
 T2.DelegateSessionId = @SessionId  
   
  FOR XML EXPLICIT  
  
END  
RETURN (0)

GO
