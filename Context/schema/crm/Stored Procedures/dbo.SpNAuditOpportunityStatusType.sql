SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditOpportunityStatusType]
	@StampUser varchar (255),
	@OpportunityStatusTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TOpportunityStatusTypeAudit 
( Identifier, Archive, ConcurrencyId, 
	OpportunityStatusTypeId, StampAction, StampDateTime, StampUser) 
Select Identifier, Archive, ConcurrencyId, 
	OpportunityStatusTypeId, @StampAction, GetDate(), @StampUser
FROM TOpportunityStatusType
WHERE OpportunityStatusTypeId = @OpportunityStatusTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
