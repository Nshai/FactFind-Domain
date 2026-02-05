SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAtrInvestmentGeneral]
	@StampUser varchar (255),
	@AtrInvestmentGeneralId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrInvestmentGeneralAudit (
	CRMContactId, Client2AgreesWithAnswers, Client1AgreesWithProfile, Client2AgreesWithProfile, Client1ChosenProfileGuid, 
	Client2ChosenProfileGuid, ConcurrencyId, AtrInvestmentGeneralId, StampAction, StampDateTime, StampUser, 
	Client1Notes, Client2Notes, InconsistencyNotes, CalculatedRiskProfile, RiskDiscrepency, RiskProfileAdjustedDate, AdviserNotes,
	[DateOfRiskAssessment], WeightingSum, LowerBand, UpperBand, TemplateId) 
SELECT
	CRMContactId, Client2AgreesWithAnswers, Client1AgreesWithProfile, Client2AgreesWithProfile, Client1ChosenProfileGuid, 
	Client2ChosenProfileGuid, ConcurrencyId, AtrInvestmentGeneralId, @StampAction, GETDATE(), @StampUser, 
	Client1Notes, Client2Notes, InconsistencyNotes, CalculatedRiskProfile, RiskDiscrepency, RiskProfileAdjustedDate, AdviserNotes,
	[DateOfRiskAssessment], WeightingSum, LowerBand, UpperBand, TemplateId
FROM 
	TAtrInvestmentGeneral
WHERE 
	AtrInvestmentGeneralId = @AtrInvestmentGeneralId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
