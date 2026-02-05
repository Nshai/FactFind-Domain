SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpNAuditOpportunityCustomer
	@OpportunityCustomerId bigint,	
	@StampAction char(1),
	@StampUser varchar (255)

AS

INSERT INTO TOpportunityCustomerAudit 
	(OpportunityCustomerId, OpportunityId, PartyId, ConcurrencyId,StampAction, StampDateTime, StampUser)
SELECT  OpportunityCustomerId, OpportunityId, PartyId, ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM TOpportunityCustomer
WHERE OpportunityCustomerId = @OpportunityCustomerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
