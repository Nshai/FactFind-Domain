SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefPaymentBasisType]
	@StampUser varchar (255),
	@RefPaymentBasisTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPaymentBasisTypeAudit 
( PaymentBasisTypeName, OrigoRef, RetireFg, ConcurrencyId, 
		
	RefPaymentBasisTypeId, StampAction, StampDateTime, StampUser) 
Select PaymentBasisTypeName, OrigoRef, RetireFg, ConcurrencyId, 
		
	RefPaymentBasisTypeId, @StampAction, GetDate(), @StampUser
FROM TRefPaymentBasisType
WHERE RefPaymentBasisTypeId = @RefPaymentBasisTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
