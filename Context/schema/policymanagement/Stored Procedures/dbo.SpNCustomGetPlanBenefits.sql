
--use policymanagement
 
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetPlanBenefits]	
	@PolicyBusinessIds  VARCHAR(8000),
	@TenantId BIGINT
AS


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

--DECLARE @PolicyBusinessIds  VARCHAR(8000) = '16, 22, 25, 26, 27, 28, 29, 32, 33, 34, 35, 43, 44, 47, 49, 50, 53, 54, 55, 56, 57, 58, 59, 64, 65, 66, 67, 68, 69, 70, 71, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 89, 87, 88, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 126, 127, 128, 129, 130, 131, 132, 138, 139, 140, 141, 142, 143, 144, 145, 146, 1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308, 1309, 1310, 1311, 1312, 1313, 1316, 1314, 1315, 1317, 1318, 1319, 1320'
--DECLARE @TenantId bigint = 10155

DECLARE  @pbs TABLE(PolicyBusinessId INT) 
INSERT INTO @pbs(PolicyBusinessId)
SELECT
CAST(ISNULL(Value, '0') AS INT)  
FROM policymanagement..FnSplit(@PolicyBusinessIds, ',')


IF(OBJECT_ID('tempdb..#CrmContact') IS NOT NULL)
DROP TABLE #CrmContact
		
SELECT DISTINCT 
c.CrmContactId, c.FirstName, c.LastName, c.CorporateName as TrustName
INTO #CrmContact 
FROM Crm..TCRMContact c
JOIN TAssuredLife AL on c.CRMContactId = al.PartyId
JOIN TProtection P on P.ProtectionId = al.ProtectionId
JOIN @pbs PL on Pl.PolicyBusinessId = p.PolicyBusinessId
WHERE c.IndClientId = @TenantId
GROUP BY c.CrmContactId, c.FirstName, c.LastName, c.CorporateName

SELECT 
    Pb.PolicyBusinessId as PolicyBusinessId,
    prp.CriticalIllnessTermValue as CriticalIllnessTerm,
    prp.CriticalIllnessSumAssured as CriticalIllnessAmount,
    prp.CriticalIllnessUntilAge as CriticalIllnessUntilAge,
    prp.CriticalIllnessPremiumStructure as CriticalIllnessPremiumStructure,
    prp.TermValue as LifeCoverTerm,
    prp.LifeCoverSumAssured as LifeCoverSumAssured,
    prp.LifeCoverUntilAge as LifeCoverUntilAge,
    prp.LifeCoverPremiumStructure as LifeCoverPremiumStructure,
    prp.TermValue as PhiTerm,
    b1.BenefitAmount as PhiAmount,
    b1.BenefitAmount as BenefitAmount,
    b1.BenefitDeferredPeriod as BenefitDeferredPeriod,
    coalesce(alc1.FirstName+' '+ alc1.LastName,
			al1.FirstName+ ' '+al1.LastName,
			alc1.TrustName) as LifeAssured1Name,
    coalesce(alc2.FirstName+' '+ alc2.LastName,
			al2.FirstName+ ' '+al2.LastName,
			alc2.TrustName)	as LifeAssured2Name,
    bq1.QualificationPeriod as QualificationPeriodValue,
    Gi.GiSumAssured as GISumAssured,
    bp1.Descriptor as BenefitPeriodValue,
    b1.OtherBenefitPeriodText as BenefitPeriodOtherValue,
    bf1.FrequencyName as BenefitFrequencyValue,
    b1.BenefitAmount as FamilyIncomeBenefitAmount,
    b1.RefFrequencyId as FamilyIncomeBenefitFrequency,
    prp.InTrust as InTrust,
    b1.PremiumWaiverWoc as PremiumWaiverWoc1,
    b2.PremiumWaiverWoc as PremiumWaiverWoc2,
    prp.ExpensePremiumStructure as ExpensePremiumStructure,
    prp.ExpenseCoverTerm as ExpenseCoverTerm,
    prp.ExpenseCoverUntilAge as ExpenseCoverUntilAge,
    prp.ProtectionPayoutType as ProtectionPayoutType,
    prp.IncomePremiumStructure as IncomePremiumStructure,
    prp.IncomeCoverTerm as IncomeCoverTerm,
    prp.IncomeCoverUntilAge as IncomeCoverUntilAge,
    prp.SeverityCoverPremiumStructure as SeverityCoverPremiumStructure,
    prp.SeverityCoverAmount as SeverityCoverAmount,
    prp.SeverityCoverTerm as SeverityCoverTerm,
    prp.SeverityCoverUntilAge as SeverityCoverUntilAge,
    prp.PtdCoverPremiumStructure as PtdCoverPremiumStructure,
    prp.PtdCoverAmount as PtdCoverAmount,
    prp.PtdCoverTerm as PtdCoverTerm,
    prp.PtdCoverUntilAge as PtdCoverUntilAge,
    PDesc.RefPlanType2ProdSubTypeId as PlanTypeProdSubTypeId,
    b1.DeferredPeriodIntervalId as DeferredPeriodIntervalId,
    b1.RefTotalPermanentDisabilityTypeId as TPDType1Id,
    b2.RefTotalPermanentDisabilityTypeId as TPDType2Id
