SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFeeStatus]
	@StampUser varchar (255),
	@FeeStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeeStatusAudit 
( FeeId, Status, StatusNotes, StatusDate, 
		UpdatedUserId, ConcurrencyId, 
	FeeStatusId, StampAction, StampDateTime, StampUser) 
Select FeeId, Status, StatusNotes, StatusDate, 
		UpdatedUserId, ConcurrencyId, 
	FeeStatusId, @StampAction, GetDate(), @StampUser
FROM TFeeStatus
WHERE FeeStatusId = @FeeStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
