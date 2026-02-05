SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefPaymentType]
	@StampUser varchar (255),
	@RefPaymentTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPaymentTypeAudit 
( IndClientId, Name, Description, ActiveFG, 
		ConcurrencyId, 
	RefPaymentTypeId, StampAction, StampDateTime, StampUser) 
Select IndClientId, Name, Description, ActiveFG, 
		ConcurrencyId, 
	RefPaymentTypeId, @StampAction, GetDate(), @StampUser
FROM TRefPaymentType
WHERE RefPaymentTypeId = @RefPaymentTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
