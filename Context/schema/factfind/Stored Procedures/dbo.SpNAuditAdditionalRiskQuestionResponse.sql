SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAdditionalRiskQuestionResponse]
	@StampUser varchar (255),
	@AdditionalRiskQuestionResponseId int,
	@StampAction char(1)
AS

INSERT INTO TAdditionalRiskQuestionResponseAudit (
	AdditionalRiskQuestionResponseId, TenantId, CRMContactId, QuestionNumber, ResponseId, ResponseText, IsRetirement, StampAction, StampDateTime, StampUser)
SELECT 
	AdditionalRiskQuestionResponseId, TenantId, CRMContactId, QuestionNumber, ResponseId, ResponseText, IsRetirement, @StampAction, GETDATE(), @StampUser
FROM 
	TAdditionalRiskQuestionResponse
WHERE
	AdditionalRiskQuestionResponseId = @AdditionalRiskQuestionResponseId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
