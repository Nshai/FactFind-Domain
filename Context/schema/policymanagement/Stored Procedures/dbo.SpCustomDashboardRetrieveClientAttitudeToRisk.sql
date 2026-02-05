SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].SpCustomDashboardRetrieveClientAttitudeToRisk
	@TenantId BIGINT
	, @cid BIGINT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT TOP 1
  CASE WHEN atrts.AtrRefProfilePreferenceId = 1 THEN CAST(aigrpcGenerated.RiskNumber AS VARCHAR(10)) + ' - ' + aigrpcGenerated.BriefDescription ELSE NULL END GeneratedRiskProfile
  , CASE WHEN atrts.AtrRefProfilePreferenceId = 1 THEN CAST(aigrpcChosen.RiskNumber AS VARCHAR(10)) + ' - ' + aigrpcChosen.BriefDescription ELSE NULL END ChosenRiskProfile
  , CASE WHEN atrts.AtrRefProfilePreferenceId = 1 THEN aig.DateOfRiskAssessment ELSE NULL END DateCompleted

  , CASE WHEN atrts.AtrRefProfilePreferenceId = 2 THEN CAST(aigrpcGenerated.RiskNumber AS VARCHAR(10)) + ' - ' + aigrpcGenerated.BriefDescription ELSE NULL END GeneratedInvestmentRiskProfile
  , CASE WHEN atrts.AtrRefProfilePreferenceId = 2 THEN CAST(aigrpcChosen.RiskNumber AS VARCHAR(10)) + ' - ' + aigrpcChosen.BriefDescription ELSE NULL END ChosenInvestmentRiskProfile
  , CASE WHEN atrts.AtrRefProfilePreferenceId = 2 THEN aig.DateOfRiskAssessment ELSE NULL END RetirementDateCompleted

  , CASE WHEN atrts.AtrRefProfilePreferenceId = 2 THEN CAST(argrpcGenerated.RiskNumber AS VARCHAR(10)) + ' - ' + argrpcGenerated.BriefDescription ELSE NULL END GeneratedRetirementRiskProfile
  , CASE WHEN atrts.AtrRefProfilePreferenceId = 2 THEN CAST(argrpcChosen.RiskNumber AS VARCHAR(10)) + ' - ' + argrpcChosen.BriefDescription ELSE NULL END ChosenRetirementRiskProfile
  , CASE WHEN atrts.AtrRefProfilePreferenceId = 2 THEN arg.DateOfRiskAssessment ELSE NULL END InvestmentDateCompleted
  , CAST(CASE WHEN atrts.AtrRefProfilePreferenceId = 1 THEN 1 ELSE 0 END AS BIT) IsClientProfile
FROM FactFind.dbo.TFactFind ff
INNER JOIN FactFind.dbo.TAtrTemplate atrt
ON atrt.Active = 1 AND atrt.IsArchived = 0 AND atrt.IndigoClientId = @TenantId
INNER JOIN FactFind.dbo.TAtrTemplateSetting atrts
ON atrt.AtrTemplateId = atrts.AtrTemplateId
LEFT JOIN FactFind.dbo.TAtrInvestmentGeneral aig
ON aig.CRMContactId = @cid
LEFT JOIN PolicyManagement.dbo.TRiskProfileCombined aigrpcChosen
ON aig.Client1ChosenProfileGuid IS NOT NULL AND aig.Client1AgreesWithProfile = 0 AND aig.Client1ChosenProfileGuid = aigrpcChosen.[Guid]
LEFT JOIN PolicyManagement.dbo.TRiskProfileCombined aigrpcGenerated
ON aig.CalculatedRiskProfile IS NOT NULL AND aig.Client1AgreesWithProfile = 1 AND aig.CalculatedRiskProfile = aigrpcGenerated.[Guid]
LEFT JOIN FactFind.dbo.TAtrRetirementGeneral arg
ON arg.CRMContactId = @cid
LEFT JOIN PolicyManagement.dbo.TRiskProfileCombined argrpcChosen
ON arg.Client1ChosenProfileGuid IS NOT NULL AND arg.Client1AgreesWithProfile = 0 AND arg.Client1ChosenProfileGuid = argrpcChosen.[Guid]
LEFT JOIN PolicyManagement.dbo.TRiskProfileCombined argrpcGenerated
ON arg.CalculatedRiskProfile IS NOT NULL AND arg.Client1AgreesWithProfile = 1 AND arg.CalculatedRiskProfile = argrpcGenerated.[Guid]
WHERE ff.CRMContactId1 = @cid OR ff.CRMContactId2 = @cid
GO