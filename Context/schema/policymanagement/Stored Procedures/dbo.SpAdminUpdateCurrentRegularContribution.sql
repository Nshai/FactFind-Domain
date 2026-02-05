SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpAdminUpdateCurrentRegularContribution]
AS
-----------------------------------
-- Declarations
-----------------------------------
DECLARE @CurrentDateTime datetime
-- Temp table to hold current contribution ids
CREATE TABLE #CurrentContributions(
	Id bigint, RefContributorTypeId bigint
)

-----------------------------------
-- Find Current Contributions
-----------------------------------
SET @CurrentDateTime = GETDATE()
INSERT INTO #CurrentContributions 
SELECT
	-- Use max here because there is some invalid data in the system
	-- which means that more than one contribution is current.
	MAX(PolicyMoneyInId),
	RefContributorTypeId
FROM
	TPolicyMoneyIn
WHERE
	@CurrentDateTime BETWEEN StartDate AND ISNULL(StopDate, GETDATE()) -- Currently active
	AND RefContributionTypeId = 1 -- Regular
	AND RefFrequencyId NOT IN (9, 10) -- Not Single
GROUP BY
	PolicyBusinessId, RefContributorTypeId -- Self, Employer etc	
	
----------------------------------------------------------
-- Audit existing contributions that are marked as current
----------------------------------------------------------		
INSERT INTO TPolicyMoneyInAudit (
	Amount, EscalationPercentage, RefFrequencyId, StartDate, PolicyBusinessId, RefTaxBasisId, RefTaxYearId, RefContributionTypeId, RefContributorTypeId, CurrentFg, RefEscalationTypeId, SalaryPercentage, StopDate, ConcurrencyId, PolicyMoneyInId, StampAction, StampDateTime, StampUser, IsFullTransfer, RefTransferTypeId)
SELECT
	Amount, EscalationPercentage, RefFrequencyId, StartDate, PolicyBusinessId, RefTaxBasisId, RefTaxYearId, RefContributionTypeId, A.RefContributorTypeId, CurrentFg, RefEscalationTypeId, SalaryPercentage, StopDate, ConcurrencyId, PolicyMoneyInId, 'U', GETDATE(), 0, A.IsFullTransfer, A.RefTransferTypeId
FROM
	TPolicyMoneyIn A
	LEFT JOIN #CurrentContributions B ON B.Id = A.PolicyMoneyInId
WHERE
	RefContributionTypeId = 1 -- Regular
	AND RefFrequencyId NOT IN (9, 10) -- Not Single
	AND CurrentFg = 1	-- Currently marked as current...
	AND B.Id IS NULL	-- ... but no longer current

----------------------------------------------------------
-- Update existing contributions that are no longer current
----------------------------------------------------------		
UPDATE
	A
SET
	CurrentFg = 0,
	ConcurrencyId = ConcurrencyId + 1
FROM		
	TPolicyMoneyIn A
	LEFT JOIN #CurrentContributions B ON B.Id = A.PolicyMoneyInId
WHERE
	RefContributionTypeId = 1 -- Regular
	AND RefFrequencyId NOT IN (9, 10) -- Not Single
	AND CurrentFg = 1	-- Currently marked as current...
	AND B.Id IS NULL	-- ... but no longer current
	
----------------------------------------------------------
-- Audit existing contributions that are not correctly marked as active
----------------------------------------------------------		
INSERT INTO TPolicyMoneyInAudit (
	Amount, EscalationPercentage, RefFrequencyId, StartDate, PolicyBusinessId, RefTaxBasisId, RefTaxYearId, RefContributionTypeId, 
	RefContributorTypeId, CurrentFg, RefEscalationTypeId, SalaryPercentage, StopDate, ConcurrencyId, PolicyMoneyInId, StampAction,
	StampDateTime, StampUser, IsFullTransfer, RefTransferTypeId)
SELECT
	Amount, EscalationPercentage, RefFrequencyId, StartDate, PolicyBusinessId, RefTaxBasisId, RefTaxYearId, RefContributionTypeId, 
	A.RefContributorTypeId, CurrentFg, RefEscalationTypeId, SalaryPercentage, StopDate, ConcurrencyId, PolicyMoneyInId, 'U', GETDATE(), 0,
	A.IsFullTransfer, A.RefTransferTypeId
