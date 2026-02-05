SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].SpCustomRetrieveCampaignTypesAndCampaigns       
 @IndigoClientId bigint,       
 @GroupId bigint      
AS      
SELECT  DISTINCT    
    1 AS Tag,      
    NULL AS Parent,      
    T1.CampaignTypeId AS [CampaignType!1!CampaignTypeId],       
    IsNull(T1.CampaignType,'') AS [CampaignType!1!CampaignType],      
    T1.IndigoClientId AS [CampaignType!1!IndigoClientId],       
    Null AS [Campaign!2!CampaignId],      
    Null AS [Campaign!2!CampaignName],      
    Null AS [Campaign!2!IndigoClientId],       
    Null AS [Campaign!2!GroupId],       
    Null AS [Campaign!2!IsOrganisational],      
    Null AS [Campaign!2!CampaignTypeId]      
FROM       
 TCampaignType T1      
 JOIN CRM.dbo.TCampaign  T2 On T1.CampaignTypeId = T2.CampaignTypeId     
WHERE      
 --T1.IndigoClientId = @IndigoClientId      
 --AND T1.ArchiveFG = 0      
T1.ArchiveFG = 0 And T2.ArchiveFG = 0      
 AND T1.IndigoClientId = @IndigoClientId      
 AND (      
  (T2.IsOrganisational = 1 AND T2.GroupId IS NULL)       
  OR       
  (T2.IsOrganisational = 0 AND T2.GroupId = @GroupId)      
 )      
      
UNION ALL      
      
SELECT      
 2 AS Tag,      
 1 AS Parent,      
 T1.CampaignTypeId,      
 NULL,      
 NULL,      
 T2.CampaignId,       
 IsNull(T2.CampaignName,''),      
 T2.IndigoClientId,      
 IsNull(T2.GroupId,0),      
 T2.IsOrganisational,      
 T2.CampaignTypeId      
FROM       
 CRM.dbo.TCampaignType T1      
 JOIN CRM.dbo.TCampaign  T2 On T1.CampaignTypeId = T2.CampaignTypeId      
WHERE      
 T1.ArchiveFG = 0 And T2.ArchiveFG = 0      
 AND T1.IndigoClientId = @IndigoClientId      
 AND (      
  (T2.IsOrganisational = 1 AND T2.GroupId IS NULL)       
  OR       
  (T2.IsOrganisational = 0 AND T2.GroupId = @GroupId)      
 )      
ORDER BY       
 [CampaignType!1!CampaignTypeId], [Campaign!2!CampaignTypeId]      
FOR XML EXPLICIT 
GO
