SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateObjective] @StampUser VARCHAR(255),
	@ObjectiveId BIGINT,
	@CRMContactId BIGINT,
	@Owner VARCHAR(16) = NULL,
	@GoalType TINYINT = NULL,
	@RefGoalCategoryId BIGINT,
	@Objective VARCHAR(500) = NULL,
	@TargetAmount MONEY = NULL,
	@StartDate DATETIME = NULL,
	@TargetDate DATETIME = NULL,
	@Details VARCHAR(max) = NULL,
	@Frequency INT = NULL,
	@RetirementAge INT = NULL,
	@RefLumpsumAtRetirementTypeId BIGINT = null,
	@LumpSumAtRetirement MONEY = NULL,
	--atr updates
	@ReasonForChange VARCHAR(255) = NULL,
	@RiskProfileGuid UNIQUEIDENTIFIER = NULL,
	@ConcurrencyId INT = NULL,
	@TermInYears tinyint = NULL,
	@IsAtRetirement bit = NULL
AS
-- Audit  
EXEC SpNAuditObjective @StampUser,
	@ObjectiveId,
	'U'

--Risk Profile update on Next Steps
IF isnull(cast(@RiskProfileGuid AS VARCHAR(50)), '') != ''
BEGIN
	--get the clients selected Risk
	DECLARE @TenantId BIGINT,
		@ObjectiveTypeId INT,
		@riskNumber INT,
		@objectiveRisk INT

	SELECT @TenantId = indclientid
	FROM crm..TCRMContact
	WHERE crmcontactid = @crmcontactid

	SELECT @ObjectiveTypeId = objectiveTypeid
	FROM TObjective
	WHERE objectiveid = @objectiveid

	DECLARE @riskTable TABLE (
		riskGuid UNIQUEIDENTIFIER,
		risk INT,
		a VARCHAR(max),
		b VARCHAR(max)
		)

	INSERT INTO @riskTable
	EXEC SpNCustomAtrGetClientRiskProfile @tenantId,
		@CRMContactId,
		@ObjectiveTypeId

	SELECT @riskNumber = risk
	FROM @riskTable

	SELECT @objectiveRisk = risknumber
	FROM policymanagement..TRiskProfileCombined
	WHERE guid = @RiskProfileGuid

	UPDATE o
	SET o.RiskDiscrepency = @riskNumber - @objectiveRisk,
		o.RiskProfileAdjustedDate = getdate(),
		o.ReasonForChange = @ReasonForChange,
		o.RiskProfileGuid = @RiskProfileGuid
	FROM TObjective o
	WHERE objectiveid = @objectiveid

	RETURN
END

DECLARE @CRMContactId2 BIGINT,
	@RegularImmediateIncome BIT

-- Get second owner from the data (we might need to keep this)  
SELECT @CRMContactId2 = CRMContactId2
FROM TObjective
WHERE ObjectiveId = @ObjectiveId

-- Update CRMContacts on the basis of the specified owner  
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

-- Update  
UPDATE TObjective
SET CRMContactId = @CRMContactId,
	CRMContactId2 = @CRMContactId2,
	GoalType = @GoalType,
	RefGoalCategoryId = @RefGoalCategoryId,
	Objective = @Objective,
	TargetAmount = @TargetAmount,
	StartDate = @StartDate,
	TargetDate = @TargetDate,
	Details = @Details,
	Frequency = @Frequency,
	RetirementAge = @RetirementAge,
	RefLumpsumAtRetirementTypeId = ISNULL(@RefLumpsumAtRetirementTypeId, 1),
	LumpSumAtRetirement = @LumpSumAtRetirement,
	RegularImmediateIncome = @RegularImmediateIncome,
	TermInYears = @TermInYears,
	IsAtRetirement = ISNULL(@IsAtRetirement, 0),
	ConcurrencyId = ConcurrencyId + 1
WHERE ObjectiveId = @ObjectiveId
GO
