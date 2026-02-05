SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQuotePremium]
	@StampUser varchar (255),
	@QuotePremiumId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuotePremiumAudit 
( Frequency, Type, TenantId, ConcurrencyId, 
		
	QuotePremiumId, StampAction, StampDateTime, StampUser) 
Select Frequency, Type, TenantId, ConcurrencyId, 
		
	QuotePremiumId, @StampAction, GetDate(), @StampUser
FROM TQuotePremium
WHERE QuotePremiumId = @QuotePremiumId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
