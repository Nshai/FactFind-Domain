SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditMarketingCampaignRecipient]
	@StampUser varchar (255),
	@MarketingCampaignRecipientId bigint,
	@StampAction char(1)
AS

INSERT INTO TMarketingCampaignRecipientAudit (
  MarketingCampaignRecipientId
, TenantId
, ConcurrencyId
, MarketingCampaignId
, CRMContactId
, MessageId
, DateSent
, DateOpened
, DateClicked
, DateBounced
, DateUnsubscribed
, IsIncluded
, Status
, Name
, EmailAddress
, EmailHtml
, ClickCount
, OpenCount
, StampAction
, StampDateTime
, StampUser) 
Select   
MarketingCampaignRecipientId
, TenantId
, ConcurrencyId
, MarketingCampaignId
, CRMContactId
, MessageId
, DateSent
, DateOpened
, DateClicked
, DateBounced
, DateUnsubscribed
, IsIncluded
, Status
, Name
, EmailAddress
, EmailHtml
, ClickCount
, OpenCount
, @StampAction
, GetDate()
, @StampUser
FROM TMarketingCampaignRecipient
WHERE MarketingCampaignRecipientId = @MarketingCampaignRecipientId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
