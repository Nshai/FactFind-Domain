USE PolicyManagement

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_RetrieveClientAndPlanProtectionDataByTenantId]             
 @TenantId bigint 
AS          

SELECT DISTINCT
	--Plan Owner
	ISNULL(CRM.ExternalReference, '') AS 'Owner 1 Client Reference',
	ISNULL(CRM.AdditionalRef, '') AS 'Owner 1 Secondary Reference',
	isnull(CRM.CorporateName,'') + isnull(CRM.FirstName,'') + ' ' + isnull(CRM.LastName,'') AS 'Owner 1 Full Name',
	
	--Plan Details	
	S.Name AS 'Plan Status',
	PB.PolicyBusinessId,
	ISNULL(ExpComm.TotalIndemnity, 0) + ISNULL(ExpComm1.TotalLevel, 0) AS 'Expected Commission - Total Initial',
	ISNULL(PSumm.AmountReceived, 0) AS 'Commission - Total Received',
	
	--Plan Selling Adviser
	isnull(PractC.CorporateName,'') + isnull(PractC.FirstName,'') + ' ' + isnull(PractC.LastName,'') AS 'Selling Adviser Name',
	
	ISNULL(PB.PolicyNumber, '') AS 'Policy Number',
	
	Prov.CorporateName AS 'Provider Name',
	RPT.PlanTypeName AS 'Plan Type',
	
	ISNULL(PMI.Amount, 0)                AS 'Total Regular Premium',
	ISNULL(PMI2.LumpSumAmount,0)         AS 'Total Lump Sum',    
	
	CASE WHEN PoliciesWithTopUps.PolicyDetailId IS NOT NULL THEN 'True' ELSE 'False' END AS 'Is Top Up',
	
	ISNULL(PB.PolicyStartDate, '') AS 'Policy Start Date',
	ISNULL(PB.MaturityDate, '') AS 'Maturity Date',
	
	ISNULL(AC.CaseName, '') AS 'Advice Case Name',
	ISNULL(SH.ChangedToDate, '') AS 'Plan Status Date',
	
	ISNULL(PMI4.AnnualisedPremium, 0) AS 'Annualised Premium',
	ISNULL(PMI3.CurrentRegularPremium, 0) AS 'Current Regular Premium',
	
	ISNULL(pp.lifecoversumassured, 0) AS 'Life Cover Sum Assured',
	ISNULL(pp.termvalue, 0) AS 'Life Cover Term (yrs)',
	ISNULL(pp.criticalillnesssumassured, 0) AS 'Critical Illness Sum Assured',
	ISNULL(pp.CriticalIllnessTermValue, 0) AS 'Critical Illness Term (yrs)',
	isnull(PayB.RefPaymentBasisName, '') AS 'Payment Basis',
	ISNULL(IndType.IndexTypeName, '') AS 'Index Type'

