SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditOpportunityObjective]
	@StampUser varchar (255),
	@OpportunityObjectiveId bigint,
	@StampAction char(1)
AS

INSERT INTO TOpportunityObjectiveAudit 
( OpportunityId, ObjectiveId, ConcurrencyId, 
	OpportunityObjectiveId, StampAction, StampDateTime, StampUser) 
Select OpportunityId, ObjectiveId, ConcurrencyId, 
	OpportunityObjectiveId, @StampAction, GetDate(), @StampUser
FROM TOpportunityObjective
WHERE OpportunityObjectiveId = @OpportunityObjectiveId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
