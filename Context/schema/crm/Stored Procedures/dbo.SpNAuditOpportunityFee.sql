SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditOpportunityFee]
	@StampUser varchar (255),
	@OpportunityFeeId bigint,
	@StampAction char(1)
AS

INSERT INTO TOpportunityFeeAudit 
( OpportunityId, FeeId, ConcurrencyId, 
	OpportunityFeeId, StampAction, StampDateTime, StampUser) 
Select OpportunityId, FeeId, ConcurrencyId, 
	OpportunityFeeId, @StampAction, GetDate(), @StampUser
FROM TOpportunityFee
WHERE OpportunityFeeId = @OpportunityFeeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
