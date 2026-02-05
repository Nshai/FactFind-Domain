SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditOrigoStatus]
	@StampUser varchar (255),
	@OrigoStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TOrigoStatusAudit 
( OrigoRef, RetiredFg, ConcurrencyId, 
	OrigoStatusId, StampAction, StampDateTime, StampUser) 
Select OrigoRef, RetiredFg, ConcurrencyId, 
	OrigoStatusId, @StampAction, GetDate(), @StampUser
FROM TOrigoStatus
WHERE OrigoStatusId = @OrigoStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
