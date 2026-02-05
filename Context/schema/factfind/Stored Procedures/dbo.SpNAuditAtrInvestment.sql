SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrInvestment]
	@StampUser varchar (255),
	@AtrInvestmentId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrInvestmentAudit 
( AtrQuestionGuid, AtrAnswerGuid, CRMContactId, ConcurrencyId, 
		
	AtrInvestmentId,AtrInvestmentSyncId, StampAction, StampDateTime, StampUser) 
Select AtrQuestionGuid, AtrAnswerGuid, CRMContactId, ConcurrencyId, 
		
	AtrInvestmentId,AtrInvestmentSyncId, @StampAction, GetDate(), @StampUser
FROM TAtrInvestment
WHERE AtrInvestmentId = @AtrInvestmentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