FROM
	TPolicyMoneyIn A
	JOIN #CurrentContributions B ON B.Id = A.PolicyMoneyInId -- Should be current
WHERE
	RefContributionTypeId = 1 -- Regular
	AND RefFrequencyId NOT IN (9, 10) -- Not Single
	AND CurrentFg = 0	-- Currently not marked as current but should be
	
----------------------------------------------------------
-- Update contributions that should be marked as current
----------------------------------------------------------		
UPDATE
	A
SET
	CurrentFg = 1,
	ConcurrencyId = ConcurrencyId + 1
FROM		
	TPolicyMoneyIn A
	JOIN #CurrentContributions B ON B.Id = A.PolicyMoneyInId -- Should be current
WHERE
	RefContributionTypeId = 1 -- Regular
	AND RefFrequencyId NOT IN (9, 10) -- Not Single
	AND CurrentFg = 0	-- Currently not marked as current but should be			

----------------------------------------------------------
-- Update the plan summary fields with the correct amounts
----------------------------------------------------------
INSERT INTO TPolicyBusinessAudit (
	PolicyDetailId, PolicyNumber, PractitionerId, ReplaceNotes, TnCCoachId, AdviceTypeId, BestAdvicePanelUsedFG, WaiverDefermentPeriod, IndigoClientId, SwitchFG, 
	TotalRegularPremium, TotalLumpSum, MaturityDate, LifeCycleId, PolicyStartDate, PremiumType, AgencyNumber, ProviderAddress, OffPanelFg, BaseCurrency, ExpectedPaymentDate, 
	ProductName, InvestmentTypeId, RiskRating, SequentialRef, ConcurrencyId, PolicyBusinessId, StampAction, StampDateTime, StampUser)
SELECT	
	PolicyDetailId, PolicyNumber, PractitionerId, ReplaceNotes, TnCCoachId, AdviceTypeId, BestAdvicePanelUsedFG, WaiverDefermentPeriod, IndigoClientId, SwitchFG, 
	TotalRegularPremium, TotalLumpSum, MaturityDate, LifeCycleId, PolicyStartDate, PremiumType, AgencyNumber, ProviderAddress, OffPanelFg, BaseCurrency, ExpectedPaymentDate, 
	ProductName, InvestmentTypeId, RiskRating, SequentialRef, PB.ConcurrencyId, PB.PolicyBusinessId, 'U', GETDATE(), 0
FROM
	TPolicyBusiness PB
	JOIN TPolicyMoneyIn PMI ON PMI.PolicyBusinessId = PB.PolicyBusinessId AND PMI.CurrentFg = 1 AND PMI.RefContributorTypeId = 1
	JOIN #CurrentContributions CC ON CC.Id = PMI.PolicyMoneyInId 
	LEFT JOIN TRefFrequency F ON F.RefFrequencyId = PMI.RefFrequencyId
WHERE
	ISNULL(PB.TotalRegularPremium, -1) != ISNULL(PMI.Amount, -1)
	OR ISNULL(F.FrequencyName, '') != ISNULL(PB.PremiumType, '')

UPDATE
	PB
SET
	TotalRegularPremium = PMI.Amount,
	PremiumType = F.FrequencyName,
	ConcurrencyId = PB.ConcurrencyId + 1
FROM		
	TPolicyBusiness PB
	JOIN TPolicyMoneyIn PMI ON PMI.PolicyBusinessId = PB.PolicyBusinessId AND PMI.CurrentFg = 1 AND PMI.RefContributorTypeId = 1
	JOIN #CurrentContributions CC ON CC.Id = PMI.PolicyMoneyInId
	LEFT JOIN TRefFrequency F ON F.RefFrequencyId = PMI.RefFrequencyId
WHERE
	ISNULL(PB.TotalRegularPremium, -1) != ISNULL(PMI.Amount, -1)
	OR ISNULL(F.FrequencyName, '') != ISNULL(PB.PremiumType, '')
	
--Calling Lumsum update proc to sync Lumsum total between PMI and PB tables
EXEC SpAdminUpdateLumpsumContribution

GO
