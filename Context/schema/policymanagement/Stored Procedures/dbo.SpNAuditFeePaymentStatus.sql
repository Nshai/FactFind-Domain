SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFeePaymentStatus]
	@StampUser varchar (255),
	@FeePaymentStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeePaymentStatusAudit 
( FeeId, PaymentStatus, PaymentStatusNotes, PaymentStatusDate, 
		UpdatedUserId, ConcurrencyId, 
	FeePaymentStatusId, StampAction, StampDateTime, StampUser) 
Select FeeId, PaymentStatus, PaymentStatusNotes, PaymentStatusDate, 
		UpdatedUserId, ConcurrencyId, 
	FeePaymentStatusId, @StampAction, GetDate(), @StampUser
FROM TFeePaymentStatus
WHERE FeePaymentStatusId = @FeePaymentStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
