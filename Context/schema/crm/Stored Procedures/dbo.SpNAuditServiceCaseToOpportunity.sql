SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditServiceCaseToOpportunity]
	@ServiceCaseToOpportunityId bigint,	
	@StampAction char(1),
	@StampUser varchar (255)

AS

INSERT INTO TServiceCaseToOpportunityAudit 
	(ServiceCaseToOpportunityId, OpportunityId, AdviceCaseId, TenantId, ConcurrencyId,StampAction, StampDateTime, StampUser)
SELECT  ServiceCaseToOpportunityId, OpportunityId, AdviceCaseId, TenantId, ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM TServiceCaseToOpportunity
WHERE ServiceCaseToOpportunityId = @ServiceCaseToOpportunityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
