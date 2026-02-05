SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefCurrency]
	@StampUser varchar (255),
	@RefCurrencyId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefCurrencyAudit 
( CurrencyCode, Description, Symbol, ConcurrencyId, 
		
	RefCurrencyId, StampAction, StampDateTime, StampUser) 
Select CurrencyCode, Description, Symbol, ConcurrencyId, 
		
	RefCurrencyId, @StampAction, GetDate(), @StampUser
FROM TRefCurrency
WHERE RefCurrencyId = @RefCurrencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
