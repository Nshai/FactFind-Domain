SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNUpdateObjective]
	@ObjectiveId Bigint,
	@ConcurrencyId bigint,
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
	@IsFactFind bit,
	@FrequencyId int = null,
	@Details varchar(max) = null,
	@RetirementAge	int = null,
	@LumpSumAtRetirement money	= null

AS


Declare @Result int
Execute @Result = dbo.SpNAuditObjective @StampUser, @ObjectiveId, 'U'

IF @Result  != 0 GOTO errh


UPDATE T1
SET T1.Objective = @Objective, T1.TargetAmount = @TargetAmount, T1.StartDate = @StartDate, 
	T1.TargetDate = @TargetDate, T1.RegularImmediateIncome = @RegularImmediateIncome, T1.ReasonForChange = @ReasonForChange, 
	T1.RiskProfileGuid = @RiskProfileGuid, T1.CRMContactId = @CRMContactId, T1.ObjectiveTypeId = @ObjectiveTypeId, 
	T1.IsFactFind = @IsFactFind, 
	T1.Frequency = @FrequencyId,
	T1.Details = @Details,
	T1.RetirementAge = @RetirementAge,
	T1.LumpSumAtRetirement = @LumpSumAtRetirement,	
T1.ConcurrencyId = T1.ConcurrencyId + 1
FROM TObjective T1
WHERE  T1.ObjectiveId = @ObjectiveId --And T1.ConcurrencyId = @ConcurrencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
