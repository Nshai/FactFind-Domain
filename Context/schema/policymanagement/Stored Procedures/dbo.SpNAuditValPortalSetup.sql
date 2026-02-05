SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValPortalSetup]
	@StampUser varchar (255),
	@ValPortalSetupId bigint,
	@StampAction char(1)
AS

INSERT INTO TValPortalSetupAudit 
( CRMContactId, RefProdProviderId, UserName, Password, Password2, Passcode,
		ShowHowToScreen, CreatedDate, ConcurrencyId, 
	ValPortalSetupId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, RefProdProviderId, UserName, Password, Password2, Passcode,
		ShowHowToScreen, CreatedDate, ConcurrencyId, 
	ValPortalSetupId, @StampAction, GetDate(), @StampUser
FROM TValPortalSetup
WHERE ValPortalSetupId = @ValPortalSetupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
