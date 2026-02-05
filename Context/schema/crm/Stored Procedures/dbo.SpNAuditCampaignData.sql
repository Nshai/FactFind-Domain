SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCampaignData]
	@StampUser varchar (255),
	@CampaignDataId bigint,
	@StampAction char(1)
AS

INSERT INTO TCampaignDataAudit 
( CampaignId, Description, Cost, CampaignChannelId, ConcurrencyId, CampaignDataId, StampAction, StampDateTime, StampUser) 
Select CampaignId, Description, Cost, CampaignChannelId, ConcurrencyId, CampaignDataId, @StampAction, GetDate(), @StampUser
FROM TCampaignData
WHERE CampaignDataId = @CampaignDataId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
