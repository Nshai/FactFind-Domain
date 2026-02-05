SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAtrRetirementGeneral]
	@StampUser varchar (255),
	@AtrRetirementGeneralId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrRetirementGeneralAudit (
	TAtrRetirementGeneralId, CRMContactId, Client2AgreesWithAnswers, Client1AgreesWithProfile, Client2AgreesWithProfile,
	Client1ChosenProfileGuid, Client2ChosenProfileGuid, ConcurrencyId, AtrRetirementGeneralId, StampAction, StampDateTime, StampUser,
	Client1Notes, Client2Notes, InconsistencyNotes, CalculatedRiskProfile, RiskDiscrepency, RiskProfileAdjustedDate, AdviserNotes,
	[DateOfRiskAssessment], WeightingSum, LowerBand, UpperBand, TemplateId)
SELECT 
	TAtrRetirementGeneralId, CRMContactId, Client2AgreesWithAnswers, Client1AgreesWithProfile, Client2AgreesWithProfile, 
	Client1ChosenProfileGuid, Client2ChosenProfileGuid, ConcurrencyId, AtrRetirementGeneralId, @StampAction, GETDATE(), @StampUser,
	Client1Notes, Client2Notes, InconsistencyNotes, CalculatedRiskProfile, RiskDiscrepency, RiskProfileAdjustedDate, AdviserNotes,
	[DateOfRiskAssessment], WeightingSum, LowerBand, UpperBand, TemplateId
FROM 
	TAtrRetirementGeneral
WHERE 
	AtrRetirementGeneralId = @AtrRetirementGeneralId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
