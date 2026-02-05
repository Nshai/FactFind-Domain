SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_CustomDeleteKeysByRoleId](@nRoleId bigint, @StampUserId bigint = 0) AS

DELETE FROM Administration.dbo.TKey
	OUTPUT
		deleted.RightMask,
		deleted.SystemId,
		deleted.UserId,
		deleted.RoleId,
		deleted.ConcurrencyId,
		deleted.KeyId, 
		'D', 
		GETUTCDATE(), 
		@StampUserId
	INTO
		Administration.dbo.TKeyAudit (
		RightMask,
		SystemId, 
		UserId, 
		RoleId,
		ConcurrencyId, 
		KeyId, 
		StampAction, 
		StampDateTime,
		StampUser)
WHERE RoleId = @nRoleId

SELECT 1
GO
