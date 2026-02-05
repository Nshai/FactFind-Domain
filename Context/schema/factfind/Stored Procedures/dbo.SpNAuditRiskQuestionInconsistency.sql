SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRiskQuestionInconsistency]
	@StampUser varchar (255),
	@RiskQuestionInconsistencyId int,
	@StampAction char(1)
AS

INSERT INTO TRiskQuestionInconsistencyAudit (
	RiskQuestionInconsistencyId, TenantId, CRMContactId, [Message], IsRetirement, IsAdviserNote, StampAction, StampDateTime, StampUser)
SELECT 
	RiskQuestionInconsistencyId, TenantId, CRMContactId, [Message], IsRetirement, IsAdviserNote, @StampAction, GETDATE(), @StampUser
FROM 
	TRiskQuestionInconsistency
WHERE
	RiskQuestionInconsistencyId = @RiskQuestionInconsistencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO