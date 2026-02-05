SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditGroupTradingStyle]
	@StampUser varchar (255),
	@GroupTradingStyleId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupTradingStyleAudit 
(ConcurrencyId,GroupId,IntegratedSystemId,TradingStyleId,IsPropagate,TenantId,GroupTradingStyleId,
StampAction,StampDateTime,StampUser) 
Select ConcurrencyId,GroupId,IntegratedSystemId,TradingStyleId,IsPropagate,TenantId,GroupTradingStyleId,
 @StampAction, GetDate(), @StampUser
FROM TGroupTradingStyle
WHERE GroupTradingStyleId = @GroupTradingStyleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
