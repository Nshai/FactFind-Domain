SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditBudget]
	@StampUser varchar (255),
	@BudgetId bigint,
	@StampAction char(1)
AS

INSERT INTO TBudgetAudit 
(BudgetId, ClientId, TenantId, Category,
Amount, CreatedOn, CreatedByUserId, UpdatedOn,
UpdatedByUserId, ConcurrencyId, 
StampAction, StampDateTime, StampUser) 
SELECT BudgetId, ClientId, TenantId, Category,
Amount, CreatedOn, CreatedByUserId, UpdatedOn,
UpdatedByUserId, ConcurrencyId, 
@StampAction, GetDate(), @StampUser
FROM TBudget
WHERE BudgetId = @BudgetId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO