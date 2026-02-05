SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreatePolicyExpectedCommission]
@StampUser varchar (255),
@PolicyBusinessId bigint,
@RefCommissionTypeId bigint,
@RefPaymentDueTypeId bigint,
@RefFrequencyId bigint = NULL,
@ChargingPeriodMonths tinyint = NULL,
@ExpectedAmount money,
@ExpectedStartDate datetime = NULL,
@ExpectedCommissionType bit,
@ParentPolicyExpectedCommissionId bigint = NULL,
@PercentageFund decimal(10,5) = NULL,
@Notes varchar (50) = NULL,
@ChangedByUser bigint = NULL,
@PreDiscountAmount money = NULL,
@DiscountReasonId bigint = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @PolicyExpectedCommissionId bigint

  INSERT INTO TPolicyExpectedCommission (
    PolicyBusinessId, 
    RefCommissionTypeId, 
    RefPaymentDueTypeId, 
    RefFrequencyId, 
    ChargingPeriodMonths, 
    ExpectedAmount, 
    ExpectedStartDate, 
    ExpectedCommissionType, 
    ParentPolicyExpectedCommissionId, 
    PercentageFund, 
    Notes, 
    ChangedByUser, 
    PreDiscountAmount, 
    DiscountReasonId, 
    ConcurrencyId ) 
  VALUES (
    @PolicyBusinessId, 
    @RefCommissionTypeId, 
    @RefPaymentDueTypeId, 
    @RefFrequencyId, 
    @ChargingPeriodMonths, 
    @ExpectedAmount, 
    @ExpectedStartDate, 
    @ExpectedCommissionType, 
    @ParentPolicyExpectedCommissionId, 
    @PercentageFund, 
    @Notes, 
    @ChangedByUser, 
    @PreDiscountAmount, 
    @DiscountReasonId, 
    1) 

  SELECT @PolicyExpectedCommissionId = SCOPE_IDENTITY()
  INSERT INTO TPolicyExpectedCommissionAudit (
    PolicyBusinessId, 
    RefCommissionTypeId, 
    RefPaymentDueTypeId, 
    RefFrequencyId, 
    ChargingPeriodMonths, 
    ExpectedAmount, 
    ExpectedStartDate, 
    ExpectedCommissionType, 
    ParentPolicyExpectedCommissionId, 
    PercentageFund, 
    Notes, 
    ChangedByUser, 
    PreDiscountAmount, 
    DiscountReasonId, 
    ConcurrencyId,
    PolicyExpectedCommissionId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.PolicyBusinessId, 
    T1.RefCommissionTypeId, 
    T1.RefPaymentDueTypeId, 
    T1.RefFrequencyId, 
    T1.ChargingPeriodMonths, 
    T1.ExpectedAmount, 
    T1.ExpectedStartDate, 
    T1.ExpectedCommissionType, 
    T1.ParentPolicyExpectedCommissionId, 
    T1.PercentageFund, 
    T1.Notes, 
    T1.ChangedByUser, 
    T1.PreDiscountAmount, 
    T1.DiscountReasonId, 
    T1.ConcurrencyId,
    T1.PolicyExpectedCommissionId,
    'C',
    GetDate(),
    @StampUser

  FROM TPolicyExpectedCommission T1
 WHERE T1.PolicyExpectedCommissionId=@PolicyExpectedCommissionId
  EXEC SpRetrievePolicyExpectedCommissionById @PolicyExpectedCommissionId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
