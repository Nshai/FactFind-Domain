SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditBankPaymentDetail]
	@StampUser varchar (255),
	@BankPaymentDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO TBankPaymentDetailAudit 
( IndClientId, BankDetailId, CRMOwnerId, RefPaymentTypeId, 
		PayByChequeFg, BlockedFg, ConcurrencyId, 
	BankPaymentDetailId, StampAction, StampDateTime, StampUser) 
Select IndClientId, BankDetailId, CRMOwnerId, RefPaymentTypeId, 
		PayByChequeFg, BlockedFg, ConcurrencyId, 
	BankPaymentDetailId, @StampAction, GetDate(), @StampUser
FROM TBankPaymentDetail
WHERE BankPaymentDetailId = @BankPaymentDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
