SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveCampaignById]
@CampaignId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.CampaignId AS [Campaign!1!CampaignId], 
    T1.CampaignTypeId AS [Campaign!1!CampaignTypeId], 
    T1.IndigoClientId AS [Campaign!1!IndigoClientId], 
    ISNULL(T1.GroupId, '') AS [Campaign!1!GroupId], 
    T1.CampaignName AS [Campaign!1!CampaignName], 
    T1.ArchiveFG AS [Campaign!1!ArchiveFG], 
    T1.IsOrganisational AS [Campaign!1!IsOrganisational], 
    T1.ConcurrencyId AS [Campaign!1!ConcurrencyId]
  FROM TCampaign T1

  WHERE (T1.CampaignId = @CampaignId)

  ORDER BY [Campaign!1!CampaignId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
