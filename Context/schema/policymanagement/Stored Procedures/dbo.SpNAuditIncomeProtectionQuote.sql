SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditIncomeProtectionQuote]
	@StampUser varchar (255),
	@IncomeProtectionQuoteId bigint,
	@StampAction char(1)
AS

INSERT INTO TIncomeProtectionQuoteAudit 
( QuoteId, ProductTermId, QuotationBasisId, MaximumAvailableBenefit, 
		QuotePremiumId, IncludeRenewable, DualDeferredPeriodsRequired, IncludeLimitedPaymentPlans, 
		EmploymentStatus, InitialMonthlyBenefitId, AdditionalMonthlyBenefitId, BenefitIncreasingFrom, 
		AnnualEarnedIncome, AnnualDividendIncome, ExistingBenefitAmount, IncludeEmployerNIContributions, 
		IncludeEmployerPensionContributions, MonthlyPensionContributions, TenantId, ConcurrencyId, 
		
	IncomeProtectionQuoteId, StampAction, StampDateTime, StampUser) 
Select QuoteId, ProductTermId, QuotationBasisId, MaximumAvailableBenefit, 
		QuotePremiumId, IncludeRenewable, DualDeferredPeriodsRequired, IncludeLimitedPaymentPlans, 
		EmploymentStatus, InitialMonthlyBenefitId, AdditionalMonthlyBenefitId, BenefitIncreasingFrom, 
		AnnualEarnedIncome, AnnualDividendIncome, ExistingBenefitAmount, IncludeEmployerNIContributions, 
		IncludeEmployerPensionContributions, MonthlyPensionContributions, TenantId, ConcurrencyId, 
		
	IncomeProtectionQuoteId, @StampAction, GetDate(), @StampUser
FROM TIncomeProtectionQuote
WHERE IncomeProtectionQuoteId = @IncomeProtectionQuoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
