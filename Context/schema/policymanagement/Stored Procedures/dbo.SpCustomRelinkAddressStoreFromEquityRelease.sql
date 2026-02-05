SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE dbo.[SpCustomRelinkAddressStoreFromEquityRelease] @StampUser VARCHAR (255), 
                                             @IndigoClientId BIGINT,
											 @PreviousAddressStoreId BIGINT, 
											 @NewAddressStoreId BIGINT, 
											 @CRMContactId	 BIGINT
AS 

SET NOCOUNT ON
	BEGIN 
		UPDATE e
		SET e.AddressStoreId = @NewAddressStoreId
		OUTPUT deleted.PolicyBusinessId
			,deleted.InterestOnlyAmount
			,deleted.RepaymentAmount
			,deleted.LoanAmount
			,deleted.InterestRate
			,deleted.TermInYears
			,deleted.RefMortgageRepaymentMethodId
			,deleted.AddressStoreId
			,deleted.AssetsId
			,deleted.IndigoClientId
			,deleted.ConcurrencyId
			,deleted.EquityReleaseId
			,'U'
			,GETDATE()
			,@StampUser
			,deleted.PricePerValuation
			,deleted.DepositPerEquity
			,deleted.LTV
			,deleted.InterestRatePercentage
			,deleted.RateType
			,deleted.ValueOfProperty
			,deleted.PenaltyFg
			,deleted.RedemptionTerms
			,deleted.PenaltyExpiryDate
			,deleted.ApplicableToNewTransaction
			,deleted.RefEquityReleaseTypeId
			,deleted.PercentageOwnershipSold
			,deleted.LumpsumAmount
			,deleted.MonthlyIncomeAmount
			,deleted.CurrentBalance
			,deleted.InterestDetails
			,deleted.RateTypeOther
			,deleted.TargetCompletionDate
			,deleted.TermInMonths
			,deleted.ValuationDate
			,deleted.ValuationInstructed
			,deleted.ValuationReceived
			,deleted.ApplicationSubmitted
			,deleted.CompletionDate
			,deleted.ExchangeDate
			,deleted.OfferIssued
			,deleted.ReviewDiaryDate
			,deleted.CapitalRepaymentTermInMonths
			,deleted.InterestRepaymentTermInMonths
			,deleted.BaseRate
			,deleted.CollarRate
			,deleted.SchemeRate
			,deleted.SchemeEndDate
			,deleted.RedemptionFigure2
			,deleted.RedemptionFigure
		INTO policymanagement..TEquityReleaseAudit
		(
			PolicyBusinessId
			,InterestOnlyAmount
			,RepaymentAmount
			,LoanAmount
			,InterestRate
			,TermInYears
			,RefMortgageRepaymentMethodId
			,AddressStoreId
			,AssetsId
			,IndigoClientId
			,ConcurrencyId
			,EquityReleaseId
			,StampAction
			,StampDateTime
			,StampUser
			,PricePerValuation
			,DepositPerEquity
			,LTV
			,InterestRatePercentage
			,RateType
			,ValueOfProperty
			,PenaltyFg
			,RedemptionTerms
			,PenaltyExpiryDate
			,ApplicableToNewTransaction
			,RefEquityReleaseTypeId
			,PercentageOwnershipSold
			,LumpsumAmount
			,MonthlyIncomeAmount
			,CurrentBalance
			,InterestDetails
			,RateTypeOther
			,TargetCompletionDate
			,TermInMonths
			,ValuationDate
			,ValuationInstructed
			,ValuationReceived
			,ApplicationSubmitted
			,CompletionDate
			,ExchangeDate
			,OfferIssued
			,ReviewDiaryDate
			,CapitalRepaymentTermInMonths
			,InterestRepaymentTermInMonths
			,BaseRate
			,CollarRate
			,SchemeRate
			,SchemeEndDate
			,RedemptionFigure2
			,RedemptionFigure
		)
		FROM policymanagement..TEquityRelease e
		JOIN policymanagement..TPolicyBusiness b ON b.PolicyBusinessId = e.PolicyBusinessId
		LEFT JOIN policymanagement..TPolicyOwner o ON o.PolicyDetailId = b.PolicyDetailId
		LEFT JOIN policymanagement..TAdditionalOwner a ON a.PolicyBusinessId = e.PolicyBusinessId
		WHERE e.AddressStoreId = @PreviousAddressStoreId AND e.IndigoClientId = @IndigoClientId
		AND (o.CRMContactId = @CRMContactId OR a.CRMContactId = @CRMContactId)
END