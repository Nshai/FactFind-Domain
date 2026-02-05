SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditRefDeferredReasonByMaxId]
	@StampUser varchar (255),
	@MaxId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefDeferredReasonAudit 
( DeferredReason, ConcurrencyId, 
	RefDeferredReasonId, StampAction, StampDateTime, StampUser) 
Select DeferredReason, ConcurrencyId, 
	RefDeferredReasonId, @StampAction, GetDate(), @StampUser
FROM TRefDeferredReason
WHERE RefDeferredReasonId > @MaxId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
