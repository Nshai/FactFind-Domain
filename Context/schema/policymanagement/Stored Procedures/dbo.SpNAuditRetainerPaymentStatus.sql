SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRetainerPaymentStatus]
	@StampUser varchar (255),
	@RetainerPaymentStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TRetainerPaymentStatusAudit 
( RetainerId, PaymentStatus, PaymentStatusNotes, PaymentStatusDate, 
		UpdatedUserId, ConcurrencyId, 
	RetainerPaymentStatusId, StampAction, StampDateTime, StampUser) 
Select RetainerId, PaymentStatus, PaymentStatusNotes, PaymentStatusDate, 
		UpdatedUserId, ConcurrencyId, 
	RetainerPaymentStatusId, @StampAction, GetDate(), @StampUser
FROM TRetainerPaymentStatus
WHERE RetainerPaymentStatusId = @RetainerPaymentStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
