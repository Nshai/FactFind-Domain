SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAdviceCaseStatusChange]
	@StampUser varchar (255),
	@AdviceCaseStatusChangeId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseStatusChangeAudit 
( IndigoClientId, AdviceCaseStatusIdFrom, AdviceCaseStatusIdTo, ConcurrencyId, 
		
	AdviceCaseStatusChangeId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, AdviceCaseStatusIdFrom, AdviceCaseStatusIdTo, ConcurrencyId, 
		
	AdviceCaseStatusChangeId, @StampAction, GetDate(), @StampUser
FROM TAdviceCaseStatusChange
WHERE AdviceCaseStatusChangeId = @AdviceCaseStatusChangeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
