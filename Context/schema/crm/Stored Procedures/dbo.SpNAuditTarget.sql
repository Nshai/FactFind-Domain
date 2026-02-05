SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditTarget]
	@StampUser varchar (255),
	@TargetId bigint,
	@StampAction char(1)
AS

INSERT INTO TTargetAudit 
( IndClientId, PractCRMContactId, TargetAmount, Month, 
		Year, ConcurrencyId, 
	TargetId, StampAction, StampDateTime, StampUser) 
Select IndClientId, PractCRMContactId, TargetAmount, Month, 
		Year, ConcurrencyId, 
	TargetId, @StampAction, GetDate(), @StampUser
FROM TTarget
WHERE TargetId = @TargetId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
