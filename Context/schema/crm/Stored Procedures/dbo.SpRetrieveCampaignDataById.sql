SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveCampaignDataById]
@CampaignDataId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.CampaignDataId AS [CampaignData!1!CampaignDataId], 
    T1.CampaignId AS [CampaignData!1!CampaignId], 
    ISNULL(T1.Description, '') AS [CampaignData!1!Description], 
    ISNULL(CONVERT(varchar(24), T1.Cost), '') AS [CampaignData!1!Cost], 
    T1.ConcurrencyId AS [CampaignData!1!ConcurrencyId]
  FROM TCampaignData T1

  WHERE (T1.CampaignDataId = @CampaignDataId)

  ORDER BY [CampaignData!1!CampaignDataId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
