SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditMarketingCampaign]
	@StampUser varchar (255),
	@MarketingCampaignId bigint,
	@StampAction char(1)
AS

INSERT INTO TMarketingCampaignAudit (
MarketingCampaignId
, Name
, SenderEmail
, SenderName
, [Subject]
, CreatedDate
, CampaignSendingOption
, TenantId
, TemplateId
, Reportid
, RecipientCount
, CampaignSendDate
, ConcurrencyId
, StampAction
, StampDateTime
, StampUser
, TrackOpen
, TrackClicks
, TrackGoogleAnalytics) 
Select MarketingCampaignId
, Name
, SenderEmail
, SenderName
, [Subject]
, CreatedDate
, CampaignSendingOption
, TenantId
, TemplateId
, Reportid
, RecipientCount
, CampaignSendDate
, ConcurrencyId
, @StampAction
, GetDate()
, @StampUser
, TrackOpen
, TrackClicks
, TrackGoogleAnalytics
FROM TMarketingCampaign
WHERE MarketingCampaignId = @MarketingCampaignId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
