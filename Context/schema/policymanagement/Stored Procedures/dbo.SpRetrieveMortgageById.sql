SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveMortgageById]
	@MortgageId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.MortgageId AS [Mortgage!1!MortgageId], 
	T1.PolicyBusinessId AS [Mortgage!1!PolicyBusinessId], 
	T1.IndigoClientId AS [Mortgage!1!IndigoClientId], 
	ISNULL(T1.MortgageRefNo, '') AS [Mortgage!1!MortgageRefNo], 
	ISNULL(CONVERT(varchar(24), T1.LoanAmount), '') AS [Mortgage!1!LoanAmount], 
	ISNULL(CONVERT(varchar(24), T1.InterestRate), '') AS [Mortgage!1!InterestRate], 
	ISNULL(T1.MortgageType, '') AS [Mortgage!1!MortgageType], 
	ISNULL(T1.MortgageTypeOther, '') AS [Mortgage!1!MortgageTypeOther], 
	ISNULL(CONVERT(varchar(24), T1.FeatureExpiryDate, 120), '') AS [Mortgage!1!FeatureExpiryDate], 
	T1.PenaltyFg AS [Mortgage!1!PenaltyFg], 
	ISNULL(CONVERT(varchar(24), T1.PenaltyExpiryDate, 120), '') AS [Mortgage!1!PenaltyExpiryDate], 
	ISNULL(T1.RedemptionTerms, '') AS [Mortgage!1!RedemptionTerms], 
	ISNULL(CONVERT(varchar(24), T1.SchemeRate), '') AS [Mortgage!1!SchemeRate], 
	ISNULL(CONVERT(varchar(24), T1.SchemeEndDate, 120), '') AS [Mortgage!1!SchemeEndDate], 
	ISNULL(CONVERT(varchar(24), T1.CompletionDate, 120), '') AS [Mortgage!1!CompletionDate], 
	ISNULL(CONVERT(varchar(24), T1.SVR), '') AS [Mortgage!1!SVR], 
	T1.PortableFg AS [Mortgage!1!PortableFg], 
	ISNULL(T1.RedeemedFg, '') AS [Mortgage!1!RedeemedFg], 
	ISNULL(T1.SoldFg, '') AS [Mortgage!1!SoldFg], 
	ISNULL(T1.AssetsId, '') AS [Mortgage!1!AssetsId], 
	ISNULL(T1.LiabilitiesId, '') AS [Mortgage!1!LiabilitiesId], 
	ISNULL(CONVERT(varchar(24), T1.ReviewDiaryDate, 120), '') AS [Mortgage!1!ReviewDiaryDate], 
	ISNULL(T1.RefMortgageBorrowerTypeId, '') AS [Mortgage!1!RefMortgageBorrowerTypeId], 
	ISNULL(T1.RefMortgageRepaymentMethodId, '') AS [Mortgage!1!RefMortgageRepaymentMethodId], 
	ISNULL(T1.RefMortgageProductTypeId, '') AS [Mortgage!1!RefMortgageProductTypeId], 
	ISNULL(CONVERT(varchar(24), T1.MortgageTerm), '') AS [Mortgage!1!MortgageTerm],   
	ISNULL(T1.MortgageTermMonths, '') AS [Mortgage!1!MortgageTermMonths], 
	ISNULL(CONVERT(varchar(24), T1.RemainingTerm), '') AS [Mortgage!1!RemainingTerm],   
	ISNULL(T1.PropertyValue, '') AS [Mortgage!1!PropertyValue], 
	ISNULL(T1.IncomeEvidencedFg, '') AS [Mortgage!1!IncomeEvidencedFg], 
	ISNULL(T1.AddressStoreId, '') AS [Mortgage!1!AddressStoreId], 
	ISNULL(T1.LoanPurpose, '') AS [Mortgage!1!LoanPurpose], 
	ISNULL(CONVERT(varchar(24), T1.PriceValuation), '') AS [Mortgage!1!PriceValuation], 
	ISNULL(CONVERT(varchar(24), T1.Deposit), '') AS [Mortgage!1!Deposit], 
	ISNULL(CONVERT(varchar(24), T1.InterestOnlyAmount), '') AS [Mortgage!1!InterestOnlyAmount], 
	ISNULL(CONVERT(varchar(24), T1.RepaymentAmount), '') AS [Mortgage!1!RepaymentAmount], 
	ISNULL(CONVERT(varchar(24), T1.LTV), '') AS [Mortgage!1!LTV], 
	ISNULL(CONVERT(varchar(24), T1.ApplicationSubmitted, 120), '') AS [Mortgage!1!ApplicationSubmitted], 
	ISNULL(CONVERT(varchar(24), T1.ValuationInstructed, 120), '') AS [Mortgage!1!ValuationInstructed], 
	ISNULL(CONVERT(varchar(24), T1.ValuationDate, 120), '') AS [Mortgage!1!ValuationDate], 
	ISNULL(CONVERT(varchar(24), T1.ValuationReceived, 120), '') AS [Mortgage!1!ValuationReceived], 
	ISNULL(CONVERT(varchar(24), T1.OfferIssued, 120), '') AS [Mortgage!1!OfferIssued], 
	ISNULL(CONVERT(varchar(24), T1.ExchangeDate, 120), '') AS [Mortgage!1!ExchangeDate], 
	ISNULL(T1.IsCurrentResidence, '') AS [Mortgage!1!IsCurrentResidence], 
	ISNULL(T1.IsResdidenceAfterComplete, '') AS [Mortgage!1!IsResdidenceAfterComplete], 
	ISNULL(CONVERT(varchar(24), T1.CurrentBalance), '') AS [Mortgage!1!CurrentBalance], 
	ISNULL(T1.WillPayRedemption, '') AS [Mortgage!1!WillPayRedemption], 
	ISNULL(T1.WillBeDischarged, '') AS [Mortgage!1!WillBeDischarged], 
	ISNULL(CONVERT(varchar(24), T1.RedemptionAmount), '') AS [Mortgage!1!RedemptionAmount], 
	ISNULL(T1.StatusFg, '') AS [Mortgage!1!StatusFg], 
	ISNULL(T1.NonStatusFg, '') AS [Mortgage!1!NonStatusFg], 
	ISNULL(T1.SelfCertFg, '') AS [Mortgage!1!SelfCertFg], 
	T1.ConcurrencyId AS [Mortgage!1!ConcurrencyId]
	FROM TMortgage T1
	
	WHERE T1.MortgageId = @MortgageId
	ORDER BY [Mortgage!1!MortgageId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
