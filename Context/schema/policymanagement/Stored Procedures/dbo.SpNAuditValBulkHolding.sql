SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditValBulkHolding]
	@StampUser varchar (255),
	@ValBulkHoldingId bigint,
	@StampAction char(1)
AS

INSERT INTO TValBulkHoldingAudit 
	( ValScheduleItemId, CustomerReference, PortfolioReference, CustomerSubType, 
	Title, FirstName, LastName, CorporateName, 
	DOB, NINumber, ClientAddressLine1, ClientAddressLine2, 
	ClientAddressLine3, ClientAddressLine4, ClientPostCode, AdviserReference, 
	AdviserFirstName, AdviserLastName, CompanyName, AdviserPostCode, 
	PortfolioId, HoldingId, PortfolioType, Designation, 
	FundProviderName, FundName, ISIN, MexId, 
	Sedol, Quantity, EffectiveDate, Price, 
	PriceDate, HoldingValue, Currency, WorkInProgress, 
	CRMContactId, PractitionerId, PolicyBusinessId, Status, 
	IsLatestFG, 
	SubPlanReference, SubPlanType, EpicCode, CitiCode,
	GBPBalance, ForeignBalance, AvailableCash, AccountName, AccountReference,
	ConcurrencyId, 
	ValBulkHoldingId, StampAction, StampDateTime, StampUser) 
Select ValScheduleItemId, CustomerReference, PortfolioReference, CustomerSubType, 
	Title, FirstName, LastName, CorporateName, 
	DOB, NINumber, ClientAddressLine1, ClientAddressLine2, 
	ClientAddressLine3, ClientAddressLine4, ClientPostCode, AdviserReference, 
	AdviserFirstName, AdviserLastName, CompanyName, AdviserPostCode, 
	PortfolioId, HoldingId, PortfolioType, Designation, 
	FundProviderName, FundName, ISIN, MexId, 
	Sedol, Quantity, EffectiveDate, Price, 
	PriceDate, HoldingValue, Currency, WorkInProgress, 
	CRMContactId, PractitionerId, PolicyBusinessId, Status, 
	IsLatestFG, 
	SubPlanReference, SubPlanType, EpicCode, CitiCode,
	GBPBalance, ForeignBalance, AvailableCash, AccountName, AccountReference,
	ConcurrencyId, 
	ValBulkHoldingId, @StampAction, GetDate(), @StampUser
FROM TValBulkHolding
WHERE ValBulkHoldingId = @ValBulkHoldingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
