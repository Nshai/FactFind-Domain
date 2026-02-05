SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditRefCommissionTypeToPaymentDueType]
	@StampUser varchar (255),
	@RefCommissionTypeToPaymentDueTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefCommissionTypeToPaymentDueTypeAudit 
(
	RefCommissionTypeId,
	RefPaymentDueTypeId,
	ConcurrencyId,
	RefCommissionTypeToPaymentDueTypeId,
	StampAction,
	StampDateTime,
	StampUser
) 
SELECT 
	RefCommissionTypeId,
	RefPaymentDueTypeId,
	ConcurrencyId,
	RefCommissionTypeToPaymentDueTypeId,
	@StampAction, 
	GetDate(), 
	@StampUser
FROM TRefCommissionTypeToPaymentDueType
WHERE RefCommissionTypeToPaymentDueTypeId = @RefCommissionTypeToPaymentDueTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
