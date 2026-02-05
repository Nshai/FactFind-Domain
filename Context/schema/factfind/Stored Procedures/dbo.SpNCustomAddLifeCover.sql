SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAddLifeCover]
@CRMContactId1 bigint,
@CRMContactId2 bigint,
@PolicyBusinessId bigint,
@PlanType varchar(255),
@LifeAssured varchar(10),
@BenefitAmount money, 
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

IF @PlanType = 'Term Protection (Convertible)'
	SET @RefOptionsId = 2 --convertible
IF @PlanType = 'Term Protection (Renewable)'
	SET @RefOptionsId = 1 --renewable
	
IF @LifeAssured = 'Joint 2nd'
	SET @RefPaymentBasisId = 2 --2nd Death

IF @LifeCoverId1 IS NULL AND (LEFT(@LifeAssured,5) = 'Joint' or @LifeAssured = 'Client 1')
	BEGIN
		INSERT INTO PolicyManagement..TLifeCover (Amount, RefPaymentBasisId, RefOptionsId, ConcurrencyId)
		VALUES	(@BenefitAmount, @RefPaymentBasisId, @RefOptionsId, 1)

		SET @LifeCoverId1 = SCOPE_IDENTITY()

		INSERT INTO PolicyManagement..TLifeCoverAudit (Amount, RefPaymentBasisId, RefOptionsId, ConcurrencyId, LifeCoverId, StampAction, StampDateTime, StampUser)
		VALUES	(@BenefitAmount, @RefPaymentBasisId, @RefOptionsId, 1, @LifeCoverId1, 'C', getdate(), @StampUser)
	END
ELSE
	BEGIN
		INSERT INTO PolicyManagement..TLifeCoverAudit (Amount, RefPaymentBasisId, RefOptionsId, ConcurrencyId, LifeCoverId, StampAction, StampDateTime, StampUser)
		SELECT Amount, RefPaymentBasisId, RefOptionsId, ConcurrencyId, LifeCoverId, 'U', getdate(), @StampUser
		FROM PolicyManagement..TLifeCover WHERE LifeCoverId = @lifeCoverId1

		UPDATE 
			PolicyManagement..TLifeCover
		SET 
			Amount = @BenefitAmount,
			ConcurrencyId = ConcurrencyId + 1			
		WHERE 
			LifeCoverId = @LifeCoverId1
	END


IF @LifeCoverId2 IS NULL AND (LEFT(@LifeAssured,5) = 'Joint' or @LifeAssured = 'Client 2')

	BEGIN
		INSERT INTO PolicyManagement..TLifeCover (Amount, RefPaymentBasisId, RefOptionsId, ConcurrencyId)
		VALUES	(@BenefitAmount, @RefPaymentBasisId, @RefOptionsId, 1)

		SET @LifeCoverId2 = SCOPE_IDENTITY()

		INSERT INTO PolicyManagement..TLifeCoverAudit (Amount, RefPaymentBasisId, RefOptionsId, ConcurrencyId, LifeCoverId, StampAction, StampDateTime, StampUser)
		VALUES	(@BenefitAmount, @RefPaymentBasisId, @RefOptionsId, 1, @LifeCoverId2, 'C', getdate(), @StampUser)
	END
ELSE
	BEGIN
		INSERT INTO PolicyManagement..TLifeCoverAudit (Amount, RefPaymentBasisId, RefOptionsId, ConcurrencyId, LifeCoverId, StampAction, StampDateTime, StampUser)
		SELECT Amount, RefPaymentBasisId, RefOptionsId, ConcurrencyId, LifeCoverId, 'U', getdate(), @StampUser
		FROM PolicyManagement..TLifeCover WHERE LifeCoverId = @lifeCoverId2

		UPDATE PolicyManagement..TLifeCover
		SET 
			Amount = @BenefitAmount,
			ConcurrencyId = ConcurrencyId + 1			
		WHERE 
			LifeCoverId = @LifeCoverId2
	END


-- add or update the policybenefit record
if @LifeCoverId1 is not null
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId1, @LifeCoverId1, null, null, null, null, @StampUser

if @LifeCoverId2 IS NOT NULL 
	exec SpNCustomAddPolicyBenefit @PolicyBusinessId, @CRMContactId2, @LifeCoverId2, null, null, null, null, @StampUser

END
GO
