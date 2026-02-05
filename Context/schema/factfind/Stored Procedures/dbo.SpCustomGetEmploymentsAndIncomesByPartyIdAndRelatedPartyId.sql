SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetEmploymentsAndIncomesByPartyIdAndRelatedPartyId]	

	@PartyId bigint,
	@RelatedPartyId bigint = null,
	@TenantId bigint
AS

DECLARE @IncomeDetails TABLE (
	IncomeId INT NOT NULL,
	EmploymentDetailId INT NOT NULL,
	IncomeType VARCHAR(255) NULL,
	YearNumber BIGINT NOT NULL,
	Amount MONEY NULL,
	YearEnd DATETIME NULL
)

INSERT @IncomeDetails
SELECT tdib.DetailedincomebreakdownId, ted.EmploymentDetailId, tdib.IncomeType, DENSE_RANK() OVER (PARTITION BY tdib.CrmContactId, tdib.EmploymentDetailIdValue ORDER BY tdib.EndDate DESC), tdib.NetAmount, tdib.EndDate
FROM TDetailedincomebreakdown tdib
JOIN TEmploymentDetail ted on tdib.EmploymentDetailIdValue = ted.EmploymentDetailId
WHERE ted.CRMContactId = @PartyId OR (@RelatedPartyId IS NOT NULL AND ted.CRMContactId = @RelatedPartyId)

SELECT t.EmploymentDetailId as Id,
		t.CRMContactId as PartyId,
		t.Employer,
		t.EmploymentStatus,
		COALESCE(t.Role, oc.Description) As Occupation,
		t.GrossAnnualEarnings AS TotalGrossAnnualEarning,
		t.IntendedRetirementAge,
		t.StartDate, 
		t.EndDate,
		t.OtherGrossIncome,
		t.InProbation,
		t.ProbationPeriodMonths AS ProbationPeriod,
		t.EmployerAddressLine1 AS AddressLine1,
		t.EmployerAddressLine2 AS AddressLine2,
		t.EmployerAddressLine3 AS AddressLine3,
		t.EmployerAddressLine4 AS AddressLine4,
		t.EmployerCityTown AS CityOrTown,
		county.CountyCode AS CountyCode,
		country.CountryCode AS CountryCode,
		t.EmployerPostcode AS Postcode,
		t.EmploymentBusinessType AS BusinessType,
		year1NetProfit.Amount as MostRecentAnnualAccountsNetProfit,
		year1NetDividend.Amount as MostRecentAnnualAccountsNetDividend,
		CASE
			WHEN year1Salary.Amount IS NOT NULL THEN year1Salary.Amount
			ELSE year1BasicSalary.Amount
		END AS MostRecentAnnualAccountsSalary,
		COALESCE(year1NetProfit.YearEnd, year1NetDividend.YearEnd, year1Salary.YearEnd) AS MostRecentAnnualAccountsYearEnd,
		year2NetProfit.Amount as Year2AnnualAccountsNetProfit,
		year2NetDividend.Amount as Year2AnnualAccountsNetDividend,
		CASE
			WHEN year2Salary.Amount IS NOT NULL THEN year2Salary.Amount
			ELSE year2BasicSalary.Amount
		END AS Year2AnnualAccountsSalary,
		COALESCE(year2NetProfit.YearEnd, year2NetDividend.YearEnd, year2Salary.YearEnd) AS Year2YearEnd,
		year3NetProfit.Amount as Year3AnnualAccountsNetProfit,
		year3NetDividend.Amount as Year3AnnualAccountsNetDividend,
		CASE
			WHEN year3Salary.Amount IS NOT NULL THEN year3Salary.Amount
			ELSE year3BasicSalary.Amount
		END AS Year3AnnualAccountsSalary,
		COALESCE(year3NetProfit.YearEnd, year3NetDividend.YearEnd, year3Salary.YearEnd) AS Year3YearEnd,
		t.BasicAnnualIncome AS BasicGrossAnnualIncome,
		t.NetBasicMonthlyIncome AS BasicNetMonthlyIncome,
		t.NetBasicMonthlyIncomeInAffordability AS IncludeBasicNetMonthlyIncomeInAffordability,
		t.AnyOvertimeIncome AS HasOvertimeIncome,
		t.GuaranteedOvertime AS GuaranteedGrossAnnualOvertimeIncome,
		t.NetGuaranteedOvertime AS GuaranteedNetMonthlyOvertimeIncome,
		t.NetGuaranteedOvertimeInAffordability AS IncludeGuaranteedNetMonthlyOvertimeIncomeInAffordability,
		t.RegularOvertime AS RegularGrossAnnualOvertimeIncome,
		t.NetRegularOvertime AS RegularNetMonthlyOvertimeIncome,
		t.NetRegularOvertimeInAffordability AS IncludeRegularNetMonthlyOvertimeIncomeInAffordability,
		t.AnyBonusIncome AS HasBonusIncome,
		t.GuaranteedBonus AS GuaranteedGrossAnnualBonusIncome,
		t.NetGuaranteedBonus AS GuaranteedNetMonthlyBonusIncome,
		t.NetGuaranteedBonusInAffordability AS IncludeGuaranteedNetMonthlyBonusIncomeInAffordability,
		t.RegularBonus AS RegularGrossAnnualBonusIncome,
		t.NetRegularBonus AS RegularNetMonthlyBonusIncome,
		t.NetRegularBonusInAffordability AS IncludeRegularNetMonthlyBonusIncomeInAffordability
