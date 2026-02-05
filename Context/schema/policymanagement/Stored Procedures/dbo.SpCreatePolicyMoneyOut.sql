SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreatePolicyMoneyOut]
@StampUser varchar (255),
@PolicyOwnerId bigint = NULL,
@PolicyBusinessId bigint,
@BeneficiaryCRMContactId bigint = NULL,
@BeneficiaryPercentage decimal(10,5) = NULL,
@Amount money = NULL,
@RefBenefitPaymentTypeId bigint = NULL,
@SalaryMultiple tinyint = NULL,
@RefRiskEventTypeId bigint = NULL,
@PaymentStartDate datetime = NULL,
@PaymentStopDate datetime = NULL,
@RefFrequencyId bigint = NULL,
@RefIndexationTypeId bigint = NULL,
@EscalationPercentage decimal(10,5) = NULL,
@AssuredCRMContactId1 bigint = NULL,
@AssuredCRMContactId2 bigint = NULL,
@DeferredWeeks int = NULL,
@AssignedCRMContactId bigint = NULL,
@RefPaymentBasisTypeId bigint = NULL,
@PaymentBasisPercentage decimal(10,5) = NULL,
@GuaranteedPeriodMonths int = NULL,
@RefWithdrawalBasisTypeId bigint = NULL,
@RefWithdrawalTypeId bigint = NULL,
@RefEscalationTypeId bigint = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @PolicyMoneyOutId bigint

  INSERT INTO TPolicyMoneyOut (
    PolicyOwnerId, 
    PolicyBusinessId, 
    BeneficiaryCRMContactId, 
    BeneficiaryPercentage, 
    Amount, 
    RefBenefitPaymentTypeId, 
    SalaryMultiple, 
    RefRiskEventTypeId, 
    PaymentStartDate, 
    PaymentStopDate, 
    RefFrequencyId, 
    RefIndexationTypeId, 
    EscalationPercentage, 
    AssuredCRMContactId1, 
    AssuredCRMContactId2, 
    DeferredWeeks, 
    AssignedCRMContactId, 
    RefPaymentBasisTypeId, 
    PaymentBasisPercentage, 
    GuaranteedPeriodMonths, 
    RefWithdrawalBasisTypeId, 
    RefWithdrawalTypeId, 
    RefEscalationTypeId, 
    ConcurrencyId ) 
  VALUES (
    @PolicyOwnerId, 
    @PolicyBusinessId, 
    @BeneficiaryCRMContactId, 
    @BeneficiaryPercentage, 
    @Amount, 
    @RefBenefitPaymentTypeId, 
    @SalaryMultiple, 
    @RefRiskEventTypeId, 
    @PaymentStartDate, 
    @PaymentStopDate, 
    @RefFrequencyId, 
    @RefIndexationTypeId, 
    @EscalationPercentage, 
    @AssuredCRMContactId1, 
    @AssuredCRMContactId2, 
    @DeferredWeeks, 
    @AssignedCRMContactId, 
    @RefPaymentBasisTypeId, 
    @PaymentBasisPercentage, 
    @GuaranteedPeriodMonths, 
    @RefWithdrawalBasisTypeId, 
    @RefWithdrawalTypeId, 
    @RefEscalationTypeId, 
    1) 

  SELECT @PolicyMoneyOutId = SCOPE_IDENTITY()
  INSERT INTO TPolicyMoneyOutAudit (
    PolicyOwnerId, 
    PolicyBusinessId, 
    BeneficiaryCRMContactId, 
    BeneficiaryPercentage, 
    Amount, 
    RefBenefitPaymentTypeId, 
    SalaryMultiple, 
    RefRiskEventTypeId, 
    PaymentStartDate, 
    PaymentStopDate, 
    RefFrequencyId, 
    RefIndexationTypeId, 
    EscalationPercentage, 
    AssuredCRMContactId1, 
    AssuredCRMContactId2, 
    DeferredWeeks, 
    AssignedCRMContactId, 
    RefPaymentBasisTypeId, 
    PaymentBasisPercentage, 
    GuaranteedPeriodMonths, 
    RefWithdrawalBasisTypeId, 
    RefWithdrawalTypeId, 
    RefEscalationTypeId, 
    ConcurrencyId,
    PolicyMoneyOutId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.PolicyOwnerId, 
    T1.PolicyBusinessId, 
    T1.BeneficiaryCRMContactId, 
    T1.BeneficiaryPercentage, 
    T1.Amount, 
    T1.RefBenefitPaymentTypeId, 
    T1.SalaryMultiple, 
    T1.RefRiskEventTypeId, 
    T1.PaymentStartDate, 
    T1.PaymentStopDate, 
    T1.RefFrequencyId, 
    T1.RefIndexationTypeId, 
    T1.EscalationPercentage, 
    T1.AssuredCRMContactId1, 
    T1.AssuredCRMContactId2, 
    T1.DeferredWeeks, 
    T1.AssignedCRMContactId, 
    T1.RefPaymentBasisTypeId, 
    T1.PaymentBasisPercentage, 
    T1.GuaranteedPeriodMonths, 
    T1.RefWithdrawalBasisTypeId, 
    T1.RefWithdrawalTypeId, 
    T1.RefEscalationTypeId, 
    T1.ConcurrencyId,
    T1.PolicyMoneyOutId,
    'C',
    GetDate(),
    @StampUser

  FROM TPolicyMoneyOut T1
 WHERE T1.PolicyMoneyOutId=@PolicyMoneyOutId
  EXEC SpRetrievePolicyMoneyOutById @PolicyMoneyOutId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
