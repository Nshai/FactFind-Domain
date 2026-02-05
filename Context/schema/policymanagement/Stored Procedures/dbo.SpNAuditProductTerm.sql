SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditProductTerm]
	@StampUser varchar (255),
	@ProductTermId bigint,
	@StampAction char(1)
AS

INSERT INTO TProductTermAudit 
( TermType, Value, TenantId, ConcurrencyId, 
		
	ProductTermId, StampAction, StampDateTime, StampUser) 
Select TermType, Value, TenantId, ConcurrencyId, 
		
	ProductTermId, @StampAction, GetDate(), @StampUser
FROM TProductTerm
WHERE ProductTermId = @ProductTermId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
