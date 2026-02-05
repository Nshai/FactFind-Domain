SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCampaignType]
	@StampUser varchar (255),
	@CampaignTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TCampaignTypeAudit 
( IndigoClientId, CampaignType, ArchiveFG, ConcurrencyId, 
		
	CampaignTypeId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, CampaignType, ArchiveFG, ConcurrencyId, 
		
	CampaignTypeId, @StampAction, GetDate(), @StampUser
FROM TCampaignType
WHERE CampaignTypeId = @CampaignTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
