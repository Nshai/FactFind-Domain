SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateBankPaymentDetail]
@StampUser varchar (255),
@IndClientId bigint,
@BankDetailId bigint,
@CRMOwnerId bigint,
@RefPaymentTypeId bigint,
@PayByChequeFg tinyint = 0,
@BlockedFg tinyint = 0
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @BankPaymentDetailId bigint

  INSERT INTO TBankPaymentDetail (
    IndClientId, 
    BankDetailId, 
    CRMOwnerId, 
    RefPaymentTypeId, 
    PayByChequeFg, 
    BlockedFg, 
    ConcurrencyId ) 
  VALUES (
    @IndClientId, 
    @BankDetailId, 
    @CRMOwnerId, 
    @RefPaymentTypeId, 
    @PayByChequeFg, 
    @BlockedFg, 
    1) 

  SELECT @BankPaymentDetailId = SCOPE_IDENTITY()
  INSERT INTO TBankPaymentDetailAudit (
    IndClientId, 
    BankDetailId, 
    CRMOwnerId, 
    RefPaymentTypeId, 
    PayByChequeFg, 
    BlockedFg, 
    ConcurrencyId,
    BankPaymentDetailId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndClientId, 
    T1.BankDetailId, 
    T1.CRMOwnerId, 
    T1.RefPaymentTypeId, 
    T1.PayByChequeFg, 
    T1.BlockedFg, 
    T1.ConcurrencyId,
    T1.BankPaymentDetailId,
    'C',
    GetDate(),
    @StampUser

  FROM TBankPaymentDetail T1
 WHERE T1.BankPaymentDetailId=@BankPaymentDetailId
  EXEC SpRetrieveBankPaymentDetailById @BankPaymentDetailId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)








GO
