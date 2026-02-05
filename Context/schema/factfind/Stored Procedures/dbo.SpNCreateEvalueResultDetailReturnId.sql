SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateEvalueResultDetailReturnId]
	@StampUser varchar (255),
	@EvalueResultId bigint, 
	@FinancialPlanningScenarioId bigint, 
	@EvalueXML xml , 
	@PODGuid uniqueidentifier,
	@FinalPod bit
AS


DECLARE @EvalueResultDetailId bigint, @Result int
			
	
INSERT INTO TEvalueResultDetail
(EvalueResultId, FinancialPlanningScenarioId, EvalueXML, PODGuid, FinalPod, ConcurrencyId)
VALUES(@EvalueResultId, @FinancialPlanningScenarioId, @EvalueXML, @PODGuid,@FinalPod, 1)

SELECT @EvalueResultDetailId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditEvalueResultDetail @StampUser, @EvalueResultDetailId, 'C'

IF @Result  != 0 GOTO errh


SELECT @EvalueResultDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
