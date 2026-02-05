SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditAdviceCaseStatusTransitionRule]
	@StampUser varchar (255),
	@AdviceCaseStatusTransitionRuleId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseStatusTransitionRuleAudit 
( AdviceCaseStatusChangeId, AdviceCaseStatusRuleId, ConcurrencyId, 
	AdviceCaseStatusTransitionRuleId, StampAction, StampDateTime, StampUser) 
Select AdviceCaseStatusChangeId, AdviceCaseStatusRuleId, ConcurrencyId, 
	AdviceCaseStatusTransitionRuleId, @StampAction, GetDate(), @StampUser
FROM TAdviceCaseStatusTransitionRule
WHERE AdviceCaseStatusTransitionRuleId = @AdviceCaseStatusTransitionRuleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
