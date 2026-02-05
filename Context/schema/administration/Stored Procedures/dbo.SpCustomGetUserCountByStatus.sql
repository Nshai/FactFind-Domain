SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetUserCountByStatus]  
@Status varchar(64),  
@IndigoClientId bigint  
  
AS  
  
BEGIN  
  
SELECT   
1 as tag,  
NULL as parent,  
COUNT(*) AS [User!1!UserCount]  
  
FROM TUSER  
  
WHERE IndigoClientId = @IndigoClientId  
AND Status like @status + '%'  
AND SupportUserFg = 0  
AND RefUserTypeId = 1
FOR XML EXPLICIT  
  
END  
GO
