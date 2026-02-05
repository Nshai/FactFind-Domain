SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIntegrationActivity]
	@StampUser varchar (255),
	@IntegrationActivityId bigint,
	@StampAction char(1)
AS

INSERT INTO TIntegrationActivityAudit
                      (Description, CreatedOn, Success, IntegratedSystemId, SagaId, Discriminator, PlanId, QuoteId, PartyId, UserId, UserName, ConcurrencyId, IntegrationActivityId, 
                      StampAction, StampDateTime, StampUser, ActivityType, ErrorDetails, ActivitySubType)
SELECT     Description, CreatedOn, Success, IntegratedSystemId, SagaId, Discriminator, PlanId, QuoteId, PartyId, UserId, UserName, ConcurrencyId, IntegrationActivityId, 
                      @StampAction AS Expr1, GETDATE() AS Expr2, @StampUser AS Expr3, ActivityType, ErrorDetails, ActivitySubType
FROM         TIntegrationActivity
WHERE     (IntegrationActivityId = @IntegrationActivityId)

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
