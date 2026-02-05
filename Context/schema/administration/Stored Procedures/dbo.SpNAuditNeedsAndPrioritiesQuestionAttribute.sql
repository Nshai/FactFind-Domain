CREATE PROCEDURE [dbo].[SpNAuditNeedsAndPrioritiesQuestionAttribute]
	@StampUser varchar (255),
	@NeedsAndPrioritiesQuestionAttributeId int,
	@StampAction char(1)
AS

INSERT INTO [TNeedsAndPrioritiesQuestionAttributeAudit] (
	NeedsAndPrioritiesQuestionAttributeId, NeedsAndPrioritiesQuestionId, Name, Value, ConcurrencyId, TenantId, StampAction, StampDateTime, StampUser)
SELECT
	NeedsAndPrioritiesQuestionAttributeId, NeedsAndPrioritiesQuestionId, Name, Value, ConcurrencyId, TenantId, @StampAction, GETDATE(), @StampUser
FROM 
	[Administration].[dbo].[TNeedsAndPrioritiesQuestionAttribute]
WHERE 
	NeedsAndPrioritiesQuestionAttributeId = @NeedsAndPrioritiesQuestionAttributeId

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)
GO