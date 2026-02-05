SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQuotePHI]
	@StampUser varchar (255),
	@QuotePHIId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuotePHIAudit 
( QuoteItemId, Premium, PremiumIncrease, CoverPeriod, 
		DeferredPeriod, Benefit, Salary, ConcurrencyId, 
		
	QuotePHIId, StampAction, StampDateTime, StampUser) 
Select QuoteItemId, Premium, PremiumIncrease, CoverPeriod, 
		DeferredPeriod, Benefit, Salary, ConcurrencyId, 
		
	QuotePHIId, @StampAction, GetDate(), @StampUser
FROM TQuotePHI
WHERE QuotePHIId = @QuotePHIId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
