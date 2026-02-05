SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveUserByCertificate]  
@SerialNumber varchar(255)  
  
AS  
  
BEGIN  
 SELECT  
 1 AS Tag,  
 NULL AS Parent,  
 u.UserId as [User!1!UserId],  
 u2.CRMContactId as [User!1!CRMContactId],  
 u.Identifier as [User!1!Identifier],  
 u2.Password as [User!1!Password]  
   
 FROM TUserCombined u WITH (NOLOCK) 
 --JOIN TCertificate c ON c.UserId = u.UserId  
 LEFT JOIN TUser u2 WITH (NOLOCK) ON u2.guid = u.guid  
  
 WHERE u.unipassSerialNbr = @SerialNumber  
  
 FOR XML EXPLICIT  
  
END  
  
  
  
GO
