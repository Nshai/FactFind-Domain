SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditPlanTag]
	@StampUser varchar (255),
	@PlanTagId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanTagAudit
(PlanTagId, PolicyBusinessId, Name, TenantId, StampAction, StampDateTime, StampUser)
SELECT
PlanTagId, PolicyBusinessId, Name, TenantId, @StampAction, GetDate(), @StampUser
FROM TPlanTag
WHERE PlanTagId = @PlanTagId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO

