SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE dbo.[SpCustomRelinkAddressStoreFromMortgage] @StampUser VARCHAR (255), 
                                             @IndigoClientId BIGINT,
											 @PreviousAddressStoreId BIGINT, 
											 @NewAddressStoreId BIGINT, 
											 @CRMContactId	 BIGINT
AS 

SET NOCOUNT ON
	BEGIN 
		UPDATE m
		SET M.AddressStoreId = @NewAddressStoreId
		OUTPUT DELETED.PolicyBusinessId
			,DELETED.IndigoClientId
			,DELETED.MortgageRefNo
			,DELETED.LoanAmount
			,DELETED.InterestRate
			,DELETED.MortgageType
			,DELETED.MortgageTypeOther
			,DELETED.FeatureExpiryDate
			,DELETED.PenaltyFg
			,DELETED.PenaltyExpiryDate
			,DELETED.RedemptionTerms
			,DELETED.SchemeRate
			,DELETED.SchemeEndDate
			,DELETED.CompletionDate
			,DELETED.SVR
			,DELETED.PortableFg
			,DELETED.RedeemedFg
			,DELETED.SoldFg
			,DELETED.AssetsId
			,DELETED.LiabilitiesId
			,DELETED.ReviewDiaryDate
			,DELETED.RefMortgageBorrowerTypeId
			,DELETED.RefMortgageRepaymentMethodId
			,DELETED.RefMortgageProductTypeId
			,DELETED.MortgageTerm
			,DELETED.MortgageTermMonths
			,DELETED.RemainingTerm
			,DELETED.PropertyValue
			,DELETED.IncomeEvidencedFg
			,DELETED.AddressStoreId
			,DELETED.LoanPurpose
			,DELETED.PriceValuation
			,DELETED.Deposit
			,DELETED.InterestOnlyAmount
			,DELETED.RepaymentAmount
			,DELETED.LTV
			,DELETED.ApplicationSubmitted
			,DELETED.ValuationInstructed
			,DELETED.ValuationDate
			,DELETED.ValuationReceived
			,DELETED.OfferIssued
			,DELETED.ExchangeDate
			,DELETED.IsCurrentResidence
			,DELETED.IsResdidenceAfterComplete
			,DELETED.CurrentBalance
			,DELETED.WillPayRedemption
			,DELETED.WillBeDischarged
			,DELETED.RedemptionAmount
			,DELETED.StatusFg
			,DELETED.NonStatusFg
			,DELETED.SelfCertFg
			,DELETED.ConcurrencyId
			,DELETED.MortgageId
			,'U'
			,GETDATE()
			,@StampUser
			,DELETED.ApplicableToNewTransaction
			,DELETED.BaseRate
			,DELETED.LoadingPct
			,DELETED.LenderFee
			,DELETED.IsGuarantorMortgage
			,DELETED.IsOverHang
			,DELETED.RatePeriodFromCompletionMonths
			,DELETED.IsCollaredRate
			,DELETED.CollarPct
			,DELETED.IsAddToMortgageAdvance
			,DELETED.RepayDebtFg
			,DELETED.MonthlyRepaymentAmount
			,DELETED.InterestOnlyRepaymentVehicle
			,DELETED.CapitalRepaymentTerm
			,DELETED.InterestOnlyTerm
			,DELETED.ValueOfProperty
			,DELETED.PropertyType
			,DELETED.InterestDetails
			,DELETED.IsFirstTimeBuyer
			,DELETED.TargetCompletionDate
			,DELETED.PlanMigrationRef
			,DELETED.ProductPeriodId
			,DELETED.RedemptionFigure
			,DELETED.RedemptionFigure2
			,DELETED.NetProceed
			,DELETED.ProductRatePeriodInYears       
			,DELETED.InterestRateAPR
		INTO policymanagement..TMortgageAudit
		(
			PolicyBusinessId
			,IndigoClientId
			,MortgageRefNo
			,LoanAmount
			,InterestRate
			,MortgageType
			,MortgageTypeOther
			,FeatureExpiryDate
			,PenaltyFg
			,PenaltyExpiryDate
			,RedemptionTerms
			,SchemeRate
			,SchemeEndDate
			,CompletionDate
			,SVR
			,PortableFg
			,RedeemedFg
			,SoldFg
			,AssetsId
			,LiabilitiesId
			,ReviewDiaryDate
			,RefMortgageBorrowerTypeId
			,RefMortgageRepaymentMethodId
			,RefMortgageProductTypeId
			,MortgageTerm
			,MortgageTermMonths
			,RemainingTerm
			,PropertyValue
			,IncomeEvidencedFg
			,AddressStoreId
			,LoanPurpose
			,PriceValuation
			,Deposit
			,InterestOnlyAmount
			,RepaymentAmount
			,LTV
			,ApplicationSubmitted
			,ValuationInstructed
			,ValuationDate
			,ValuationReceived
			,OfferIssued
			,ExchangeDate
			,IsCurrentResidence
			,IsResdidenceAfterComplete
			,CurrentBalance
			,WillPayRedemption
			,WillBeDischarged
			,RedemptionAmount
			,StatusFg
			,NonStatusFg
			,SelfCertFg
			,ConcurrencyId
			,MortgageId
			,StampAction
			,StampDateTime
			,StampUser
			,ApplicableToNewTransaction
			,BaseRate
			,LoadingPct
			,LenderFee
			,IsGuarantorMortgage
			,IsOverHang
			,RatePeriodFromCompletionMonths
			,IsCollaredRate
			,CollarPct
			,IsAddToMortgageAdvance
			,RepayDebtFg
			,MonthlyRepaymentAmount
			,InterestOnlyRepaymentVehicle
			,CapitalRepaymentTerm
			,InterestOnlyTerm
			,ValueOfProperty
			,PropertyType
			,InterestDetails
			,IsFirstTimeBuyer
			,TargetCompletionDate
			,PlanMigrationRef
			,ProductPeriodId
			,RedemptionFigure
			,RedemptionFigure2
			,NetProceed
			,ProductRatePeriodInYears       
			,InterestRateAPR
		)
		FROM policymanagement..TMortgage m
		JOIN policymanagement..TPolicyBusiness b ON b.PolicyBusinessId = m.PolicyBusinessId
		LEFT JOIN policymanagement..TPolicyOwner o ON o.PolicyDetailId = b.PolicyDetailId
		LEFT JOIN policymanagement..TAdditionalOwner a ON a.PolicyBusinessId = m.PolicyBusinessId
		WHERE m.AddressStoreId = @PreviousAddressStoreId AND m.IndigoClientId = @IndigoClientId
		AND (o.CRMContactId = @CRMContactId OR a.CRMContactId = @CRMContactId)
END