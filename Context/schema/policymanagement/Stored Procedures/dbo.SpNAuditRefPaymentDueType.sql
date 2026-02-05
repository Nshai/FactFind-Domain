SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefPaymentDueType]
	@StampUser varchar (255),
	@RefPaymentDueTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPaymentDueTypeAudit 
( PaymentDueType, RetireFg, ConcurrencyId, 
	RefPaymentDueTypeId, StampAction, StampDateTime, StampUser) 
Select PaymentDueType, RetireFg, ConcurrencyId, 
	RefPaymentDueTypeId, @StampAction, GetDate(), @StampUser
FROM TRefPaymentDueType
WHERE RefPaymentDueTypeId = @RefPaymentDueTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
