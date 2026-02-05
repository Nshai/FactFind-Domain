SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditMortgage]
	@StampUser varchar (255),
	@MortgageId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageAudit 
(PolicyBusinessId, IndigoClientId, MortgageRefNo, LoanAmount, InterestRate, MortgageType, 
	MortgageTypeOther, FeatureExpiryDate, PenaltyFg, PenaltyExpiryDate, RedemptionTerms, SchemeRate, 
	SchemeEndDate, CompletionDate, SVR, PortableFg, RedeemedFg, SoldFg, 
	AssetsId, LiabilitiesId, ReviewDiaryDate, RefMortgageBorrowerTypeId, RefMortgageRepaymentMethodId, RefMortgageProductTypeId, 
	MortgageTerm, MortgageTermMonths, RemainingTerm, PropertyValue, IncomeEvidencedFg, AddressStoreId, 
	LoanPurpose, PriceValuation, Deposit, InterestOnlyAmount, RepaymentAmount, LTV, 
	ApplicationSubmitted, ValuationInstructed, ValuationDate, ValuationReceived, OfferIssued, ExchangeDate, 
	IsCurrentResidence, IsResdidenceAfterComplete, CurrentBalance, WillPayRedemption, WillBeDischarged, RedemptionAmount, 
	StatusFg, NonStatusFg, SelfCertFg, ConcurrencyId, ApplicableToNewTransaction,
	BaseRate,LoadingPct,LenderFee,IsGuarantorMortgage,IsOverHang,RatePeriodFromCompletionMonths,IsCollaredRate,CollarPct,
	IsAddToMortgageAdvance,MortgageId, StampAction, StampDateTime, StampUser,RepayDebtFg,MonthlyRepaymentAmount, InterestOnlyRepaymentVehicle, CapitalRepaymentTerm, InterestOnlyTerm
	,ValueOfProperty,PropertyType,InterestDetails,IsFirstTimeBuyer, TargetCompletionDate,PlanMigrationRef, ProductPeriodId, RedemptionFigure, RedemptionFigure2, NetProceed,ProductRatePeriodInYears,
	InterestRateAPR,ConsentToLetFg,ConsentToLetExpiryDate,PercentageOwnership,SharedOwnershipBody,RentMonthly, RefEquityLoanSchemeId, EquitySchemeProvider, EquityRepaymentStartDate, EquityLoanPercentage, EquityLoanAmount, AddressId,
	IsToBeConsolidated, IsLiabilityToBeRepaid, LiabilityRepaymentDescription
)
SELECT  PolicyBusinessId, IndigoClientId, MortgageRefNo, LoanAmount, InterestRate, MortgageType, 
	MortgageTypeOther, FeatureExpiryDate, PenaltyFg, PenaltyExpiryDate, RedemptionTerms, SchemeRate, 
	SchemeEndDate, CompletionDate, SVR, PortableFg, RedeemedFg, SoldFg, 
	AssetsId, LiabilitiesId, ReviewDiaryDate, RefMortgageBorrowerTypeId, RefMortgageRepaymentMethodId, RefMortgageProductTypeId, 
	MortgageTerm, MortgageTermMonths, RemainingTerm, PropertyValue, IncomeEvidencedFg, AddressStoreId, 
	LoanPurpose, PriceValuation, Deposit, InterestOnlyAmount, RepaymentAmount, LTV, 
	ApplicationSubmitted, ValuationInstructed, ValuationDate, ValuationReceived, OfferIssued, ExchangeDate, 
	IsCurrentResidence, IsResdidenceAfterComplete, CurrentBalance, WillPayRedemption, WillBeDischarged, RedemptionAmount, 
	StatusFg, NonStatusFg, SelfCertFg, ConcurrencyId, ApplicableToNewTransaction,
	BaseRate,LoadingPct,LenderFee,IsGuarantorMortgage,IsOverHang, RatePeriodFromCompletionMonths,IsCollaredRate,CollarPct,
	IsAddToMortgageAdvance,MortgageId, @StampAction, GetDate(), @StampUser,RepayDebtFg,MonthlyRepaymentAmount, InterestOnlyRepaymentVehicle, CapitalRepaymentTerm, InterestOnlyTerm,ValueOfProperty,
	PropertyType,InterestDetails,IsFirstTimeBuyer, TargetCompletionDate,PlanMigrationRef, ProductPeriodId, RedemptionFigure, RedemptionFigure2, NetProceed,ProductRatePeriodInYears,
	InterestRateAPR,ConsentToLetFg,ConsentToLetExpiryDate,PercentageOwnership,SharedOwnershipBody,RentMonthly, RefEquityLoanSchemeId, EquitySchemeProvider, EquityRepaymentStartDate, EquityLoanPercentage, EquityLoanAmount, AddressId,
	IsToBeConsolidated, IsLiabilityToBeRepaid, LiabilityRepaymentDescription
FROM TMortgage
WHERE MortgageId = @MortgageId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
