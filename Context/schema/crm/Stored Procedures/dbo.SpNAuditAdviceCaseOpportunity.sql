SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAdviceCaseOpportunity]
	@StampUser varchar (255),
	@AdviceCaseOpportunityId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseOpportunityAudit 
( AdviceCaseId, OpportunityId, ConcurrencyId, 
	AdviceCaseOpportunityId, StampAction, StampDateTime, StampUser) 
Select AdviceCaseId, OpportunityId, ConcurrencyId, 
	AdviceCaseOpportunityId, @StampAction, GetDate(), @StampUser
FROM TAdviceCaseOpportunity
WHERE AdviceCaseOpportunityId = @AdviceCaseOpportunityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
