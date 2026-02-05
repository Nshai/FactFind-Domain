SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomUpdateRetirementObjective] @StampUser VARCHAR(255),
	@RetirementObjectiveId BIGINT,
	@CRMContactId BIGINT = NULL,
	@Owner VARCHAR(16),
	@GoalType TINYINT = NULL,
	@RefGoalCategoryId BIGINT,
	@Objective VARCHAR(500) = NULL,
	@TargetAmount MONEY = NULL,
	@StartDate DATETIME = NULL,
	@TargetDate DATETIME = NULL,
	@Details VARCHAR(max) = NULL,
	@RetirementAge INT = NULL,
	@RefLumpsumAtRetirementTypeId BIGINT,
	@LumpSumAtRetirement MONEY = NULL,
	@ConcurrencyId BIGINT = NULL, -- not required.
	@Frequency int = NULL,
	@TermInYears tinyint = NULL,
	@IsAtRetirement bit = NULL
AS
EXEC [SpNCustomUpdateObjective]
	@StampUser,
	@RetirementObjectiveId,
	@CRMContactId,
	@Owner,
	@GoalType,
	@RefGoalCategoryId,
	@Objective,
	@TargetAmount,
	@StartDate,
	@TargetDate,
	@Details,
	@Frequency,
	@RetirementAge,
	@RefLumpsumAtRetirementTypeId,
	@LumpSumAtRetirement,
	NULL, NULL, NULL, 
	@TermInYears,
	@IsAtRetirement
GO
