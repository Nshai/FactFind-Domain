SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAddFamilyBenefit]
@CRMContactId1 bigint,
@CRMContactId2 bigint,
@PolicyBusinessId bigint,
@BenefitAmount money,
@MaturityDate datetime,
@StampUser varchar(255)


AS

BEGIN

DECLARE @PolicyBenefitId1 bigint
DECLARE @PolicyBenefitId2 bigint
DECLARE @FamilyBenefitId1 bigint
DECLARE @FamilyBenefitId2 bigint

SELECT @PolicyBenefitId1 = PolicyBenefitId, @FamilyBenefitId1 = FamilyBenefitId FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId1
SELECT @PolicyBenefitId2 = PolicyBenefitId, @FamilyBenefitId2 = FamilyBenefitId FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId2


IF @FamilyBenefitId1 IS NULL 
	BEGIN
		INSERT INTO PolicyManagement..TFamilyBenefit (IncomeBenefitFg, Amount, RefFrequencyId, UntilDate, ConcurrencyId)
		VALUES (1, @BenefitAmount, 8, @MaturityDate, 1)
	
		SET @FamilyBenefitId1 = SCOPE_IDENTITY()
	
		INSERT INTO PolicyManagement..TFamilyBenefitAudit (IncomeBenefitFg, Amount, RefFrequencyId, UntilDate, ConcurrencyId, FamilyBenefitId, StampAction, StampDateTime, StampUser)
		VALUES (1, @BenefitAmount, 8, @MaturityDate, 1, @FamilyBenefitId1, 'C', getdate(), @StampUser)
	END
ELSE
	BEGIN
		INSERT INTO PolicyManagement..TFamilyBenefitAudit (IncomeBenefitFg, Amount, RefFrequencyId, UntilDate, ConcurrencyId, FamilyBenefitId, StampAction, StampDateTime, StampUser)
		SELECT IncomeBenefitFg, Amount, RefFrequencyId, UntilDate, ConcurrencyId, FamilyBenefitId, 'U', getdate(), @StampUser
		FROM PolicyManagement..TFamilyBenefit WHERE FamilyBenefitId = @FamilyBenefitId1

		UPDATE PolicyManagement..TFamilyBenefit
		SET Amount = @BenefitAmount,
		UntilDate = @MaturityDate,
		ConcurrencyId = ConcurrencyId + 1
		WHERE FamilyBenefitId = @FamilyBenefitId1
	END

IF @FamilyBenefitId2 IS NULL AND @CRMContactId2 IS NOT NULL
	BEGIN
		INSERT INTO PolicyManagement..TFamilyBenefit (IncomeBenefitFg, Amount, RefFrequencyId, UntilDate, ConcurrencyId)
		VALUES (1, @BenefitAmount, 8, @MaturityDate, 1)
	
		SET @FamilyBenefitId2 = SCOPE_IDENTITY()
	
		INSERT INTO PolicyManagement..TFamilyBenefitAudit (IncomeBenefitFg, Amount, RefFrequencyId, UntilDate, ConcurrencyId, FamilyBenefitId, StampAction, StampDateTime, StampUser)
		VALUES (1, @BenefitAmount, 8, @MaturityDate, 1, @FamilyBenefitId2, 'C', getdate(), @StampUser)
	END
ELSE
	BEGIN
		INSERT INTO PolicyManagement..TFamilyBenefitAudit (IncomeBenefitFg, Amount, RefFrequencyId, UntilDate, ConcurrencyId, FamilyBenefitId, StampAction, StampDateTime, StampUser)
		SELECT IncomeBenefitFg, Amount, RefFrequencyId, UntilDate, ConcurrencyId, FamilyBenefitId, 'U', getdate(), @StampUser
		FROM PolicyManagement..TFamilyBenefit WHERE FamilyBenefitId = @FamilyBenefitId1

		UPDATE PolicyManagement..TFamilyBenefit
		SET Amount = @BenefitAmount,
		UntilDate = @MaturityDate,
		ConcurrencyId = ConcurrencyId + 1
		WHERE FamilyBenefitId = @FamilyBenefitId2
	END


-- add or update the policybenefit record
if @FamilyBenefitId1 IS NOT NULL 
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId1, null, null, null, @FamilyBenefitId1, null, @StampUser

if @FamilyBenefitId2 IS NOT NULL 
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId2, null, null, null, @FamilyBenefitId2, null, @StampUser



END
GO
