SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditDiscountReason]
	@StampUser varchar (255),
	@DiscountReasonId bigint,
	@StampAction char(1)
AS

INSERT INTO TDiscountReasonAudit 
( Identifier, Descriptor, IndigoClientId, ConcurrencyId, 
		
	DiscountReasonId, StampAction, StampDateTime, StampUser) 
Select Identifier, Descriptor, IndigoClientId, ConcurrencyId, 
		
	DiscountReasonId, @StampAction, GetDate(), @StampUser
FROM TDiscountReason
WHERE DiscountReasonId = @DiscountReasonId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
