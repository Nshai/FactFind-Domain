SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAdviceCaseRetainer]
	@StampUser varchar (255),
	@AdviceCaseRetainerId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseRetainerAudit 
( AdviceCaseId, RetainerId, ConcurrencyId, 
	AdviceCaseRetainerId, StampAction, StampDateTime, StampUser) 
Select AdviceCaseId, RetainerId, ConcurrencyId, 
	AdviceCaseRetainerId, @StampAction, GetDate(), @StampUser
FROM TAdviceCaseRetainer
WHERE AdviceCaseRetainerId = @AdviceCaseRetainerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
