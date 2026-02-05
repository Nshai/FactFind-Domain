SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAddPhi]
	@CRMContactId1 bigint,
	@CRMContactId2 bigint,
	@PolicyBusinessId bigint,
	@LifeAssured varchar(10),
	@PhiDeferredPeriod int, 
	@BenefitAmount money, 
	@PhiBenefitPeriod int,
	@StampUser varchar(255),
	@BenefitFrequency bigint = 8 --Annual
AS
DECLARE @PolicyBenefitId1 bigint, @PolicyBenefitId2 bigint, @PhiId1 bigint, @PhiId2 bigint

SELECT @PolicyBenefitId1 = PolicyBenefitId, @PhiId1 = PhiId 
FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId1
SELECT @PolicyBenefitId2 = PolicyBenefitId, @PhiId2 = PhiId 
FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId2

IF LEFT(@LifeAssured,5) = 'Joint' or @LifeAssured = 'Client 1' BEGIN
	IF @PhiId1 IS NULL AND @CRMContactId1 IS NOT NULL BEGIN
			-- INSERT CLIENT 1
			INSERT INTO PolicyManagement..TPhi (PhiDeferredPeriod, Amount, Term, RefFrequencyId, ConcurrencyId)
			VALUES (@PhiDeferredPeriod, @BenefitAmount, @PhiBenefitPeriod, @BenefitFrequency, 1) 
		
			SET @PhiId1 = SCOPE_IDENTITY()	
			EXEC PolicyManagement..SpNAuditPhi @StampUser, @PhiId1, 'C'
		END
	ELSE IF @PhiId1 IS NOT NULL 
		BEGIN
			-- UPDATE CLIENT 1
			EXEC PolicyManagement..SpNAuditPhi @StampUser, @PhiId1, 'U'

			UPDATE PolicyManagement..TPhi
			SET PhiDeferredPeriod = @PhiDeferredPeriod,
				Amount = @BenefitAmount,
				RefFrequencyId = @BenefitFrequency,
				Term = @PhiBenefitPeriod,
				ConcurrencyId = ConcurrencyId + 1
			WHERE PhiId = @PhiId1
		END
END

IF LEFT(@LifeAssured,5) = 'Joint' or @LifeAssured = 'Client 2' BEGIN
	IF @PhiId2 IS NULL AND @CRMContactId2 IS NOT NULL BEGIN
		-- INSERT CLIENT 2
		INSERT INTO PolicyManagement..TPhi (PhiDeferredPeriod, Amount, Term, RefFrequencyId, ConcurrencyId)
		VALUES (@PhiDeferredPeriod, @BenefitAmount, @PhiBenefitPeriod, @BenefitFrequency, 1) 

		SET @PhiId2 = SCOPE_IDENTITY()	
		EXEC PolicyManagement..SpNAuditPhi @StampUser, @PhiId2, 'C'
	END
	ELSE IF @PhiId2 IS NOT NULL BEGIN
		-- UPDATE CLIENT 2
		EXEC PolicyManagement..SpNAuditPhi @StampUser, @PhiId2, 'U'

		UPDATE PolicyManagement..TPhi
		SET PhiDeferredPeriod = @PhiDeferredPeriod,
			Amount = @BenefitAmount,
			RefFrequencyId = @BenefitFrequency,
			Term = @PhiBenefitPeriod,
			ConcurrencyId = ConcurrencyId + 1
		WHERE PhiId = @PhiId2
	END
END

-- add or update the policybenefit record
if @PhiId1 IS NOT NULL
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId1, null, null, @PhiId1, null, null, @StampUser

if @PhiId2 IS NOT NULL 
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId2, null, null, @PhiId2, null, null, @StampUser
GO
