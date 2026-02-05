SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditHealth]
	@StampUser varchar (255),
	@HealthId bigint,
	@StampAction char(1)
AS

INSERT INTO THealthAudit 
( CRMContactId, GoodHealth, HealthComments, ConcurrencyId, 
		
	HealthId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, GoodHealth, HealthComments, ConcurrencyId, 
		
	HealthId, @StampAction, GetDate(), @StampUser
FROM THealth
WHERE HealthId = @HealthId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
