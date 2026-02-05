SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditClientBankAccount]
	@StampUser varchar (255),
	@ClientBankAccountId bigint,
	@StampAction char(1)
AS

INSERT INTO TClientBankAccountAudit 
( IndigoClientId, CRMContactId, CRMContactId2, BankName, AddressLine1, 
		AddressLine2, AddressLine3, AddressLine4, CityTown, 
		RefCountyId, RefCountryId, PostCode, AccountHolders, 
		AccountNumber, SortCode, AccountName, DefaultAccountFg, 
		ConcurrencyId, 
	ClientBankAccountId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, CRMContactId, CRMContactId2, BankName, AddressLine1, 
		AddressLine2, AddressLine3, AddressLine4, CityTown, 
		RefCountyId, RefCountryId, PostCode, AccountHolders, 
		AccountNumber, SortCode, AccountName, DefaultAccountFg, 
		ConcurrencyId, 
	ClientBankAccountId, @StampAction, GetDate(), @StampUser
FROM TClientBankAccount
WHERE ClientBankAccountId = @ClientBankAccountId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
