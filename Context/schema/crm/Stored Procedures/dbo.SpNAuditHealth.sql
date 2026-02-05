SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditHealth]
	@StampUser varchar (255),
	@HealthId bigint,
	@StampAction char(1)
AS

INSERT INTO THealthAudit 
( Comment, CrmContactId, ConcurrencyId, 
	HealthId, StampAction, StampDateTime, StampUser) 
Select Comment, CrmContactId, ConcurrencyId, 
	HealthId, @StampAction, GetDate(), @StampUser
FROM THealth
WHERE HealthId = @HealthId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
