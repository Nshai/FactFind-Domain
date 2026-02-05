SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditYourCurrentPlanners]
	@StampUser varchar (255),
	@YourCurrentPlannersId bigint,
	@StampAction char(1)
AS

INSERT INTO TYourCurrentPlannersAudit 
( CRMContactId, Type, Name, ContactNumber, 
		Address, ConcurrencyId, 
	YourCurrentPlannersId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Type, Name, ContactNumber, 
		Address, ConcurrencyId, 
	YourCurrentPlannersId, @StampAction, GetDate(), @StampUser
FROM TYourCurrentPlanners
WHERE YourCurrentPlannersId = @YourCurrentPlannersId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
