SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditNeedsAndPrioritiesQuestionTag]
	@StampUser varchar (255),
	@NeedsAndPrioritiesQuestionTagId bigint,
	@StampAction char(1)
AS

INSERT INTO [TNeedsAndPrioritiesQuestionTagAudit] (
	NeedsAndPrioritiesQuestionTagId, NeedsAndPrioritiesQuestionId, Name, TenantId, StampAction, StampDateTime, StampUser)
SELECT
	NeedsAndPrioritiesQuestionTagId, NeedsAndPrioritiesQuestionId, Name, TenantId, @StampAction, GETDATE(), @StampUser
FROM 
	[Administration].[dbo].[TNeedsAndPrioritiesQuestionTag]
WHERE 
	NeedsAndPrioritiesQuestionTagId = @NeedsAndPrioritiesQuestionTagId

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)
GO