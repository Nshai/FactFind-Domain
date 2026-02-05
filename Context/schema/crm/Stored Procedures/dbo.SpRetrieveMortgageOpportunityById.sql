SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveMortgageOpportunityById]
	@MortgageOpportunityId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.MortgageOpportunityId AS [MortgageOpportunity!1!MortgageOpportunityId], 
	T1.OpportunityId AS [MortgageOpportunity!1!OpportunityId], 
	ISNULL(T1.LoanPurpose, '') AS [MortgageOpportunity!1!LoanPurpose], 
	ISNULL(CONVERT(varchar(24), T1.LoanAmount), '') AS [MortgageOpportunity!1!LoanAmount], 
	ISNULL(CONVERT(varchar(24), T1.LTV), '') AS [MortgageOpportunity!1!LTV], 
	ISNULL(T1.RefMortgageBorrowerTypeId, '') AS [MortgageOpportunity!1!RefMortgageBorrowerTypeId], 
	ISNULL(T1.Term, '') AS [MortgageOpportunity!1!Term], 
	ISNULL(T1.RefMortgageRepaymentMethodId, '') AS [MortgageOpportunity!1!RefMortgageRepaymentMethodId], 
	ISNULL(CONVERT(varchar(24), T1.InterestOnly), '') AS [MortgageOpportunity!1!InterestOnly], 
	ISNULL(CONVERT(varchar(24), T1.Repayment), '') AS [MortgageOpportunity!1!Repayment], 
	ISNULL(CONVERT(varchar(24), T1.Price), '') AS [MortgageOpportunity!1!Price], 
	ISNULL(CONVERT(varchar(24), T1.Deposit), '') AS [MortgageOpportunity!1!Deposit], 
	ISNULL(T1.PlanPurpose, '') AS [MortgageOpportunity!1!PlanPurpose], 
	ISNULL(T1.CurrentLender, '') AS [MortgageOpportunity!1!CurrentLender], 
	ISNULL(CONVERT(varchar(24), T1.CurrentLoanAmount), '') AS [MortgageOpportunity!1!CurrentLoanAmount], 
	ISNULL(CONVERT(varchar(24), T1.MonthlyRentalIncome), '') AS [MortgageOpportunity!1!MonthlyRentalIncome], 
	ISNULL(T1.Owner, '') AS [MortgageOpportunity!1!Owner], 
	ISNULL(T1.RelationshipCRMContactId, '') AS [MortgageOpportunity!1!RelationshipCRMContactId], 
	ISNULL(T1.RefOpportunityEmploymentTypeId, '') AS [MortgageOpportunity!1!RefOpportunityEmploymentTypeId], 
	ISNULL(CONVERT(varchar(24), T1.IncomeAmount), '') AS [MortgageOpportunity!1!IncomeAmount], 
	ISNULL(CONVERT(varchar(24), T1.RepaymentAmountMonthly), '') AS [MortgageOpportunity!1!RepaymentAmountMonthly], 
	ISNULL(T1.StatusFg, '') AS [MortgageOpportunity!1!StatusFg], 
	ISNULL(T1.SelfCertFg, '') AS [MortgageOpportunity!1!SelfCertFg], 
	ISNULL(T1.NonStatusFg, '') AS [MortgageOpportunity!1!NonStatusFg], 
	ISNULL(T1.ExPatFg, '') AS [MortgageOpportunity!1!ExPatFg], 
	ISNULL(T1.ForeignCitizenFg, '') AS [MortgageOpportunity!1!ForeignCitizenFg], 
	ISNULL(T1.TrueCostOverTerm, '') AS [MortgageOpportunity!1!TrueCostOverTerm], 
	T1.ConcurrencyId AS [MortgageOpportunity!1!ConcurrencyId]
	FROM TMortgageOpportunity T1
	
	WHERE T1.MortgageOpportunityId = @MortgageOpportunityId
	ORDER BY [MortgageOpportunity!1!MortgageOpportunityId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
