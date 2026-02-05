SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCRMContactKey]
	@StampUser varchar (255),
	@CRMContactKeyId bigint,
	@StampAction char(1)
AS

INSERT INTO TCRMContactKeyAudit 
( EntityId, CreatorId, UserId, RoleId, 
		RightMask, AdvancedMask, ConcurrencyId, 
	CRMContactKeyId, StampAction, StampDateTime, StampUser) 
Select EntityId, CreatorId, UserId, RoleId, 
		RightMask, AdvancedMask, ConcurrencyId, 
	CRMContactKeyId, @StampAction, GetDate(), @StampUser
FROM TCRMContactKey
WHERE CRMContactKeyId = @CRMContactKeyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
