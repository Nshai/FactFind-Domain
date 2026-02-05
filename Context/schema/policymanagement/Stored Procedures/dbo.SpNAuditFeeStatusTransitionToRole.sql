SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditFeeStatusTransitionToRole]
	@StampUser varchar (255),
	@FeeStatusTransitionToRoleId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeeStatusTransitionToRoleAudit 
( FeeStatusTransitionId, TenantId, RoleId, ConcurrencyId, 
		
	FeeStatusTransitionToRoleId, StampAction, StampDateTime, StampUser) 
Select FeeStatusTransitionId, TenantId, RoleId, ConcurrencyId, 
		
	FeeStatusTransitionToRoleId, @StampAction, GetDate(), @StampUser
FROM TFeeStatusTransitionToRole
WHERE FeeStatusTransitionToRoleId = @FeeStatusTransitionToRoleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
