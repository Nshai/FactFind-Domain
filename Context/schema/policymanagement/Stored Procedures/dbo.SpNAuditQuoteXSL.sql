SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQuoteXSL]
	@StampUser varchar (255),
	@QuoteXSLId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuoteXSLAudit 
( XSLIdentifier, RefApplicationId, RefXSLTypeId, XSLData, 
		IsArchived, ConcurrencyId, 
	QuoteXSLId, StampAction, StampDateTime, StampUser) 
Select XSLIdentifier, RefApplicationId, RefXSLTypeId, XSLData, 
		IsArchived, ConcurrencyId, 
	QuoteXSLId, @StampAction, GetDate(), @StampUser
FROM TQuoteXSL
WHERE QuoteXSLId = @QuoteXSLId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
