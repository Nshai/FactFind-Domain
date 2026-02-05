SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefBenefitPaymentType]
	@StampUser varchar (255),
	@RefBenefitPaymentTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefBenefitPaymentTypeAudit 
( BenefitTypeName, OrigoRef, RetireFg, ConcurrencyId, 
		
	RefBenefitPaymentTypeId, StampAction, StampDateTime, StampUser) 
Select BenefitTypeName, OrigoRef, RetireFg, ConcurrencyId, 
		
	RefBenefitPaymentTypeId, @StampAction, GetDate(), @StampUser
FROM TRefBenefitPaymentType
WHERE RefBenefitPaymentTypeId = @RefBenefitPaymentTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
