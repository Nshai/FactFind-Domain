SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAddPhi]
@CRMContactId1 bigint,
@CRMContactId2 bigint,
@PolicyBusinessId bigint,
@PhiDeferredPeriod int, 
@BenefitAmount money, 
@PhiBenefitPeriod int,
@StampUser varchar(255)


AS

BEGIN

DECLARE @PolicyBenefitId1 bigint
DECLARE @PolicyBenefitId2 bigint
DECLARE @PhiId1 bigint
DECLARE @PhiId2 bigint

SELECT @PolicyBenefitId1 = PolicyBenefitId, @PhiId1 = PhiId FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId1
SELECT @PolicyBenefitId2 = PolicyBenefitId, @PhiId2 = PhiId FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId2


IF @PhiId1 IS NULL 
	BEGIN
		-- INSERT CLIENT 1
		INSERT INTO PolicyManagement..TPhi (PhiDeferredPeriod, Amount, Term, RefFrequencyId, ConcurrencyId)
		VALUES (@PhiDeferredPeriod, @BenefitAmount, @PhiBenefitPeriod, 8, 1) 
	
		SET @PhiId1 = SCOPE_IDENTITY()
	
		INSERT INTO PolicyManagement..TPhiAudit (PhiDeferredPeriod, Amount, Term, RefFrequencyId, ConcurrencyId, PhiId, StampAction, StampDateTime, StampUser)
		VALUES (@PhiDeferredPeriod, @BenefitAmount, @PhiBenefitPeriod, 8, 1, @PhiId1, 'C', getdate(), @StampUser) 
	END
ELSE
	BEGIN
		-- UPDATE CLIENT 1
		INSERT INTO PolicyManagement..TPhiAudit (PhiDeferredPeriod, Amount, Term, RefFrequencyId, ConcurrencyId, PhiId, StampAction, StampDateTime, StampUser)
		SELECT PhiDeferredPeriod, Amount, Term, RefFrequencyId, ConcurrencyId, PhiId, 'U', getdate(), @StampUser
		FROM PolicyManagement..TPhi WHERE PhiId = @PhiId1

		UPDATE PolicyManagement..TPhi
		SET PhiDeferredPeriod = @PhiDeferredPeriod,
		Amount = @BenefitAmount,
		Term = @PhiBenefitPeriod,
		ConcurrencyId = ConcurrencyId + 1
		WHERE PhiId = @PhiId1
	END

IF @PhiId2 IS NULL AND @CRMContactId2 IS NOT NULL
	BEGIN
		-- INSERT CLIENT 2
		INSERT INTO PolicyManagement..TPhi (PhiDeferredPeriod, Amount, Term, RefFrequencyId, ConcurrencyId)
		VALUES (@PhiDeferredPeriod, @BenefitAmount, @PhiBenefitPeriod, 8, 1) 
	
		SET @PhiId2 = SCOPE_IDENTITY()
	
		INSERT INTO PolicyManagement..TPhiAudit (PhiDeferredPeriod, Amount, Term, RefFrequencyId, ConcurrencyId, PhiId, StampAction, StampDateTime, StampUser)
		VALUES (@PhiDeferredPeriod, @BenefitAmount, @PhiBenefitPeriod, 8, 1, @PhiId2, 'C', getdate(), @StampUser) 
	END
ELSE
	BEGIN
		-- UPDATE CLIENT 2
		INSERT INTO PolicyManagement..TPhiAudit (PhiDeferredPeriod, Amount, Term, RefFrequencyId, ConcurrencyId, PhiId, StampAction, StampDateTime, StampUser)
		SELECT PhiDeferredPeriod, Amount, Term, RefFrequencyId, ConcurrencyId, PhiId, 'U', getdate(), @StampUser
		FROM PolicyManagement..TPhi WHERE PhiId = @PhiId2

		UPDATE PolicyManagement..TPhi
		SET PhiDeferredPeriod = @PhiDeferredPeriod,
		Amount = @BenefitAmount,
		Term = @PhiBenefitPeriod,
		ConcurrencyId = ConcurrencyId + 1
		WHERE PhiId = @PhiId2
	END

-- add or update the policybenefit record
if @PhiId1 IS NOT NULL
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId1, null, null, @PhiId1, null, null, @StampUser

if @PhiId2 IS NOT NULL 
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId2, null, null, @PhiId2, null, null, @StampUser



END

GO
