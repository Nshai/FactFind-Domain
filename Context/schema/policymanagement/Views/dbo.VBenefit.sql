
CREATE View VBenefit
AS

SELECT 
    a.IndigoClientId,
    a.PolicyBusinessId,
    c.PensionCommencementLumpSum,
    c.PclsPaidById,
    c.GadMaximumIncomeLimit,
    c.GuaranteedMinimumIncome,
    c.GadCalculationDate,
    c.IsCapitalValueProtected,
    c.CapitalValueProtectedAmount,
    c.LumpSumDeathBenefitAmount,
    c.IsSpousesBenefit,
    c.IsOverlap,
    c.GuaranteedPeriod,
    c.IsProportion,
    c.SpousesOrDependentsPercentage,
    c.BenefitId,
	-- the following fields support the create in code using <sql-insert>
    0 AS StampUserId,
    0 AS PlanTypeId,
    b.PartyId AS AssuredLifePartyId
FROM TProtection a
LEFT JOIN TAssuredLife b ON a.ProtectionId = b.ProtectionId
LEFT JOIN TBenefit c ON b.BenefitId = c.BenefitId