SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SPCustomGetUserForLoginWithIndigoClient]    
@Identifier varchar(64)  
AS  
  
/*  
 MT: 03 Jan 2003: Code optimised for Fast Logon. No XML Hierarchy is needed  
 AF: 14 Jan 2003: Added CRMContactId to returned xml  
 AAHM: 02 Nov 2005: Added the User Hash Data  
 AJF: 13 Oct 06: Added WITH(NOLOCK) and removed unused text fields  
 MT: 31 Nov 06: Added RefUserTypeId  
*/  
  
  
 SELECT  
    1 AS Tag,  
    NULL AS Parent,  
    T1.UserId AS [User!1!UserId],   
    T1.Identifier AS [User!1!Identifier],   
    T1.Password AS [User!1!Password],   
    ISNULL(T1.PasswordHistory, '') AS [User!1!PasswordHistory],   
    T1.Email AS [User!1!Email],       
    T1.Status AS [User!1!Status],   
    T1.RefUserTypeId AS [User!1!RefUserTypeId],   
    ISNULL(T1.SyncPassword, '') AS [User!1!SyncPassword],   
    ISNULL(CONVERT(varchar(24), T1.ExpirePasswordOn, 120),'') AS [User!1!ExpirePasswordOn],   
    T1.SuperUser AS [User!1!SuperUser],   
    T1.SuperViewer AS [User!1!SuperViewer],   
    T1.FailedAccessAttempts AS [User!1!FailedAccessAttempts],   
    ISNULL(T1.CRMContactId,'') as [User!1!CRMContactId],  
    ISNULL(T1.IndigoClientId, '') AS [User!1!IndigoClientId],  
    '' AS [User!1!SearchData],   
    '' AS [User!1!RecentData],    
    '' AS [User!1!RecentWork],  
    T1.SupportUserFg AS [User!1!SupportUserFg],   
    T1.ActiveRole AS [User!1!ActiveRole],
    T1.ConcurrencyId AS [User!1!ConcurrencyId],   
    T2.Identifier AS [User!1!IndigoClientIdentifier],   
    T2.Status AS [User!1!IndigoClientStatus],  
    T3.HashValue As [User!1!HashValue]

  
FROM TUser T1 WITH(NOLOCK)  
  INNER JOIN TIndigoClient T2 WITH(NOLOCK)   ON T2.IndigoClientId = T1.IndigoClientId  
  LEFT JOIN TUserHash T3 WITH(NOLOCK)   ON T1.USerId=T3.UserId  
  
  WHERE (T1.Identifier = @Identifier)  
  
--  ORDER BY [User!1!UserId]  
  
  FOR XML EXPLICIT

GO
