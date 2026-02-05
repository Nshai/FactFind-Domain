SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefQuoteStatus]
	@StampUser varchar (255),
	@RefQuoteStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefQuoteStatusAudit 
( QuoteStatusName, ConcurrencyId, 
	RefQuoteStatusId, StampAction, StampDateTime, StampUser) 
Select QuoteStatusName, ConcurrencyId, 
	RefQuoteStatusId, @StampAction, GetDate(), @StampUser
FROM TRefQuoteStatus
WHERE RefQuoteStatusId = @RefQuoteStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
