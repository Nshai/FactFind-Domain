SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditSwitch]
	@StampUser varchar (255),
	@SwitchId bigint,
	@StampAction char(1)
AS

INSERT INTO TSwitchAudit 
( PolicyBusinessId, RefProdProviderId, RefPlanTypeId, Value, 
		ConcurrencyId, 
	SwitchId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, RefProdProviderId, RefPlanTypeId, Value, 
		ConcurrencyId, 
	SwitchId, @StampAction, GetDate(), @StampUser
FROM TSwitch
WHERE SwitchId = @SwitchId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
