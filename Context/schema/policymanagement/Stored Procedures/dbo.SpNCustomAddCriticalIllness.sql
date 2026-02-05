SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAddCriticalIllness]
@CRMContactId1 bigint,
@CRMContactId2 bigint,
@PolicyBusinessId bigint,
@CriticalIllnessAmount money,
@StampUser varchar(255)


AS

BEGIN

DECLARE @PolicyBenefitId1 bigint
DECLARE @PolicyBenefitId2 bigint
DECLARE @CriticalIllnessId1 bigint
DECLARE @CriticalIllnessId2 bigint

SELECT @PolicyBenefitId1 = PolicyBenefitId, @CriticalIllnessId1 = CriticalIllnessId FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId1
SELECT @PolicyBenefitId2 = PolicyBenefitId, @CriticalIllnessId2 = CriticalIllnessId FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId2

IF @CriticalIllnessId1 IS NULL 
	BEGIN
		INSERT INTO PolicyManagement..TCriticalIllness(Amount, ConcurrencyId)
		VALUES (@CriticalIllnessAmount, 1)

		SET @CriticalIllnessId1 = SCOPE_IDENTITY()

		INSERT INTO PolicyManagement..TCriticalIllnessAudit(Amount, ConcurrencyId, CriticalIllnessId, StampAction, StampDateTime, StampUser)
		VALUES (@CriticalIllnessAmount, 1, @CriticalIllnessId1, 'C', getdate(), @StampUser)
	END
ELSE
	BEGIN
		INSERT INTO PolicyManagement..TCriticalIllnessAudit(Amount, ConcurrencyId, CriticalIllnessId, StampAction, StampDateTime, StampUser)
		SELECT Amount, ConcurrencyId, CriticalIllnessId, 'U', getdate(), @StampUser
		FROM PolicyManagement..TCriticalIllness WHERE CriticalIllnessId = @CriticalIllnessId1

		UPDATE PolicyManagement..TCriticalIllness
		SET Amount = @CriticalIllnessAmount,
			ConcurrencyId = ConcurrencyId + 1
		WHERE CriticalIllnessId = @CriticalIllnessId1
	END


IF @CriticalIllnessId2 IS NULL AND @CRMContactId2 IS NOT NULL

	BEGIN
		INSERT INTO PolicyManagement..TCriticalIllness(Amount, ConcurrencyId)
		VALUES (@CriticalIllnessAmount, 1)

		SET @CriticalIllnessId2 = SCOPE_IDENTITY()

		INSERT INTO PolicyManagement..TCriticalIllnessAudit(Amount, ConcurrencyId, CriticalIllnessId, StampAction, StampDateTime, StampUser)
		VALUES (@CriticalIllnessAmount, 1, @CriticalIllnessId2, 'C', getdate(), @StampUser)
	END
ELSE
	BEGIN
		INSERT INTO PolicyManagement..TCriticalIllnessAudit(Amount, ConcurrencyId, CriticalIllnessId, StampAction, StampDateTime, StampUser)
		SELECT Amount, ConcurrencyId, CriticalIllnessId, 'U', getdate(), @StampUser
		FROM PolicyManagement..TCriticalIllness WHERE CriticalIllnessId = @CriticalIllnessId2

		UPDATE PolicyManagement..TCriticalIllness
		SET Amount = @CriticalIllnessAmount,
			ConcurrencyId = ConcurrencyId + 1
		WHERE CriticalIllnessId = @CriticalIllnessId2
	END


-- add or update the policybenefit record
if @CriticalIllnessId1 IS NOT NULL
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId1, null, @CriticalIllnessId1, null, null, null, @StampUser

if @CriticalIllnessId2 IS NOT NULL 
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId2, null, @CriticalIllnessId2, null, null, null, @StampUser



END
GO
