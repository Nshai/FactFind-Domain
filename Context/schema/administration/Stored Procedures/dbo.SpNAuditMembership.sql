SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditMembership]
	@StampUser varchar (255),
	@MembershipId bigint,
	@StampAction char(1)
AS

INSERT INTO TMembershipAudit 
( UserId, RoleId, ConcurrencyId, 
	MembershipId, StampAction, StampDateTime, StampUser) 
Select UserId, RoleId, ConcurrencyId, 
	MembershipId, @StampAction, GetDate(), @StampUser
FROM TMembership
WHERE MembershipId = @MembershipId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
