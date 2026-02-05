SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomFindUser]  
@Username varchar(255)  
  
as  
  
begin  
  
SELECT   
1 as tag,  
NULL as parent,  
u.UserId as [User!1!UserId],  
i.IndigoClientId as [User!1!IndigoClientId],  
i.Identifier as [User!1!OrganisationName],  
re.RefEnvironmentId as [User!1!RefEnvironmentId],  
re.URL as [User!1!EnvironmentUrl]  
  
FROM   
TUserCombined u  
JOIN TIndigoClientCombined i ON i.Guid = u.IndigoClientGuid  
JOIN TRefEnvironment re ON re.RefEnvironmentId = i.RefEnvironmentId  
  
WHERE u.Identifier = @Username  

FOR XML EXPLICIT  
end

GO
