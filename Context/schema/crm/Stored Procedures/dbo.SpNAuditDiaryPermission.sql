SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditDiaryPermission]
	@StampUser varchar (255),
	@DiaryPermissionId bigint,
	@StampAction char(1)
AS

INSERT INTO TDiaryPermissionAudit 
( OwnerUserId, PermittedUserId, IsWriteAccess, ConcurrencyId, 
		
	DiaryPermissionId, StampAction, StampDateTime, StampUser) 
Select OwnerUserId, PermittedUserId, IsWriteAccess, ConcurrencyId, 
		
	DiaryPermissionId, @StampAction, GetDate(), @StampUser
FROM TDiaryPermission
WHERE DiaryPermissionId = @DiaryPermissionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
