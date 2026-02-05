SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchUserReturnFullName]
@Identifier varchar (64)='',  
@FirstName varchar(50) = '',  
@LastName varchar(50) = '',  
@GroupId bigint=0,  
@Status varchar(50)='',  
@Email varchar(128)='',  
@IndigoClientId bigint,  
@_TopN int = 0  
AS  
  
BEGIN  
 SELECT  
  1 AS Tag,  
  NULL AS Parent,  
  TU.UserId AS [User!1!UserId],   
  TU.Identifier AS [User!1!Identifier],  
  TC.FirstName + ' ' + TC.LastName AS [User!1!UserName],  
  TG.Identifier AS [User!1!Group]  
 FROM  
  TUser TU  
  JOIN CRM..TCRMContact TC ON TC.CRMContactId = TU.CRMContactId  
  JOIN TGroup TG ON TG.GroupId = TU.GroupId  
 WHERE   
  (TC.FirstName LIKE '%' + @Firstname + '%' Or @Firstname='') AND  
  (TC.LastName LIKE '%' + @Lastname + '%' Or @Lastname='') AND  
  (TU.Identifier LIKE '%' + @Identifier + '%' OR @Identifier='') AND  
  (TU.Status LIKE '%' + @Status + '%' OR @Status='')AND  
  (TU.Email LIKE '%' + @Email + '%' OR @Email='')AND  
  (TU.GroupId=@GroupId OR @GroupId=0)AND
  TU.RefUserTypeId = 1 AND  
  (TU.IndigoClientId = @IndigoClientId)  
  
 FOR XML EXPLICIT  
END  
GO
