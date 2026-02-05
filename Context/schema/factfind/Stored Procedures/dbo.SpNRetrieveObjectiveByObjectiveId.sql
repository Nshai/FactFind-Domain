SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveObjectiveByObjectiveId]
	@ObjectiveId bigint
AS

SELECT T1.ObjectiveId, T1.Objective, T1.TargetAmount, T1.StartDate, T1.TargetDate, T1.RegularImmediateIncome, 
	T1.ReasonForChange, T1.RiskProfileGuid, T1.CRMContactId, T1.ObjectiveTypeId, T1.IsFactFind, T1.ConcurrencyId
FROM TObjective  T1
WHERE T1.ObjectiveId = @ObjectiveId
GO