FROM                                  
    TPolicyBusiness Pb WITH(NOLOCK)     
    JOIN @pbs pl on pl.PolicyBusinessId = pb.PolicyBusinessId      
    JOIN TPolicyDetail pd WITH(NOLOCK) ON pd.PolicyDetailId = pb.PolicyDetailId              
    JOIN TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = pd.PlanDescriptionId   
    JOIN TProtection prp ON prp.PolicyBusinessId = pb.PolicyBusinessId and prp.IndigoClientId= @TenantId
    LEFT JOIN (
    Select
    AssuredLife1Id = min(a.AssuredLifeId),
    AssuredLife2Id = Case When max(a.AssuredLifeId) = min(a.AssuredLifeId) Then null Else max(a.AssuredLifeId) End,
    b.PolicyBusinessId,
	b.ProtectionId
    From
    tAssuredLife a
    JOIN
    tprotection b on a.protectionid = b.protectionid
	JOIN @pbs pb on pb.PolicyBusinessId = b.policybusinessid
    Where
    b.IndigoClientId = @TenantId  
    Group By
    b.PolicyBusinessId, b.ProtectionId
 )  as lives ON lives.PolicyBusinessId = Pb.PolicyBusinessId and prp.ProtectionId = lives.ProtectionId

LEFT JOIN tAssuredLife al1 ON al1.AssuredLifeId = lives.AssuredLife1Id and al1.IndigoClientId =@TenantId
LEFT JOIN #CrmContact alc1 ON alc1.CRMContactId = al1.PartyId 
LEFT JOIN tbenefit b1 ON b1.benefitid = al1.benefitid and b1.IndigoClientId = @TenantId
LEFT JOIN tAssuredLife al2 ON al2.AssuredLifeId = lives.AssuredLife2Id and al2.IndigoClientId = @TenantId
LEFT JOIN #CrmContact alc2 ON alc2.CRMContactId = al2.PartyId 
LEFT JOIN tbenefit b2 ON b2.benefitid = al2.benefitid and b2.IndigoClientId =@TenantId

LEFT JOIN TRefQualificationPeriod bq1 ON bq1.RefQualificationPeriodId = b1.RefQualificationPeriodId
LEFT JOIN TRefBenefitPeriod bp1 ON bp1.RefBenefitPeriodId = b1.RefBenefitPeriodId
LEFT JOIN TRefFrequency bf1 ON bf1.RefFrequencyId = b1.RefFrequencyId
LEFT JOIN 
(
    Select
    GiSumAssured = SuM(a.SumAssured),
    a.ProtectionId
    From
    TGeneralInsuranceDetail a
    JOIN
    tprotection b on a.protectionid = b.protectionid
	JOIN @pbs pb on pb.PolicyBusinessId = b.policybusinessid
    Where
    b.IndigoClientId = @TenantId  
    Group By a.ProtectionId
)   as Gi ON Gi.ProtectionId = prp.ProtectionId

WHERE PB.IndigoClientId = @TenantId