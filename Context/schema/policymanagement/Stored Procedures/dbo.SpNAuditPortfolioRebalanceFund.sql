SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPortfolioRebalanceFund]
	@StampUser varchar (255),
	@PortfolioRebalanceFundId bigint,
	@StampAction char(1)
AS

INSERT INTO TPortfolioRebalanceFundAudit 
( PortfolioRebalanceId, FundName, UnitsHeld, Price, 
		Value, TargetPercentage, ChangeUnitsHeld, ChangeAmount, 
		ConcurrencyId, 
	PortfolioRebalanceFundId, StampAction, StampDateTime, StampUser) 
Select PortfolioRebalanceId, FundName, UnitsHeld, Price, 
		Value, TargetPercentage, ChangeUnitsHeld, ChangeAmount, 
		ConcurrencyId, 
	PortfolioRebalanceFundId, @StampAction, GetDate(), @StampUser
FROM TPortfolioRebalanceFund
WHERE PortfolioRebalanceFundId = @PortfolioRebalanceFundId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
