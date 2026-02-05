SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditVerificationHistoryAddress]
	@StampUser varchar (255),
	@VerificationHistoryAddressId bigint,
	@StampAction char(1)
AS

INSERT INTO TVerificationHistoryAddressAudit 
( UserId, CRMContactId, AddressId, LookupDate, 
		LookupResult, ConcurrencyId, 
	VerificationHistoryAddressId, StampAction, StampDateTime, StampUser) 
Select UserId, CRMContactId, AddressId, LookupDate, 
		LookupResult, ConcurrencyId, 
	VerificationHistoryAddressId, @StampAction, GetDate(), @StampUser
FROM TVerificationHistoryAddress
WHERE VerificationHistoryAddressId = @VerificationHistoryAddressId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