FROM TEmploymentDetail t
LEFT JOIN @IncomeDetails year1NetProfit on year1NetProfit.EmploymentDetailId = t.EmploymentDetailId and year1NetProfit.YearNumber = 1 and year1NetProfit.IncomeType = 'Income earned as a partner/sole proprietor'
LEFT JOIN @IncomeDetails year2NetProfit on year2NetProfit.EmploymentDetailId = t.EmploymentDetailId and year2NetProfit.YearNumber = 2 and year2NetProfit.IncomeType = 'Income earned as a partner/sole proprietor'
LEFT JOIN @IncomeDetails year3NetProfit on year3NetProfit.EmploymentDetailId = t.EmploymentDetailId and year3NetProfit.YearNumber = 3 and year3NetProfit.IncomeType = 'Income earned as a partner/sole proprietor'
LEFT JOIN @IncomeDetails year1Salary on year1Salary.EmploymentDetailId = t.EmploymentDetailId and year1Salary.YearNumber = 1 and year1Salary.IncomeType = 'Wage/Salary (net)'
LEFT JOIN @IncomeDetails year2Salary on year2Salary.EmploymentDetailId = t.EmploymentDetailId and year2Salary.YearNumber = 2 and year2Salary.IncomeType = 'Wage/Salary (net)'
LEFT JOIN @IncomeDetails year3Salary on year3Salary.EmploymentDetailId = t.EmploymentDetailId and year3Salary.YearNumber = 3 and year3Salary.IncomeType = 'Wage/Salary (net)'
LEFT JOIN @IncomeDetails year1BasicSalary on year1BasicSalary.EmploymentDetailId = t.EmploymentDetailId and year1BasicSalary.YearNumber = 1 and year1BasicSalary.IncomeType = 'Basic Income'
LEFT JOIN @IncomeDetails year2BasicSalary on year2BasicSalary.EmploymentDetailId = t.EmploymentDetailId and year2BasicSalary.YearNumber = 2 and year2BasicSalary.IncomeType = 'Basic Income'
LEFT JOIN @IncomeDetails year3BasicSalary on year3BasicSalary.EmploymentDetailId = t.EmploymentDetailId and year3BasicSalary.YearNumber = 3 and year3BasicSalary.IncomeType = 'Basic Income'
LEFT JOIN @IncomeDetails year1NetDividend on year1NetDividend.EmploymentDetailId = t.EmploymentDetailId and year1NetDividend.YearNumber = 1 and year1NetDividend.IncomeType = 'Dividends'
LEFT JOIN @IncomeDetails year2NetDividend on year2NetDividend.EmploymentDetailId = t.EmploymentDetailId and year2NetDividend.YearNumber = 2 and year2NetDividend.IncomeType = 'Dividends'
LEFT JOIN @IncomeDetails year3NetDividend on year3NetDividend.EmploymentDetailId = t.EmploymentDetailId and year3NetDividend.YearNumber = 3 and year3NetDividend.IncomeType = 'Dividends'
LEFT JOIN crm..TRefOccupation oc on t.RefOccupationId = oc.RefOccupationId
LEFT JOIN crm..TRefCountry country on t.RefCountryId = country.RefCountryId
LEFT JOIN crm..TRefCounty county on t.RefCountyId = county.RefCountyId
WHERE t.CRMContactId = @PartyId OR (@RelatedPartyId IS NOT NULL AND t.CRMContactId = @RelatedPartyId)
GO