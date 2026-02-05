SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateRetainerPaymentStatus]
@StampUser varchar (255),
@RetainerId bigint,
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
  DECLARE @RetainerPaymentStatusId bigint

  INSERT INTO TRetainerPaymentStatus (
    RetainerId, 
    PaymentStatus, 
    PaymentStatusNotes, 
    PaymentStatusDate, 
    UpdatedUserId, 
    ConcurrencyId ) 
  VALUES (
    @RetainerId, 
    @PaymentStatus, 
    @PaymentStatusNotes, 
    @PaymentStatusDate, 
    @UpdatedUserId, 
    1) 

  SELECT @RetainerPaymentStatusId = SCOPE_IDENTITY()
  INSERT INTO TRetainerPaymentStatusAudit (
    RetainerId, 
    PaymentStatus, 
    PaymentStatusNotes, 
    PaymentStatusDate, 
    UpdatedUserId, 
    ConcurrencyId,
    RetainerPaymentStatusId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.RetainerId, 
    T1.PaymentStatus, 
    T1.PaymentStatusNotes, 
    T1.PaymentStatusDate, 
    T1.UpdatedUserId, 
    T1.ConcurrencyId,
    T1.RetainerPaymentStatusId,
    'C',
    GetDate(),
    @StampUser

  FROM TRetainerPaymentStatus T1
 WHERE T1.RetainerPaymentStatusId=@RetainerPaymentStatusId
  EXEC SpRetrieveRetainerPaymentStatusById @RetainerPaymentStatusId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)



GO
