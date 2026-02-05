SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValRequest]
	@StampUser varchar (255),
	@ValRequestId bigint,
	@StampAction char(1)
AS

INSERT INTO TValRequestAudit 
( PractitionerId, CRMContactId, PolicyBusinessId, PlanValuationId, 
		ValuationType, RequestXML, RequestedUserId, RequestedDate, ValRequestCorrelationId, LoggedOnUserId,
		RequestStatus, ConcurrencyId, 
	ValRequestId, StampAction, StampDateTime, StampUser) 
Select PractitionerId, CRMContactId, PolicyBusinessId, PlanValuationId, 
		ValuationType, RequestXML, RequestedUserId, RequestedDate, ValRequestCorrelationId, LoggedOnUserId,
		RequestStatus, ConcurrencyId, 
	ValRequestId, @StampAction, GetDate(), @StampUser
FROM TValRequest
WHERE ValRequestId = @ValRequestId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
