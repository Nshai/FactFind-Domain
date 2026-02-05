CREATE PROCEDURE [dbo].[SpNAuditNeedsAndPrioritiesQuestionLogic]
	@StampUser varchar (255),
	@NeedsAndPrioritiesQuestionLogicId int,
	@StampAction char(1)
AS

INSERT INTO [TNeedsAndPrioritiesQuestionLogicAudit] (
	NeedsAndPrioritiesQuestionLogicId, NeedsAndPrioritiesQuestionId, NeedsAndPrioritiesParentQuestionId, LogicTypeId, AnswerValue, ConcurrencyId, TenantId, StampAction, StampDateTime, StampUser)
SELECT
	NeedsAndPrioritiesQuestionLogicId, NeedsAndPrioritiesQuestionId, NeedsAndPrioritiesParentQuestionId, LogicTypeId, AnswerValue, ConcurrencyId, TenantId, @StampAction, GETDATE(), @StampUser
FROM 
	[Administration].[dbo].[TNeedsAndPrioritiesQuestionLogic]
WHERE 
	NeedsAndPrioritiesQuestionLogicId = @NeedsAndPrioritiesQuestionLogicId

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)
GO