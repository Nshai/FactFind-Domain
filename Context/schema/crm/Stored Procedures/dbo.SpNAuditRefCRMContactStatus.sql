SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefCRMContactStatus]
	@StampUser varchar (255),
	@RefCRMContactStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefCRMContactStatusAudit 
( StatusName, OrderNo, InternalFG, ConcurrencyId, 
		
	RefCRMContactStatusId, StampAction, StampDateTime, StampUser) 
Select StatusName, OrderNo, InternalFG, ConcurrencyId, 
		
	RefCRMContactStatusId, @StampAction, GetDate(), @StampUser
FROM TRefCRMContactStatus
WHERE RefCRMContactStatusId = @RefCRMContactStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
