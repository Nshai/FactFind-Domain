SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAddFamilyBenefit]
	@CRMContactId1 bigint,
	@CRMContactId2 bigint,
	@PolicyBusinessId bigint,
	@LifeAssured varchar(10),
	@BenefitAmount money,	
	@MaturityDate datetime,
	@StampUser varchar(255),
	@BenefitFrequency bigint = 8 --Annual
AS
DECLARE @PolicyBenefitId1 bigint, @PolicyBenefitId2 bigint, @FamilyBenefitId1 bigint, @FamilyBenefitId2 bigint

-- Try to find policy benefit records for FF clients.
SELECT @PolicyBenefitId1 = PolicyBenefitId, @FamilyBenefitId1 = FamilyBenefitId 
FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId1
SELECT @PolicyBenefitId2 = PolicyBenefitId, @FamilyBenefitId2 = FamilyBenefitId 
FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId2

IF LEFT(@LifeAssured,5) = 'Joint' or @LifeAssured = 'Client 1' BEGIN
	IF @FamilyBenefitId1 IS NULL AND @CRMContactId1 IS NOT NULL BEGIN
		INSERT INTO PolicyManagement..TFamilyBenefit (IncomeBenefitFg, Amount, RefFrequencyId, UntilDate, ConcurrencyId)
		VALUES (1, @BenefitAmount, @BenefitFrequency, @MaturityDate, 1)

		SET @FamilyBenefitId1 = SCOPE_IDENTITY()
		EXEC PolicyManagement..SpNAuditFamilyBenefit @StampUser, @FamilyBenefitId1, 'C'
	END	
	ELSE IF @FamilyBenefitId1 IS NOT NULL BEGIN
		EXEC PolicyManagement..SpNAuditFamilyBenefit @StampUser, @FamilyBenefitId1, 'U'

		UPDATE PolicyManagement..TFamilyBenefit
		SET Amount = @BenefitAmount,
			RefFrequencyId = @BenefitFrequency,
			UntilDate = @MaturityDate,
			ConcurrencyId = ConcurrencyId + 1
		WHERE FamilyBenefitId = @FamilyBenefitId1
	END
END

IF LEFT(@LifeAssured,5) = 'Joint' or @LifeAssured = 'Client 2' BEGIN
	IF @FamilyBenefitId2 IS NULL AND @CRMContactId2 IS NOT NULL BEGIN
		INSERT INTO PolicyManagement..TFamilyBenefit (IncomeBenefitFg, Amount, RefFrequencyId, UntilDate, ConcurrencyId)
		VALUES (1, @BenefitAmount, @BenefitFrequency, @MaturityDate, 1)

		SET @FamilyBenefitId2 = SCOPE_IDENTITY()
		
		EXEC PolicyManagement..SpNAuditFamilyBenefit @StampUser, @FamilyBenefitId2, 'C'
	END
	ELSE IF @FamilyBenefitId2 IS NOT NULL BEGIN
		EXEC PolicyManagement..SpNAuditFamilyBenefit @StampUser, @FamilyBenefitId2, 'U'

		UPDATE PolicyManagement..TFamilyBenefit
		SET Amount = @BenefitAmount,
			RefFrequencyId = @BenefitFrequency,
			UntilDate = @MaturityDate,
			ConcurrencyId = ConcurrencyId + 1
		WHERE FamilyBenefitId = @FamilyBenefitId2
	END
END

-- add or update the policybenefit record
IF @FamilyBenefitId1 IS NOT NULL 
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId1, null, null, null, @FamilyBenefitId1, null, @StampUser

IF @FamilyBenefitId2 IS NOT NULL 
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId2, null, null, null, @FamilyBenefitId2, null, @StampUser
GO
