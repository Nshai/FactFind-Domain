SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomAddPolicyBenefit]
@PolicyBusinessId bigint,
@CRMContactId bigint,
@LifeCoverId bigint = NULL,
@CriticalIllnessId bigint = NULL,
@PhiId bigint = NULL,
@FamilyBenefitId bigint = NULL,
@InTrustId bigint = NULL,
@StampUser varchar(255)

AS

BEGIN

DECLARE @PolicyBenefitId bigint

SELECT @PolicyBenefitId = PolicyBenefitId FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId

IF @PolicyBenefitId IS NULL -- no policybenefit record, so insert one
	BEGIN
		INSERT INTO PolicyManagement..TPolicyBenefit (PolicyBusinessId, CRMContactId, LifeCoverId, CriticalIllnessId, PhiId, FamilyBenefitId, InTrustId, ConcurrencyId)
		VALUES (@PolicyBusinessId, @CRMContactId, @LifeCoverId, @CriticalIllnessId, @PhiId, @FamilyBenefitId, @InTrustId, 1)
		
		SET @PolicyBenefitId = SCOPE_IDENTITY()
	
		INSERT INTO PolicyManagement..TPolicyBenefitAudit (PolicyBusinessId, CRMContactId, LifeCoverId, CriticalIllnessId, PhiId, FamilyBenefitId, InTrustId, ConcurrencyId, PolicyBenefitId, StampAction, StampDateTime, StampUser)
		VALUES (@PolicyBusinessId, @CRMContactId, @LifeCoverId, @CriticalIllnessId, @PhiId, @FamilyBenefitId, @InTrustId, 1, @PolicyBenefitId, 'C', getdate(), @StampUser)
	END		
ELSE --record exists, update. Need an update for each param, as we might not pass all of them in.
	BEGIN
		INSERT INTO PolicyManagement..TPolicyBenefitAudit (PolicyBusinessId, CRMContactId, LifeCoverId, CriticalIllnessId, PhiId, FamilyBenefitId, InTrustId, ConcurrencyId, PolicyBenefitId, StampAction, StampDateTime, StampUser)
		SELECT PolicyBusinessId, CRMContactId, LifeCoverId, CriticalIllnessId, PhiId, FamilyBenefitId, InTrustId, ConcurrencyId, PolicyBenefitId, 'U', getdate(), @StampUser
		FROM PolicyManagement..TPolicyBenefit WHERE PolicyBenefitId = @PolicyBenefitId

		IF @LifeCoverId IS NOT NULL
			UPDATE PolicyManagement..TPolicyBenefit SET LifeCoverId = @LifeCoverId WHERE PolicyBusinessId = @PolicyBusinessId AND CRMContactId = @CRMContactId

		IF @CriticalIllnessId IS NOT NULL
			UPDATE PolicyManagement..TPolicyBenefit SET CriticalIllnessId = @CriticalIllnessId WHERE PolicyBusinessId = @PolicyBusinessId AND CRMContactId = @CRMContactId

		IF @PhiId IS NOT NULL
			UPDATE PolicyManagement..TPolicyBenefit SET PhiId = @PhiId WHERE PolicyBusinessId = @PolicyBusinessId AND CRMContactId = @CRMContactId

		IF @FamilyBenefitId IS NOT NULL
			UPDATE PolicyManagement..TPolicyBenefit SET FamilyBenefitId = @FamilyBenefitId WHERE PolicyBusinessId = @PolicyBusinessId AND CRMContactId = @CRMContactId
	
		IF @InTrustId IS NOT NULL
			UPDATE PolicyManagement..TPolicyBenefit SET InTrustId = @InTrustId WHERE PolicyBusinessId = @PolicyBusinessId AND CRMContactId = @CRMContactId

		-- Assume that one has been updated - update concurrencyid
		UPDATE PolicyManagement..TPolicyBenefit 
		SET ConcurrencyId = ConcurrencyId + 1
		WHERE PolicyBusinessId = @PolicyBusinessId AND CRMContactId = @CRMContactId	
	
	END

END
GO
