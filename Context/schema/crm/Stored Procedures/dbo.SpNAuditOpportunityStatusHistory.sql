SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditOpportunityStatusHistory]
	@StampUser varchar (255),
	@OpportunityStatusHistoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TOpportunityStatusHistoryAudit 
( OpportunityId, OpportunityStatusId, DateOfChange, ChangedByUserId, 
		CurrentStatusFG, ConcurrencyId, 
	OpportunityStatusHistoryId, StampAction, StampDateTime, StampUser) 
Select OpportunityId, OpportunityStatusId, DateOfChange, ChangedByUserId, 
		CurrentStatusFG, ConcurrencyId, 
	OpportunityStatusHistoryId, @StampAction, GetDate(), @StampUser
FROM TOpportunityStatusHistory
WHERE OpportunityStatusHistoryId = @OpportunityStatusHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
