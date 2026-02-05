SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefPaymentOn]
	@StampUser varchar (255),
	@RefPaymentOnId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPaymentOnAudit 
( Descriptor, ArchiveFG, IndigoClientId, ConcurrencyId, 
		
	RefPaymentOnId, StampAction, StampDateTime, StampUser) 
Select Descriptor, ArchiveFG, IndigoClientId, ConcurrencyId, 
		
	RefPaymentOnId, @StampAction, GetDate(), @StampUser
FROM TRefPaymentOn
WHERE RefPaymentOnId = @RefPaymentOnId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
