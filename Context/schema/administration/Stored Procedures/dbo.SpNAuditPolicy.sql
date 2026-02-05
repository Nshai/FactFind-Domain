SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicy]
	@StampUser varchar (255),
	@PolicyId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyAudit 
( EntityId, RightMask, AdvancedMask, RoleId, Propogate, Applied, IndigoClientId, ConcurrencyId, 
  PolicyId, StampAction, StampDateTime, StampUser, Inherit, UserId, GroupId) 
Select EntityId, RightMask, AdvancedMask, RoleId, Propogate, Applied, IndigoClientId, ConcurrencyId, 
	PolicyId, @StampAction, GETDATE(), @StampUser, Inherit, UserId, GroupId
FROM TPolicy
WHERE PolicyId = @PolicyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
