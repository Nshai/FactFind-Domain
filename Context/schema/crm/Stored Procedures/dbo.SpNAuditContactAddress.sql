SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditContactAddress]
	@StampUser varchar (255),
	@ContactAddressId bigint,
	@StampAction char(1)
AS

INSERT INTO TContactAddressAudit 
( ContactId, AddressId, ConcurrencyId, 
	ContactAddressId, StampAction, StampDateTime, StampUser) 
Select ContactId, AddressId, ConcurrencyId, 
	ContactAddressId, @StampAction, GetDate(), @StampUser
FROM TContactAddress
WHERE ContactAddressId = @ContactAddressId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
