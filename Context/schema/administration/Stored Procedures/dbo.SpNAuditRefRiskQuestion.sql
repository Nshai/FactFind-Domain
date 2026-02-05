SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefRiskQuestion]
	@StampUser varchar (255),
	@RefRiskQuestionId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefRiskQuestionAudit 
			(	Question, 
				Ordinal,
				IsArchived,
				CreatedBy,
				ConcurrencyId, 
				RefRiskQuestionId, 
				StampAction, 
				StampDateTime, 
				StampUser,
				RefRiskCommentId) 
SELECT Question, 
	   Ordinal,
	   IsArchived,
	   CreatedBy,
	   ConcurrencyId, 
	   RefRiskQuestionId, 
	   @StampAction, 
	   GetDate(), 
	   @StampUser,
	   RefRiskCommentId
FROM  administration..TRefRiskQuestion
WHERE RefRiskQuestionId = @RefRiskQuestionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
