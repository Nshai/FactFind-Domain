SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditSchemePlanType]
	@StampUser varchar (255),
	@SchemePlanTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TSchemePlanTypeAudit 
( SchemeTypeId, RefPlanType2ProdSubTypeId, ConcurrencyId, 
	SchemePlanTypeId, StampAction, StampDateTime, StampUser) 
Select SchemeTypeId, RefPlanType2ProdSubTypeId, ConcurrencyId, 
	SchemePlanTypeId, @StampAction, GetDate(), @StampUser
FROM TSchemePlanType
WHERE SchemePlanTypeId = @SchemePlanTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
