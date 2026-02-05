SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditCampaignChannel]
	@StampUser varchar (255),
	@CampaignChannelId bigint,
	@StampAction char(1)
AS

INSERT INTO TCampaignChannelAudit 
( IndigoClientId, CampaignChannel, ArchiveFg, ConcurrencyId, CampaignChannelId, StampAction, StampDateTime, StampUser) 
SELECT IndigoClientId, CampaignChannel, ArchiveFg, ConcurrencyId, CampaignChannelId, @StampAction, GetDate(), @StampUser
FROM TCampaignChannel
WHERE CampaignChannelId = @CampaignChannelId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
