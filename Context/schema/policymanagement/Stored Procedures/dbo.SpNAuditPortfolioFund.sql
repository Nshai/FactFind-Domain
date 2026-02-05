SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPortfolioFund]
	@StampUser varchar (255),
	@PortfolioFundId bigint,
	@StampAction char(1)
AS

INSERT INTO TPortfolioFundAudit 
( PortfolioId, FundUnitId, EquityId, AllocationPercentage, IsLocked, 
		ConcurrencyId, UnitId,
	PortfolioFundId, StampAction, StampDateTime, StampUser) 
Select PortfolioId, FundUnitId, EquityId, AllocationPercentage, IsLocked, 
		ConcurrencyId, UnitId,
	PortfolioFundId, @StampAction, GetDate(), @StampUser
FROM TPortfolioFund
WHERE PortfolioFundId = @PortfolioFundId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
