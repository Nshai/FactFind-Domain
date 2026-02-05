SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEmailAddress]
	@StampUser varchar (255),
	@EmailAddressId bigint,
	@StampAction char(1)
AS

INSERT INTO TEmailAddressAudit 
( EmailId, Address, IsCCAddress, EntityOrganiserActivityId, 
		ConcurrencyId, 
	EmailAddressId, StampAction, StampDateTime, StampUser) 
Select EmailId, Address, IsCCAddress, EntityOrganiserActivityId, 
		ConcurrencyId, 
	EmailAddressId, @StampAction, GetDate(), @StampUser
FROM TEmailAddress
WHERE EmailAddressId = @EmailAddressId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
