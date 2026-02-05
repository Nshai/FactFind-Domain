SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAgencyNumber]
	@StampUser varchar (255),
	@AgencyNumberId bigint,
	@StampAction char(1)
AS

INSERT INTO TAgencyNumberAudit 
( PractitionerId, RefProdProviderId, AgencyNumber, DateChanged, 
		ConcurrencyId, 
	AgencyNumberId, StampAction, StampDateTime, StampUser) 
Select PractitionerId, RefProdProviderId, AgencyNumber, DateChanged, 
		ConcurrencyId, 
	AgencyNumberId, @StampAction, GetDate(), @StampUser
FROM TAgencyNumber
WHERE AgencyNumberId = @AgencyNumberId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
