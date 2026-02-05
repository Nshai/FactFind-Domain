SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditProtectionGoalsNeedsQuestion]
	@StampUser varchar (255),
	@ProtectionGoalsNeedsQuestionId bigint,
	@StampAction char(1)
AS

INSERT INTO TProtectionGoalsNeedsQuestionAudit 
( CRMContactId, IsSmoker, HaveSmoked, ConcurrencyId, 
		
	ProtectionGoalsNeedsQuestionId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, IsSmoker, HaveSmoked, ConcurrencyId, 
		
	ProtectionGoalsNeedsQuestionId, @StampAction, GetDate(), @StampUser
FROM TProtectionGoalsNeedsQuestion
WHERE ProtectionGoalsNeedsQuestionId = @ProtectionGoalsNeedsQuestionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
