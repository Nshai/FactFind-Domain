SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateFeePaymentStatus]
@StampUser varchar (255),
@FeeId bigint,
@PaymentStatus varchar (50),
@PaymentStatusNotes varchar (250) = NULL,
@PaymentStatusDate datetime,
@UpdatedUserId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @FeePaymentStatusId bigint

  INSERT INTO TFeePaymentStatus (
    FeeId, 
    PaymentStatus, 
    PaymentStatusNotes, 
    PaymentStatusDate, 
    UpdatedUserId, 
    ConcurrencyId ) 
  VALUES (
    @FeeId, 
    @PaymentStatus, 
    @PaymentStatusNotes, 
    @PaymentStatusDate, 
    @UpdatedUserId, 
    1) 

  SELECT @FeePaymentStatusId = SCOPE_IDENTITY()
  INSERT INTO TFeePaymentStatusAudit (
    FeeId, 
    PaymentStatus, 
    PaymentStatusNotes, 
    PaymentStatusDate, 
    UpdatedUserId, 
    ConcurrencyId,
    FeePaymentStatusId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.FeeId, 
    T1.PaymentStatus, 
    T1.PaymentStatusNotes, 
    T1.PaymentStatusDate, 
    T1.UpdatedUserId, 
    T1.ConcurrencyId,
    T1.FeePaymentStatusId,
    'C',
    GetDate(),
    @StampUser

  FROM TFeePaymentStatus T1
 WHERE T1.FeePaymentStatusId=@FeePaymentStatusId
  EXEC SpRetrieveFeePaymentStatusById @FeePaymentStatusId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)



GO
