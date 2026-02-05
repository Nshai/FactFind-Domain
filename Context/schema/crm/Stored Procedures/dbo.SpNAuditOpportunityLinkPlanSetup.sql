SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpNAuditOpportunityLinkPlanSetup
	@StampUser varchar (255),
	@OpportunityLinkPlanSetupId bigint,
	@StampAction char(1)
AS

INSERT INTO TOpportunityLinkPlanSetupAudit 
(		
	OpportunityLinkPlanSetupId, AllowLinkToRelatedClients, HideMigratedPlans, IndigoClientId, ConcurrencyId,
	StampAction, StampDateTime, StampUser
)
SELECT OpportunityLinkPlanSetupId,	AllowLinkToRelatedClients, HideMigratedPlans, IndigoClientId, ConcurrencyId,
		@StampAction, GetDate(), @StampUser
FROM TOpportunityLinkPlanSetup
WHERE OpportunityLinkPlanSetupId = @OpportunityLinkPlanSetupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)



GO
