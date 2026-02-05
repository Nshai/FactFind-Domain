SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditNeedsAndPrioritiesQuestionAnswer]
	@StampUser varchar (255),
	@NeedsAndPrioritiesQuestionAnswerId bigint,
	@StampAction char(1)
AS

INSERT INTO [administration].[dbo].[TNeedsAndPrioritiesQuestionAnswerAudit]
       ([NeedsAndPrioritiesQuestionId]
       ,[Answer]
       ,[Ordinal]
	   ,[IsArchived]
       ,[ConcurrencyId]
       ,[NeedsAndPrioritiesQuestionAnswerId]
       ,[StampAction]
       ,[StampDateTime]
       ,[StampUser])
     Select
		NeedsAndPrioritiesQuestionId
		,Answer
		,Ordinal
		,IsArchived
		,ConcurrencyId
		,NeedsAndPrioritiesQuestionAnswerId
		,@StampAction
		,GetDate()
		,@StampUser
FROM [Administration].[dbo].[TNeedsAndPrioritiesQuestionAnswer]
WHERE NeedsAndPrioritiesQuestionAnswerId = @NeedsAndPrioritiesQuestionAnswerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
