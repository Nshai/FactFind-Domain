SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditEvalueCashflowToExpenditureCategory]
	@StampUser varchar (255),
	@EvalueCashflowToExpenditureCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TEvalueCashflowToExpenditureCategoryAudit 
( RefExpenditureTypeId, RefEvalueCashflowTypeId, 
	EvalueCashflowToExpenditureCategoryId, StampAction, StampDateTime, StampUser) 
Select RefExpenditureTypeId, RefEvalueCashflowTypeId, 
	EvalueCashflowToExpenditureCategoryId, @StampAction, GetDate(), @StampUser
FROM TEvalueCashflowToExpenditureCategory
WHERE EvalueCashflowToExpenditureCategoryId = @EvalueCashflowToExpenditureCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
