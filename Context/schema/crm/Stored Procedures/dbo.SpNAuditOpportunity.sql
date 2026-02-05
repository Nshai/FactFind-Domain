SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditOpportunity]
	@StampUser varchar (255),
	@OpportunityId bigint,
	@StampAction char(1)
AS

INSERT INTO TOpportunityAudit 
( IndigoClientId, OpportunityTypeId, CreatedDate, 
		Amount, AmountOngoing, Probability, PractitionerId, IntroducerId, 
		IsClosed, ClosedDate, CampaignDataId, Identifier, 
		SequentialRef, AdviserAssignedByUserId, ConcurrencyId, ClientAssetValue,
		PropositionTypeId, TargetClosedDate, [OpportunityMigrationRef], OpportunityId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, OpportunityTypeId, CreatedDate, 
		Amount, AmountOngoing, Probability, PractitionerId, IntroducerId, 
		IsClosed, ClosedDate, CampaignDataId, Identifier, 
		SequentialRef, AdviserAssignedByUserId, ConcurrencyId, ClientAssetValue,
		PropositionTypeId, TargetClosedDate, [OpportunityMigrationRef], OpportunityId, @StampAction, GetDate(), @StampUser
FROM TOpportunity
WHERE OpportunityId = @OpportunityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
