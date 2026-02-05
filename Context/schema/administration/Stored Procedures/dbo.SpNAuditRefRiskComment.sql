SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefRiskComment]
	@StampUser varchar (255),
	@RefRiskCommentId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefRiskCommentAudit 
			(	RiskComment, 
				ConcurrencyId, 
				RefRiskCommentId, 
				StampAction, 
				StampDateTime, 
				StampUser) 
SELECT RiskComment, 
	   ConcurrencyId, 
	   RefRiskCommentId, 
	   @StampAction, 
	   GetDate(), 
	   @StampUser
FROM  administration..TRefRiskComment
WHERE RefRiskCommentId = @RefRiskCommentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
