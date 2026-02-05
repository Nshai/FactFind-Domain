SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchCorporateClientsWithGroupSchemes] @TenantId bigint,@_UserId bigint    
AS    
    
DECLARE @IsSuperUser tinyint
    
SET @IsSuperUser=(SELECT SuperUser FROM Administration..TUser WHERE UserId=@_UserId)    
IF @IsSuperUser=0  
BEGIN  
 SET @IsSuperUser=(SELECT SuperViewer FROM Administration..TUser WHERE UserId=@_UserId)    
END  
    
SELECT 1 AS Tag,    
NULL AS Parent,    
A.CRMContactId AS [Client!1!CRMContactId],    
MIN(A.CorporateName) AS [Client!1!ClientName]    
    
    
FROM CRM..TCRMContact A    
JOIN PolicyManagement..TGroupScheme B ON A.CRMContactId=B.OwnerCRMContactId    
    
    
    
WHERE A.IndClientId=@TenantId    
AND B.TenantId=@TenantId  
AND ISNULL(A.CorporateName,'')!=''  
AND (@IsSuperUser=1 OR A._OwnerId=@_UserId)    
    
Group By A.CRMContactId    
    
ORDER BY [Client!1!ClientName]    
    
FOR XML EXPLICIT    

GO
