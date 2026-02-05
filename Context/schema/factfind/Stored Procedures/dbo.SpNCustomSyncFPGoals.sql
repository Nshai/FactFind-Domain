SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomSyncFPGoals] 
(
  @FinancialPlanningId BIGINT,                                
  @StampUser varchar (255)
)
As

Begin

-- Get all the selected goals against this FinancialPlanningId
CREATE TABLE #listOfObjectiveIds
(
	ObjectiveId BIGINT
)

-- Store the newly created goals for Audit
CREATE TABLE #outputInsertedFinancialPlanningGoals
(
	FinancialPlanningGoalId BIGINT
)
-- Just Delete, and then Add

-- Select All the selected Goals (Objectives) in this session
INSERT INTO #listOfObjectiveIds(ObjectiveId)
SELECT ObjectiveId FROM FactFind..TFinancialPlanningSelectedGoals
WHERE FinancialPlanningId = @FinancialPlanningId


-- Delete from TFinancialPlanningGoal too if the record exists there. 
-- Audit first

PRINT 'Deleting Everything first'
-- Auditing the delete adds far too many records into the DB
--INSERT INTO TFinancialPlanningGoalAudit (ObjectiveId, Objective, TargetAmount, StartDate, TargetDate, RiskProfileGuid, ObjectiveTypeId, RefGoalCategoryId, CRMContactId, CRMContactId2
--											,FinancialPlanningSessionId, RiskProfileId, ConcurrencyId, FinancialPlanningGoalId, StampAction, StampDateTime, StampUser)
--SELECT G.ObjectiveId, G.Objective, G.TargetAmount, G.StartDate, G.TargetDate, G.RiskProfileGuid, G.ObjectiveTypeId, G.RefGoalCategoryId, G.CRMContactId, G.CRMContactId2
--										,G.FinancialPlanningSessionId, G.RiskProfileId, G.ConcurrencyId, FinancialPlanningGoalId, 'D', GETDATE(), @StampUser
--FROM TFinancialPlanningGoal  G 
--			INNER JOIN TFinancialPlanningSession S ON G.FinancialPlanningSessionId = S.FinancialPlanningSessionId 
--			INNER JOIN TObjective O ON O.ObjectiveId = G.ObjectiveId
--WHERE S.FinancialPlanningId  = @FinancialPlanningId

-- Delete from the main table		
Delete G 
FROM TFinancialPlanningGoal  G 
	INNER JOIN TFinancialPlanningSession S ON G.FinancialPlanningSessionId = S.FinancialPlanningSessionId 
	INNER JOIN TObjective O ON O.ObjectiveId = G.ObjectiveId
WHERE S.FinancialPlanningId  = @FinancialPlanningId
-- END DELETE


PRINT 'Inserting into TFinancialPlanningGoal'
	-- Comes here when the Goals are not in TFinancialPlanningGoal table. We need to Add these in
	INSERT INTO TFinancialPlanningGoal (ObjectiveId, Objective, TargetAmount, StartDate, TargetDate, RiskProfileGuid, ObjectiveTypeId, RefGoalCategoryId
											,CRMContactId, CRMContactId2, FinancialPlanningSessionId, RiskProfileId)
			OUTPUT INSERTED.FinancialPlanningGoalId
			INTO #outputInsertedFinancialPlanningGoals

	SELECT O.ObjectiveId, O.Objective, O.TargetAmount, O.StartDate, O.TargetDate, O.RiskProfileGuid, O.ObjectiveTypeId, O.RefGoalCategoryId
										, O.CRMContactId, O.CRMContactId2, S.FinancialPlanningSessionId, RP.RiskProfileId
	FROM TObjective O
		INNER JOIN TFinancialPlanningSelectedGoals SG ON SG.ObjectiveId = O.ObjectiveId
		INNER JOIN TFinancialPlanning F  ON F.FinancialPlanningId = SG.FinancialPlanningId
		INNER JOIN TFinancialPlanningSession S ON S.FinancialPlanningId = F.FinancialPlanningId
		LEFT JOIN policymanagement..TRiskProfileCombined RP on O.RiskProfileGuid = RP.[Guid]

	WHERE O.ObjectiveId IN (SELECT ObjectiveId FROM #listOfObjectiveIds)
	AND F.FinancialPlanningId = @FinancialPlanningId

	-- AUDIT
	INSERT INTO TFinancialPlanningGoalAudit (ObjectiveId, Objective, TargetAmount, StartDate, TargetDate, RiskProfileGuid, ObjectiveTypeId, RefGoalCategoryId, CRMContactId, CRMContactId2
											,FinancialPlanningSessionId, RiskProfileId, ConcurrencyId, FinancialPlanningGoalId, StampAction, StampDateTime, StampUser)
	SELECT ObjectiveId, Objective, TargetAmount, StartDate, TargetDate, RiskProfileGuid, ObjectiveTypeId, RefGoalCategoryId, CRMContactId, CRMContactId2
											,FinancialPlanningSessionId, RiskProfileId, ConcurrencyId, FinancialPlanningGoalId, 'C', GETDATE(), @StampUser
	FROM TFinancialPlanningGoal
	WHERE FinancialPlanningGoalId IN (Select FinancialPlanningGoalId FROM #outputInsertedFinancialPlanningGoals)
End
