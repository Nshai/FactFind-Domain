SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditWrapperPlanType]
	@StampUser varchar (255),
	@WrapperPlanTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TWrapperPlanTypeAudit 
( WrapperProviderId, RefPlanType2ProdSubTypeId, ConcurrencyId, 
	WrapperPlanTypeId, StampAction, StampDateTime, StampUser) 
Select WrapperProviderId, RefPlanType2ProdSubTypeId, ConcurrencyId, 
	WrapperPlanTypeId, @StampAction, GetDate(), @StampUser
FROM TWrapperPlanType
WHERE WrapperPlanTypeId = @WrapperPlanTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
