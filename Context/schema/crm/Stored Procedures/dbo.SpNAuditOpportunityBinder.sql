SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditOpportunityBinder]
	@StampUser varchar (255),
	@OpportunityBinderId bigint,
	@StampAction char(1)
AS

INSERT INTO TOpportunityBinderAudit ( 
			[BinderId],
			[OpportunityId],
			[CreatedDate],
			[ConcurrencyId],
			[OpportunityBinderId],
			[StampAction] ,
			[StampDateTime] ,
			[StampUser] 
) 
	
SELECT		[BinderId],
			[OpportunityId],
			[CreatedDate],
			[ConcurrencyId],
			[OpportunityBinderId],
			@StampAction, 
			GetDate(), 
			@StampUser	
FROM 
		TOpportunityBinder
WHERE 
		OpportunityBinderId = @OpportunityBinderId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
