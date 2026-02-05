SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveQuotePensionByQuotePensionId]
	@QuotePensionId bigint
AS

SELECT T1.QuotePensionId, T1.QuoteItemId, T1.Contribution, T1.EmployerContribution, T1.RetirementAge, T1.TotalFundValue, 
	T1.Pension, T1.CashSum, T1.ReducedPension, T1.MediumGrowthRate, T1.ConcurrencyId
FROM TQuotePension  T1
WHERE T1.QuotePensionId = @QuotePensionId
GO
