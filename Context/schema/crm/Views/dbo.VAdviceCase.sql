SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VAdviceCase]
AS
SELECT   A.AdviceCaseId,
		 A.CRMContactId,
		 A.PractitionerId,
		 A.StatusId,
		 A.StartDate,
		 A.CaseName,
		 A.CaseRef,
		 A.BinderId,
		 A.BinderDescription,
		 A.BinderOwnerId,
		 A.SequentialRef,
		 A.ConcurrencyId, 
         P.CRMContactId AS AdviserCRMContactId,
		 A.AdviseCategoryId,
		 A.Owner2PartyId,
		 A.IsJoint,
		 A.ReopenDate,
		 A.StatusChangedOn,
		 A.Owner1Vulnerability,
		 A.Owner2Vulnerability,
		 A.Owner1VulnerabilityNotes,
		 A.Owner2VulnerabilityNotes,
		 A.ServicingAdminUserId,
		 A.ParaplannerUserId,
		 A.RecommendationId,
		 A.Owner1VulnerabilityId,
		 A.Owner2VulnerabilityId,
		 A.HasRisk,
		 A.ComplianceCompletedBy,
		 A.PropertiesJson,
		 A.Client1AtrId,
		 A.Client1RiskProfileId,
		 A.Client1RiskProfileName,
		 A.Client2AtrId,
		 A.Client2RiskProfileId,
		 A.Client2RiskProfileName,
		 A.Client1InvestmentPreferenceId,
		 A.Client2InvestmentPreferenceId
FROM         dbo.TAdviceCase AS A INNER JOIN
                      dbo.TPractitioner AS P ON P.PractitionerId = A.PractitionerId

GO
