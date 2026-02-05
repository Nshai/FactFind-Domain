SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomCreateRetirementObjective] @StampUser VARCHAR(255),
	@CRMContactId BIGINT,
	@Owner VARCHAR(16),
	@CurrentUserDate datetime,
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
	@Frequency int = NULL,
	@TermInYears tinyint = NULL,
	@IsAtRetirement bit = NULL
AS
DECLARE @NewId BIGINT

EXEC [SpNCustomCreateObjective] @StampUser,
	2,
	@CRMContactId,
	@Owner,
	@CurrentUserDate,
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
	@TermInYears,
	@IsAtRetirement,
	@ObjectiveId = @NewId OUTPUT

SELECT @NewId AS RetirementObjectiveId
GO
