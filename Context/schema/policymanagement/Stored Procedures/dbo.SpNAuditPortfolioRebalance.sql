SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPortfolioRebalance]
	@StampUser varchar (255),
	@PortfolioRebalanceId bigint,
	@StampAction char(1)
AS

INSERT INTO TPortfolioRebalanceAudit 
( PortfolioClientId, CreatedBy, DateOfRebalance, IsActioned, 
		TransactionDate, ConcurrencyId, 
	PortfolioRebalanceId, StampAction, StampDateTime, StampUser) 
Select PortfolioClientId, CreatedBy, DateOfRebalance, IsActioned, 
		TransactionDate, ConcurrencyId, 
	PortfolioRebalanceId, @StampAction, GetDate(), @StampUser
FROM TPortfolioRebalance
WHERE PortfolioRebalanceId = @PortfolioRebalanceId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
