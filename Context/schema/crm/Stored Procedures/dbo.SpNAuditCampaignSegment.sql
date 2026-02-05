SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditCampaignSegment]
	@StampUser varchar (255),
	@CampaignSegmentId bigint,
	@StampAction char(1)
AS

INSERT INTO TCampaignSegmentAudit (
  CampaignSegmentId
, MarketingCampaignId
, TenantId
, SegmentOption
, SegmentFilters
, ConcurrencyId
, StampAction
, StampDateTime
, StampUser) 
Select MarketingCampaignId
  CampaignSegmentId
, MarketingCampaignId
, TenantId
, SegmentOption
, SegmentFilters
, ConcurrencyId
, @StampAction
, GetDate()
, @StampUser
FROM TCampaignSegment
WHERE CampaignSegmentId = @CampaignSegmentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
