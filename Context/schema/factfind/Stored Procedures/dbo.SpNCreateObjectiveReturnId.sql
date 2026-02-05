SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateObjectiveReturnId]
	@StampUser varchar (255),
	@Objective varchar(500)  = NULL, 
	@TargetAmount money = NULL, 
	@StartDate datetime = NULL, 
	@TargetDate datetime = NULL, 
	@RegularImmediateIncome bit = NULL, 
	@ReasonForChange varchar(200)  = NULL, 
	@RiskProfileGuid uniqueidentifier = NULL, 
	@CRMContactId bigint = NULL, 
	@ObjectiveTypeId bigint, 
	@IsFactFind bit = 0	,
	@Details varchar(max) = null,	
	@Frequency int = 1,
	@RetirementAge	int = null,
	@LumpSumAtRetirement money	= null
AS


DECLARE @ObjectiveId bigint, @Result int
			
	
INSERT INTO TObjective
(Objective, TargetAmount, StartDate, TargetDate, RegularImmediateIncome, ReasonForChange, 
	RiskProfileGuid, CRMContactId, ObjectiveTypeId, IsFactFind, Details, Frequency, RetirementAge,LumpSumAtRetirement,
	ConcurrencyId)
VALUES(@Objective, @TargetAmount, @StartDate, @TargetDate, @RegularImmediateIncome, @ReasonForChange, 
	@RiskProfileGuid, @CRMContactId, @ObjectiveTypeId, @IsFactFind, @Details, @Frequency,@RetirementAge,@LumpSumAtRetirement,
	1)

SELECT @ObjectiveId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditObjective @StampUser, @ObjectiveId, 'C'

IF @Result  != 0 GOTO errh


SELECT @ObjectiveId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
