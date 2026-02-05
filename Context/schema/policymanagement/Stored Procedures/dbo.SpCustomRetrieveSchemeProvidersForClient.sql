SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveSchemeProvidersForClient] @TenantId bigint,@_UserId bigint,@ClientCRMContactId bigint  
AS  
  
DECLARE @IsSuperUser tinyint  
  
SET @IsSuperUser=(SELECT SuperUser FROM Administration..TUser WHERE UserId=@_UserId)  
IF ISNULL(@IsSuperUser,0)=0
BEGIN
	SET @IsSuperUser=(SELECT SuperViewer FROM Administration..TUser WHERE UserId=@_UserId)  
END

  
  
SELECT 1 AS Tag,  
NULL AS Parent,  
F.RefProdProviderId AS [Provider!1!RefProdProviderId],  
MIN(G.CorporateName) AS [Provider!1!ClientName],  
G.CRMContactId AS [Provider!1!CRMContactId]  
  
  
  
FROM CRM..TCRMContact A  
JOIN PolicyManagement..TGroupScheme B ON A.CRMContactId=B.OwnerCRMContactId  
JOIN PolicyManagement..TPolicyBusiness C ON B.PolicyBusinessId=C.PolicyBusinessId  
JOIN PolicyManagement..TPolicyDetail D ON C.PolicyDetailId=D.PolicyDetailId  
JOIN PolicyManagement..TPlanDescription E ON D.PlanDescriptionId=E.PlanDescriptionId  
JOIN PolicyManagement..TRefProdProvider F ON E.RefProdProviderId=F.RefProdProviderId  
JOIN CRM..TCRMContact G ON F.CRMContactId=G.CRMContactId  
  
  
  
WHERE A.IndClientId=@TenantId  
AND B.TenantId=@TenantId  
AND A.CRMContactId=@ClientCRMContactId  
AND (@IsSuperUser=1 OR A._OwnerId=@_UserId)  
  
Group By F.RefProdProviderId,G.CRMContactId  
  
ORDER BY [Provider!1!ClientName]  
  
FOR XML EXPLICIT  
  
GO
