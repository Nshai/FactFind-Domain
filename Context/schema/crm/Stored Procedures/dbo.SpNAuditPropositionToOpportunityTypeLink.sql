SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPropositionToOpportunityTypeLink]
	@StampUser varchar (255),
	@PropositionToOpportunityTypeLinkId bigint,
	@StampAction char(1)
AS

INSERT INTO TPropositionToOpportunityTypeLinkAudit 
( PropositionToOpportunityTypeLinkId, PropositionTypeId, OpportunityTypeId, ConcurrencyId, 
	StampAction, StampDateTime, StampUser) 
Select PropositionToOpportunityTypeLinkId, PropositionTypeId, OpportunityTypeId, ConcurrencyId, 
    @StampAction, GetDate(), @StampUser
FROM TPropositionToOpportunityTypeLink
WHERE PropositionToOpportunityTypeLinkId = @PropositionToOpportunityTypeLinkId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
