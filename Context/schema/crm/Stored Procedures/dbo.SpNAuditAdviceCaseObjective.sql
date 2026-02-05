USE [crm]
GO

/****** Object:  StoredProcedure [dbo].[SpNAuditAdviceCaseObjective]    Script Date: 10/04/2023 13:13:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

Create PROCEDURE [dbo].[SpNAuditAdviceCaseObjective]
	@StampUser varchar (255),
	@AdviceCaseObjectiveId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseObjectiveAudit 
( AdviceCaseId, ObjectiveId, 
	AdviceCaseObjectiveId, StampAction, StampDateTime, StampUser) 
Select AdviceCaseId, ObjectiveId,
	AdviceCaseObjectiveId, @StampAction, GetDate(), @StampUser
FROM TAdviceCaseObjective
WHERE AdviceCaseObjectiveId = @AdviceCaseObjectiveId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO


