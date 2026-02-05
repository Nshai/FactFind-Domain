SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreatePolicyMoneyIn]
@StampUser varchar (255),
@Amount money = NULL,
@EscalationPercentage decimal(10,5) = NULL,
@RefFrequencyId bigint,
@StartDate datetime = NULL,
@PolicyBusinessId bigint,
@RefTaxBasisId bigint = NULL,
@RefTaxYearId bigint = NULL,
@RefContributionTypeId bigint = NULL,
@RefContributorTypeId bigint = NULL,
@CurrentFg bit = NULL,
@RefEscalationTypeId bigint = NULL,
@SalaryPercentage decimal(10,5) = NULL,
@StopDate datetime = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @PolicyMoneyInId bigint

  INSERT INTO TPolicyMoneyIn (
    Amount, 
    EscalationPercentage, 
    RefFrequencyId, 
    StartDate, 
    PolicyBusinessId, 
    RefTaxBasisId, 
    RefTaxYearId, 
    RefContributionTypeId, 
    RefContributorTypeId, 
    CurrentFg, 
    RefEscalationTypeId, 
    SalaryPercentage, 
    StopDate, 
    ConcurrencyId ) 
  VALUES (
    @Amount, 
    @EscalationPercentage, 
    @RefFrequencyId, 
    @StartDate, 
    @PolicyBusinessId, 
    @RefTaxBasisId, 
    @RefTaxYearId, 
    @RefContributionTypeId, 
    @RefContributorTypeId, 
    @CurrentFg, 
    @RefEscalationTypeId, 
    @SalaryPercentage, 
    @StopDate, 
    1) 

  SELECT @PolicyMoneyInId = SCOPE_IDENTITY()
  INSERT INTO TPolicyMoneyInAudit (
    Amount, 
    EscalationPercentage, 
    RefFrequencyId, 
    StartDate, 
    PolicyBusinessId, 
    RefTaxBasisId, 
    RefTaxYearId, 
    RefContributionTypeId, 
    RefContributorTypeId, 
    CurrentFg, 
    RefEscalationTypeId, 
    SalaryPercentage, 
    StopDate, 
    ConcurrencyId,
    PolicyMoneyInId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Amount, 
    T1.EscalationPercentage, 
    T1.RefFrequencyId, 
    T1.StartDate, 
    T1.PolicyBusinessId, 
    T1.RefTaxBasisId, 
    T1.RefTaxYearId, 
    T1.RefContributionTypeId, 
    T1.RefContributorTypeId, 
    T1.CurrentFg, 
    T1.RefEscalationTypeId, 
    T1.SalaryPercentage, 
    T1.StopDate, 
    T1.ConcurrencyId,
    T1.PolicyMoneyInId,
    'C',
    GetDate(),
    @StampUser

  FROM TPolicyMoneyIn T1
 WHERE T1.PolicyMoneyInId=@PolicyMoneyInId
  EXEC SpRetrievePolicyMoneyInById @PolicyMoneyInId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
