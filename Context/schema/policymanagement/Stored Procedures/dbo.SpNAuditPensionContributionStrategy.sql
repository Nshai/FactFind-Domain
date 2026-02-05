SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPensionContributionStrategy]
	@StampUser varchar (255),
	@PensionContributionStrategyId bigint,
	@StampAction char(1)
AS

INSERT INTO TPensionContributionStrategyAudit 
( TenantId, PolicyBusinessId, Period, Percentage, Details, ConcurrencyId, PensionContributionStrategyId, StampAction, StampDateTime, StampUser) 
Select TenantId, PolicyBusinessId, Period, Percentage, Details, ConcurrencyId, PensionContributionStrategyId, @StampAction, GetDate(), @StampUser
FROM TPensionContributionStrategy
WHERE PensionContributionStrategyId = @PensionContributionStrategyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
