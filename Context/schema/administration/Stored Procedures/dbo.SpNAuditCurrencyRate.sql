SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCurrencyRate]
	@StampUser varchar (255),
	@CurrencyRateId bigint,
	@StampAction char(1)
AS

INSERT INTO TCurrencyRateAudit 
( IndigoClientId, CurrencyCode, Rate, Date, 
		ConcurrencyId, 
	CurrencyRateId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, CurrencyCode, Rate, Date, 
		ConcurrencyId, 
	CurrencyRateId, @StampAction, GetDate(), @StampUser
FROM TCurrencyRate
WHERE CurrencyRateId = @CurrencyRateId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
