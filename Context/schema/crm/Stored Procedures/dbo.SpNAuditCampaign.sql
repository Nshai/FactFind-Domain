SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCampaign]
	@StampUser varchar (255),
	@CampaignId bigint,
	@StampAction char(1)
AS

INSERT INTO TCampaignAudit 
( CampaignTypeId, IndigoClientId, GroupId, CampaignName, 
		ArchiveFG, IsOrganisational, ConcurrencyId, 
	CampaignId, StampAction, StampDateTime, StampUser) 
Select CampaignTypeId, IndigoClientId, GroupId, CampaignName, 
		ArchiveFG, IsOrganisational, ConcurrencyId, 
	CampaignId, @StampAction, GetDate(), @StampUser
FROM TCampaign
WHERE CampaignId = @CampaignId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
