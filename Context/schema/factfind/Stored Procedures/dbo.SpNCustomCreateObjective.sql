SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomCreateObjective] @StampUser VARCHAR(255),
	@ObjectiveTypeId INT, -- 1 = Investment, 2 = Retirement
	@CRMContactId BIGINT,
	@Owner VARCHAR(16),
	@CurrentUserDate datetime,
	@GoalType TINYINT = NULL, -- 1 = Growth, 2 = Growth with Target, 3 = Income, 4 = growth with no target
	@RefGoalCategoryId BIGINT,
	@Objective VARCHAR(500) = NULL,
	@TargetAmount MONEY = NULL,
	@StartDate DATETIME = NULL,
	@TargetDate DATETIME = NULL,
	@Details VARCHAR(max) = NULL,
	@Frequency INT = NULL,
	@RetirementAge INT = NULL,
	@RefLumpsumAtRetirementTypeId BIGINT = NULL,
	@LumpSumAtRetirement MONEY = NULL,
	@TermInYears tinyint = NULL,
	@IsAtRetirement bit = NULL,
	@ObjectiveId BIGINT OUTPUT
AS
SET NOCOUNT ON

DECLARE @CRMContactId2 BIGINT,
	@RegularImmediateIncome BIT

-- Update CRMContacts using owner
EXEC SpNCustomUpdateCRMContactsByOwner @Owner,
	@CRMContactId OUTPUT,
	@CRMContactId2 OUTPUT

-- Set Income flag for FP
SET @RegularImmediateIncome = CASE 
		WHEN @GoalType = 3
			THEN 1
		ELSE 0
		END
--set target amount based on goaltype
SET @TargetAmount = CASE 
		WHEN @GoalType = 4
			THEN 0
		ELSE @TargetAmount
		END

-- Add Objective
INSERT INTO TObjective (
	IsFactFind,
	ObjectiveTypeId,
	CRMContactId,
	CRMContactId2,
	GoalType,
	Objective,
	TargetAmount,
	StartDate,
	TargetDate,
	Details,
	RegularImmediateIncome,
	Frequency,
	RetirementAge,
	RefLumpsumAtRetirementTypeId,
	LumpSumAtRetirement,
	RefGoalCategoryId,
	TermInYears,
	IsAtRetirement
	)
VALUES (
	1,
	@ObjectiveTypeId,
	@CRMContactId,
	@CRMContactId2,
	@GoalType,
	@Objective,
	@TargetAmount,
	@StartDate,
	@TargetDate,
	@Details,
	@RegularImmediateIncome,
	@Frequency,
	@RetirementAge,
	@RefLumpsumAtRetirementTypeId,
	@LumpSumAtRetirement,
	@RefGoalCategoryId,
	@TermInYears,
	ISNULL(@IsAtRetirement, 0)
	)

SET @ObjectiveId = SCOPE_IDENTITY()

EXEC SpNAuditObjective @StampUser,
	@ObjectiveId,
	'C'

-- Add default opportunity
EXEC SpNCustomCreateObjectiveOpportunity @StampUser,
	@ObjectiveId,
	@CRMContactId,
	@ObjectiveTypeId,
	@StartDate,
	@CurrentUserDate
GO
