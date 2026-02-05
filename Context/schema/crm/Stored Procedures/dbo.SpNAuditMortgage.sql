SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditMortgage]
	@StampUser varchar (255),
	@MortgageId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageAudit 
( Applicant, Joint, FirstTimeBuyer, HomeMover, 
		InvestmentProperty, Remortgage, FurtherAdvance, SecondHome, 
		Refinancing, Other, Amount, Term, 
		TypeRequired, UpperLimitMortgageCost, FixedPeriodRequired, Cashback, 
		DiscountedRate, SettlementCosts, NoTieIn, NoHighLendingFee, 
		AddFeeOrLoan, VariablePayments, IndependantQuotes, Address, 
		PropertyValue, Tenancy, LeaseYears, PropertyType, 
		CurrentAddressTime, OtherAddressDetails, ConcurrencyId, 
	MortgageId, StampAction, StampDateTime, StampUser) 
Select Applicant, Joint, FirstTimeBuyer, HomeMover, 
		InvestmentProperty, Remortgage, FurtherAdvance, SecondHome, 
		Refinancing, Other, Amount, Term, 
		TypeRequired, UpperLimitMortgageCost, FixedPeriodRequired, Cashback, 
		DiscountedRate, SettlementCosts, NoTieIn, NoHighLendingFee, 
		AddFeeOrLoan, VariablePayments, IndependantQuotes, Address, 
		PropertyValue, Tenancy, LeaseYears, PropertyType, 
		CurrentAddressTime, OtherAddressDetails, ConcurrencyId, 
	MortgageId, @StampAction, GetDate(), @StampUser
FROM TMortgage
WHERE MortgageId = @MortgageId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
