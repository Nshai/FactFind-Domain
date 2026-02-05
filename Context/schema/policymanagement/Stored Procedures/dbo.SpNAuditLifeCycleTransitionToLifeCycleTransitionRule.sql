SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLifeCycleTransitionToLifeCycleTransitionRule]
	@StampUser varchar (255),
	@LifeCycleTransitionToLifeCycleTransitionRuleId bigint,
	@StampAction char(1)
AS

INSERT INTO TLifeCycleTransitionToLifeCycleTransitionRuleAudit 
( 
	LifeCycleTransitionToLifeCycleTransitionRuleId,
	LifeCycleTransitionId, 
	LifeCycleTransitionRuleId,
	ConcurrencyId, 
	StampAction, 
	StampDateTime, 
	StampUser
) 
Select 
	LifeCycleTransitionToLifeCycleTransitionRuleId,
	LifeCycleTransitionId, 
	LifeCycleTransitionRuleId,
	ConcurrencyId, 
	@StampAction, 
	GetDate(),
	@StampUser
FROM 
	TLifeCycleTransitionToLifeCycleTransitionRule
WHERE 
	LifeCycleTransitionToLifeCycleTransitionRuleId = @LifeCycleTransitionToLifeCycleTransitionRuleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
