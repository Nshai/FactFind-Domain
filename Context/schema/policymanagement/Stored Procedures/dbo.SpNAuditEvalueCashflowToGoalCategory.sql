SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditEvalueCashflowToGoalCategory]
	@StampUser varchar (255),
	@EvalueCashflowToGoalCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvalueCashflowToGoalCategoryAudit 
( RefEvalueCashflowTypeId, RefGoalCategoryId, ConcurrencyId, 
	EvalueCashflowToGoalCategoryId, StampAction, StampDateTime, StampUser) 
Select RefEvalueCashflowTypeId, RefGoalCategoryId, ConcurrencyId, 
	EvalueCashflowToGoalCategoryId, @StampAction, GetDate(), @StampUser
FROM TEvalueCashflowToGoalCategory
WHERE EvalueCashflowToGoalCategoryId = @EvalueCashflowToGoalCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
