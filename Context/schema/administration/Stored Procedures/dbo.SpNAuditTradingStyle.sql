SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditTradingStyle]
	@StampUser varchar (255),
	@TradingStyleId bigint,
	@StampAction char(1)
AS

INSERT INTO TTradingStyleAudit 
(ConcurrencyId,TradingStyleDescription,Email,PhoneNumber,FaxNumber,ProcFeePayableTo,TenantId,TradingStyleId,
StampAction,StampDateTime,StampUser) 
Select ConcurrencyId,TradingStyleDescription,Email,PhoneNumber,FaxNumber,ProcFeePayableTo,TenantId,TradingStyleId,
 @StampAction, GetDate(), @StampUser
FROM TTradingStyle
WHERE TradingStyleId = @TradingStyleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
