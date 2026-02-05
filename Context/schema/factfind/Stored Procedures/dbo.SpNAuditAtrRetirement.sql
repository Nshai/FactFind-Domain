SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrRetirement]
	@StampUser varchar (255),
	@AtrRetirementId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrRetirementAudit 
( AtrQuestionGuid, AtrAnswerGuid, CRMContactId, ConcurrencyId, 
		
	AtrRetirementId,AtrRetirementSyncId, StampAction, StampDateTime, StampUser) 
Select AtrQuestionGuid, AtrAnswerGuid, CRMContactId, ConcurrencyId, 
		
	AtrRetirementId,AtrRetirementSyncId, @StampAction, GetDate(), @StampUser
FROM TAtrRetirement
WHERE AtrRetirementId = @AtrRetirementId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
