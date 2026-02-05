SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditOpportunityPolicyBusiness]
	@StampUser varchar (255),
	@OpportunityPolicyBusinessId bigint,
	@StampAction char(1)
AS

INSERT INTO TOpportunityPolicyBusinessAudit 
( OpportunityId, PolicyBusinessId, ConcurrencyId, 
	OpportunityPolicyBusinessId, StampAction, StampDateTime, StampUser) 
Select OpportunityId, PolicyBusinessId, ConcurrencyId, 
	OpportunityPolicyBusinessId, @StampAction, GetDate(), @StampUser
FROM TOpportunityPolicyBusiness
WHERE OpportunityPolicyBusinessId = @OpportunityPolicyBusinessId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
