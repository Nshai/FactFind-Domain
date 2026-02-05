SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPortfolioClientPlan]
	@StampUser varchar (255),
	@PortfolioClientPlanId bigint,
	@StampAction char(1)
AS

INSERT INTO TPortfolioClientPlanAudit 
( PortfolioClientId, PolicyBusinessId, ConcurrencyId, 
	PortfolioClientPlanId, StampAction, StampDateTime, StampUser) 
Select PortfolioClientId, PolicyBusinessId, ConcurrencyId, 
	PortfolioClientPlanId, @StampAction, GetDate(), @StampUser
FROM TPortfolioClientPlan
WHERE PortfolioClientPlanId = @PortfolioClientPlanId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
