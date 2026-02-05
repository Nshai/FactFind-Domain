SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditAtrQuestionRiskGrouping]
	@StampUser varchar (255),
	@AtrQuestionRiskGroupingId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrQuestionRiskGroupingAudit 
		(ConcurrencyId, RiskGroupingId, AtrQuestionGuid, AtrTemplateGuid, AtrQuestionRiskGroupingId, StampAction, StampDateTime, StampUser)
					    
SELECT  ConcurrencyId, RiskGroupingId, AtrQuestionGuid, AtrTemplateGuid, AtrQuestionRiskGroupingId, @StampAction, GetDate(), @StampUser
		
FROM	TAtrQuestionRiskGrouping	
	
WHERE 
		AtrQuestionRiskGroupingId = @AtrQuestionRiskGroupingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
