SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAddLifeCover]
@CRMContactId1 bigint,
@CRMContactId2 bigint,
@PolicyBusinessId bigint,
@RefPlanType2ProdSubTypeId bigint,
@BenefitAmount money, 
@Term int=null,
@StampUser varchar(255)


AS

BEGIN

DECLARE @PolicyBenefitId1 bigint
DECLARE @PolicyBenefitId2 bigint
DECLARE @LifeCoverId1 bigint
DECLARE @LifeCoverId2 bigint

SELECT @PolicyBenefitId1 = PolicyBenefitId, @LifeCoverId1 = LifeCoverId FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId1
SELECT @PolicyBenefitId2 = PolicyBenefitId, @LifeCoverId2 = LifeCoverId FROM PolicyManagement..TPolicyBenefit WHERE PolicyBusinessID = @PolicyBusinessId AND CRMContactId = @CRMContactId2

DECLARE @RefOptionsId bigint
DECLARE @RefPaymentBasisId bigint

SET @RefOptionsId = 5 --none
SET @RefPaymentBasisId = 1 --1st Death


	
-- IF @CRMContactId2 IS NOT NULL
-- 	SET @RefPaymentBasisId = 2 --2nd Death

IF @LifeCoverId1 IS NULL 
	BEGIN
		INSERT INTO PolicyManagement..TLifeCover (Amount, RefPaymentBasisId, RefOptionsId,Term, ConcurrencyId)
		VALUES	(@BenefitAmount, @RefPaymentBasisId, @RefOptionsId,@Term, 1)

		SET @LifeCoverId1 = SCOPE_IDENTITY()

		INSERT INTO PolicyManagement..TLifeCoverAudit (Amount, RefPaymentBasisId, RefOptionsId, Term,ConcurrencyId, LifeCoverId, StampAction, StampDateTime, StampUser)
		VALUES	(@BenefitAmount, @RefPaymentBasisId, @RefOptionsId,@Term, 1, @LifeCoverId1, 'C', getdate(), @StampUser)
	END
ELSE
	BEGIN
		INSERT INTO PolicyManagement..TLifeCoverAudit (Amount, RefPaymentBasisId, RefOptionsId,Term, ConcurrencyId, LifeCoverId, StampAction, StampDateTime, StampUser)
		SELECT Amount, RefPaymentBasisId, RefOptionsId,Term, ConcurrencyId, LifeCoverId, 'U', getdate(), @StampUser
		FROM PolicyManagement..TLifeCover WHERE LifeCoverId = @lifeCoverId1

		UPDATE PolicyManagement..TLifeCover
		SET Amount = @BenefitAmount,Term=@Term,
			ConcurrencyId = ConcurrencyId + 1
		WHERE LifeCoverId = @LifeCoverId1
	END


IF @LifeCoverId2 IS NULL AND @CRMContactId2 IS NOT NULL

	BEGIN
		INSERT INTO PolicyManagement..TLifeCover (Amount, RefPaymentBasisId, RefOptionsId,Term, ConcurrencyId)
		VALUES	(@BenefitAmount, @RefPaymentBasisId, @RefOptionsId,@Term, 1)

		SET @LifeCoverId2 = SCOPE_IDENTITY()

		INSERT INTO PolicyManagement..TLifeCoverAudit (Amount, RefPaymentBasisId, RefOptionsId,Term, ConcurrencyId, LifeCoverId, StampAction, StampDateTime, StampUser)
		VALUES	(@BenefitAmount, @RefPaymentBasisId, @RefOptionsId,@Term, 1, @LifeCoverId2, 'C', getdate(), @StampUser)
	END
ELSE
	BEGIN
		INSERT INTO PolicyManagement..TLifeCoverAudit (Amount, RefPaymentBasisId, RefOptionsId,Term, ConcurrencyId, LifeCoverId, StampAction, StampDateTime, StampUser)
		SELECT Amount, RefPaymentBasisId, RefOptionsId,Term, ConcurrencyId, LifeCoverId, 'U', getdate(), @StampUser
		FROM PolicyManagement..TLifeCover WHERE LifeCoverId = @lifeCoverId2

		UPDATE PolicyManagement..TLifeCover
		SET Amount = @BenefitAmount,Term=@Term,
			ConcurrencyId = ConcurrencyId + 1
		WHERE LifeCoverId = @LifeCoverId2
	END


-- add or update the policybenefit record
if @LifeCoverId1 IS NOT NULL
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId1, @LifeCoverId1, null, null, null, null, @StampUser

if @LifeCoverId2 IS NOT NULL 
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId2, @LifeCoverId2, null, null, null, null, @StampUser



END


GO
