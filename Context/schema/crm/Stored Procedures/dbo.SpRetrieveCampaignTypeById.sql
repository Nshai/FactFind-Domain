SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveCampaignTypeById]
@CampaignTypeId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.CampaignTypeId AS [CampaignType!1!CampaignTypeId], 
    T1.IndigoClientId AS [CampaignType!1!IndigoClientId], 
    T1.CampaignType AS [CampaignType!1!CampaignType], 
    T1.ArchiveFG AS [CampaignType!1!ArchiveFG], 
    T1.ConcurrencyId AS [CampaignType!1!ConcurrencyId]
  FROM TCampaignType T1

  WHERE (T1.CampaignTypeId = @CampaignTypeId)

  ORDER BY [CampaignType!1!CampaignTypeId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
