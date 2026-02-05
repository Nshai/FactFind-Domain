SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAdviceCaseHistory]
	@StampUser varchar (255),
	@AdviceCaseHistoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseHistoryAudit 
( AdviceCaseId, ChangeType, StatusId, PractitionerId, 
		ChangedByUserId, StatusDate, ConcurrencyId, 
	AdviceCaseHistoryId, StampAction, StampDateTime, StampUser) 
Select AdviceCaseId, ChangeType, StatusId, PractitionerId, 
		ChangedByUserId, StatusDate, ConcurrencyId, 
	AdviceCaseHistoryId, @StampAction, GetDate(), @StampUser
FROM TAdviceCaseHistory
WHERE AdviceCaseHistoryId = @AdviceCaseHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
