SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateEvalueResultReturnId]
	@StampUser varchar (255),
	@FinancialPlanningId bigint,
	@EvalueLogId bigint,
	@AxisImageGuid	uniqueidentifier,
	@TaxFreeLumpsum bigint,
	@ParentEvalueLogId bigint = null
AS


DECLARE @EvalueResultId bigint, @Result int
			
	
INSERT INTO TEvalueResult
(FinancialPlanningId,EvalueLogId,AxisImageGuid,RefEvalueModellingTypeId, ParentEvalueLogId,ConcurrencyId)
VALUES(@FinancialPlanningId,@EvalueLogId,@AxisImageGuid,@TaxFreeLumpsum, @ParentEvalueLogId, 1)

SELECT @EvalueResultId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditEvalueResult @StampUser, @EvalueResultId, 'C'

IF @Result  != 0 GOTO errh


SELECT @EvalueResultId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
