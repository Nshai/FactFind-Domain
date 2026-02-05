SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditObjective]
	@StampUser varchar (255),
	@ObjectiveId bigint,
	@StampAction char(1)
AS

INSERT INTO TObjectiveAudit (
	Objective, TargetAmount, StartDate, TargetDate, RegularImmediateIncome, ReasonForChange, RiskProfileGuid,
	CRMContactId, ObjectiveTypeId, IsFactFind, Details, Frequency, RetirementAge, LumpSumAtRetirement, AnnualPensionIncome,
	ConcurrencyId, ObjectiveId, StampAction, StampDateTime, StampUser, CRMContactId2, GoalType, RiskDiscrepency,
	RiskProfileAdjustedDate, RefLumpsumAtRetirementTypeId, RefGoalCategoryId, RefIncreaseRateId, MarkedAsCompletedDate,
	AccountId, PlanId, IsCreatedByClient, MarkedAsCompletedByUserId, TermInYears, [IsAtRetirement])
SELECT  
	Objective, TargetAmount, StartDate, TargetDate, RegularImmediateIncome, ReasonForChange, RiskProfileGuid,
	CRMContactId, ObjectiveTypeId, IsFactFind, Details, Frequency, RetirementAge, LumpSumAtRetirement, AnnualPensionIncome,
	ConcurrencyId, ObjectiveId, @StampAction, GETDATE(), @StampUser, CRMContactId2, GoalType, RiskDiscrepency,
	RiskProfileAdjustedDate, RefLumpsumAtRetirementTypeId, RefGoalCategoryId, RefIncreaseRateId, MarkedAsCompletedDate,
	AccountId, PlanId, IsCreatedByClient, MarkedAsCompletedByUserId, TermInYears, [IsAtRetirement]
FROM 
	TObjective
WHERE 
	ObjectiveId = @ObjectiveId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
