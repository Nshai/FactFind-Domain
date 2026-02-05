SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAdviceCasePlan]
	@StampUser varchar (255),
	@AdviceCasePlanId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCasePlanAudit 
( AdviceCaseId, PolicyBusinessId, ConcurrencyId, 
	AdviceCasePlanId, StampAction, StampDateTime, StampUser) 
Select AdviceCaseId, PolicyBusinessId, ConcurrencyId, 
	AdviceCasePlanId, @StampAction, GetDate(), @StampUser
FROM TAdviceCasePlan
WHERE AdviceCasePlanId = @AdviceCasePlanId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
