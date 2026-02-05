SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicyBusinessTotalPlanValuationType]
	@StampUser varchar (255),
	@PolicyBusinessId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyBusinessTotalPlanValuationTypeAudit
( TenantId, RefTotalPlanValuationTypeId, ConcurrencyId, 
	PolicyBusinessId, StampAction, StampDateTime, StampUser) 
Select TenantId, RefTotalPlanValuationTypeId, ConcurrencyId, 
	PolicyBusinessId, @StampAction, GetDate(), @StampUser
FROM TPolicyBusinessTotalPlanValuationType
WHERE PolicyBusinessId = @PolicyBusinessId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
