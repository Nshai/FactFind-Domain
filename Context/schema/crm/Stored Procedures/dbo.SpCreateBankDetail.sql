SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateBankDetail]
@StampUser varchar (255),
@IndClientId bigint,
@CRMOwnerId bigint,
@SortCode varchar (50),
@AccName varchar (50),
@AccNumber varchar (50),
@CorporateId bigint = NULL,
@CRMBranchId bigint = NULL,
@RefAccTypeId bigint = NULL,
@RefAccUseId bigint = NULL,
@AccBalance money = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @BankDetailId bigint

  INSERT INTO TBankDetail (
    IndClientId, 
    CRMOwnerId, 
    SortCode, 
    AccName, 
    AccNumber, 
    CorporateId, 
    CRMBranchId, 
    RefAccTypeId, 
    RefAccUseId, 
    AccBalance, 
    ConcurrencyId ) 
  VALUES (
    @IndClientId, 
    @CRMOwnerId, 
    @SortCode, 
    @AccName, 
    @AccNumber, 
    @CorporateId, 
    @CRMBranchId, 
    @RefAccTypeId, 
    @RefAccUseId, 
    @AccBalance, 
    1) 

  SELECT @BankDetailId = SCOPE_IDENTITY()
  INSERT INTO TBankDetailAudit (
    IndClientId, 
    CRMOwnerId, 
    SortCode, 
    AccName, 
    AccNumber, 
    CorporateId, 
    CRMBranchId, 
    RefAccTypeId, 
    RefAccUseId, 
    AccBalance, 
    ConcurrencyId,
    BankDetailId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndClientId, 
    T1.CRMOwnerId, 
    T1.SortCode, 
    T1.AccName, 
    T1.AccNumber, 
    T1.CorporateId, 
    T1.CRMBranchId, 
    T1.RefAccTypeId, 
    T1.RefAccUseId, 
    T1.AccBalance, 
    T1.ConcurrencyId,
    T1.BankDetailId,
    'C',
    GetDate(),
    @StampUser

  FROM TBankDetail T1
 WHERE T1.BankDetailId=@BankDetailId
  EXEC SpRetrieveBankDetailById @BankDetailId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)








GO
