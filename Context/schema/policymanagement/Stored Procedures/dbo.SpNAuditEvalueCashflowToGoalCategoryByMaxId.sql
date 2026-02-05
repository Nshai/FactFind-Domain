SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditEvalueCashflowToGoalCategoryByMaxId]
	@StampUser varchar (255),
	@MaxId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvalueCashflowToGoalCategoryAudit 
( RefEvalueCashflowTypeId, RefGoalCategoryId, ConcurrencyId, 
	EvalueCashflowToGoalCategoryId, StampAction, StampDateTime, StampUser) 
Select RefEvalueCashflowTypeId, RefGoalCategoryId, ConcurrencyId, 
	EvalueCashflowToGoalCategoryId, @StampAction, GetDate(), @StampUser
FROM TEvalueCashflowToGoalCategory
WHERE EvalueCashflowToGoalCategoryId > @MaxId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
