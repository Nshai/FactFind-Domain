SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditOpportunityStatus]
	@StampUser varchar (255),
	@OpportunityStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TOpportunityStatusAudit 
( OpportunityStatusName, IndigoClientId, InitialStatusFG, ArchiveFG, 
		AutoCloseOpportunityFg, OpportunityStatusTypeId, ConcurrencyId, 
	OpportunityStatusId, StampAction, StampDateTime, StampUser) 
Select OpportunityStatusName, IndigoClientId, InitialStatusFG, ArchiveFG, 
		AutoCloseOpportunityFg, OpportunityStatusTypeId, ConcurrencyId, 
	OpportunityStatusId, @StampAction, GetDate(), @StampUser
FROM TOpportunityStatus
WHERE OpportunityStatusId = @OpportunityStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