FROM dbo.TPolicyBusiness PB
	JOIN dbo.TPolicyDetail PD ON PB.PolicyDetailId = PD.PolicyDetailId
	
	--Plan Status	
	JOIN dbo.TStatusHistory SH ON SH.PolicyBusinessId = PB.PolicyBusinessId AND SH.CurrentStatusFG = 1
	JOIN dbo.TStatus S ON S.StatusId = SH.StatusId
	
	--Plan Owner
	JOIN dbo.TPolicyOwner PO ON PD.PolicyDetailId = PO.PolicyDetailId
	JOIN CRM.dbo.TCRMContact CRM ON CRM.CRMContactId = PO.CRMContactId
	
	--Plan Selling Adviser	
    LEFT JOIN CRM.dbo.TPractitioner Pract On Pract.PractitionerId = PB.PractitionerId
    LEFT JOIN CRM.dbo.TCRMContact PractC ON PractC.CRMContactId = Pract.CRMContactId
    
	--Plan Provider and PlanType
	JOIN dbo.TPlanDescription PDesc ON PDesc.PlanDescriptionId = PD.PlanDescriptionId
	JOIN dbo.TRefPlanType2ProdSubType PT2PST ON PT2PST.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId
	JOIN dbo.TRefPlanType RPT ON RPT.RefPlanTypeId = PT2PST.RefPlanTypeId
		
	JOIN dbo.TRefProdProvider RPP ON RPP.RefProdProviderId = PDesc.RefProdProviderId
	JOIN CRM.dbo.TCRMContact Prov ON Prov.CRMContactId = RPP.CRMContactId
	
	--Advice Case
	LEFT JOIN CRM.dbo.TAdviceCasePlan AP ON AP.PolicyBusinessId = PB.PolicyBusinessId
    LEFT JOIN CRM.dbo.TAdviceCase AC ON AC.AdviceCaseId = AP.AdviceCaseId	
    
    --Is Top up
	LEFT JOIN 
		(
		SELECT
			PDet1.PolicyDetailId,
			Min(PolicyBusinessId) AS MainPolicyBusinessId,
			Max(PolicyBusinessId) AS LastTopUpPolicyBusinessId
		FROM dbo.TPolicyOwner PO1
			JOIN dbo.TPolicyDetail PDet1 ON PDet1.PolicyDetailId = PO1.PolicyDetailId
			JOIN dbo.TPolicyBusiness PB1 ON PB1.PolicyDetailId = Pdet1.PolicyDetailId
		WHERE PB1.IndigoClientId = @TenantId
		GROUP BY PDet1.PolicyDetailId
		HAVING Min(PolicyBusinessId) != Max(PolicyBusinessId)
		) PoliciesWithTopUps ON PoliciesWithTopUps.PolicyDetailId = PB.PolicyDetailId

	--Contributions - Total Regular Premium and Total Lump Sum
	LEFT JOIN dbo.TPolicyMoneyIn PMI ON PMI.PolicyBusinessId = PB.PolicyBusinessId
		AND PMI.CurrentFG = 1
		AND PMI.RefContributionTypeId = 1 -- Regular Contribution
		AND PMI.RefContributorTypeId = 1 -- Self Contributions
		AND PMI.RefFrequencyId != 10 -- Exclude single frequency
    LEFT JOIN 
		(
		SELECT PMIL.PolicyBusinessId, SUM(Amount) As LumpSumAmount
			FROM dbo.TPolicyMoneyIn PMIL
		WHERE PMIL.RefContributorTypeId = 1 -- Self Contributions
				AND
				(
					PMIL.RefContributionTypeId = 2 -- Lump Sum Contribution
					OR
					(
						PMIL.RefContributionTypeId = 1 -- Regular Contribution 
						AND PMIL.RefFrequencyId = 10 -- Single Frequency
					)
				)
			GROUP BY PMIL.PolicyBusinessId
		) AS PMI2 ON PMI2.PolicyBusinessId = PB.PolicyBusinessId
	
	--Current Regular Premium
	LEFT JOIN 
		(
		SELECT PMIL.PolicyBusinessId, SUM(Amount) As CurrentRegularPremium
			FROM dbo.TPolicyMoneyIn PMIL
		WHERE PMIL.RefContributionTypeId = 1 -- Regular Contribution 			
			GROUP BY PMIL.PolicyBusinessId
		) AS PMI3 ON PMI3.PolicyBusinessId = PB.PolicyBusinessId
		
	--Annualised Premium
	LEFT JOIN 
		(
		SELECT PMIL.PolicyBusinessId, 
			SUM(CASE 
				WHEN PMIL.RefFrequencyId = 1 THEN PMIL.Amount * 52
				WHEN PMIL.RefFrequencyId = 2 THEN PMIL.Amount * 26
				WHEN PMIL.RefFrequencyId = 3 THEN PMIL.Amount * 13
				WHEN PMIL.RefFrequencyId = 4 THEN PMIL.Amount * 12
				WHEN PMIL.RefFrequencyId = 5 THEN PMIL.Amount * 4
				WHEN PMIL.RefFrequencyId = 7 THEN PMIL.Amount * 2
				WHEN PMIL.RefFrequencyId = 8 THEN PMIL.Amount
				ELSE 0
			END) AS AnnualisedPremium			
		FROM dbo.TPolicyMoneyIn PMIL
		WHERE PMIL.RefContributionTypeId = 1 -- Regular Contribution 			
			AND (PMIL.RefFrequencyId IS NOT NULL
					AND (PMIL.StopDate IS NULL OR PMIL.StopDate > GETDATE())
					AND (PMIL.StartDate <= GETDATE() OR PMIL.StartDate IS NULL)
				)
			GROUP BY PMIL.PolicyBusinessId
		) AS PMI4 ON PMI4.PolicyBusinessId = PB.PolicyBusinessId
	
	--Expected Commission - Total Initial
	LEFT JOIN (
		SELECT pec.PolicyBusinessId,
				SUM(CASE 
				WHEN pec.RefFrequencyId = 1 THEN pec.ExpectedAmount * 52
				WHEN pec.RefFrequencyId = 2 THEN pec.ExpectedAmount * 26
				WHEN pec.RefFrequencyId = 3 THEN pec.ExpectedAmount * 13
				WHEN pec.RefFrequencyId = 4 THEN pec.ExpectedAmount * 12
				WHEN pec.RefFrequencyId = 5 THEN pec.ExpectedAmount * 4
				WHEN pec.RefFrequencyId = 7 THEN pec.ExpectedAmount * 2
				WHEN pec.RefFrequencyId = 8 THEN pec.ExpectedAmount
				WHEN pec.RefFrequencyId = 10 THEN pec.ExpectedAmount
				ELSE 0
				END) AS TotalIndemnity
			FROM dbo.TPolicyExpectedCommission pec
			WHERE pec.RefCommissionTypeId IN (4) -- Level
			GROUP BY pec.PolicyBusinessId
		) AS ExpComm ON ExpComm.PolicyBusinessId = PB.PolicyBusinessId	
		LEFT JOIN (
		SELECT pec.PolicyBusinessId,
				SUM(pec.ExpectedAmount) AS TotalLevel
			FROM dbo.TPolicyExpectedCommission pec
			WHERE pec.RefCommissionTypeId IN (1) -- Indemnity
			GROUP BY pec.PolicyBusinessId
		) AS ExpComm1 ON ExpComm1.PolicyBusinessId = PB.PolicyBusinessId		
	
	--Commission - Total Received
	LEFT JOIN Commissions.dbo.TPaymentSummary PSumm ON PSumm.PolicyId = PB.PolicyBusinessId
	
	--Protection
	LEFT JOIN dbo.TProtection pp ON pp.policybusinessid = PB.policybusinessid AND pp.refplansubcategoryid = 51
    LEFT JOIN dbo.tassuredlife al1 ON al1.protectionid = pp.protectionid AND al1.orderkey = 1
    LEFT JOIN dbo.tbenefit b1 ON b1.benefitid = al1.benefitid
    LEFT JOIN dbo.tassuredlife al2 ON al2.protectionid = pp.protectionid AND al1.orderkey = 2
    LEFT JOIN dbo.tbenefit b2 ON b2.benefitid = al2.benefitid
	
	LEFT JOIN dbo.TRefIndexType IndType ON IndType.RefIndexTypeId = pp.IndexTypeId
	LEFT JOIN dbo.TRefPaymentBasis PayB ON PayB.RefPaymentBasisId = pp.PaymentBasisId	

WHERE PB.IndigoClientId = @TenantId

GO
