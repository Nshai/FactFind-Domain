SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpAdviceCaseStatusChange_DeleteRoleLinks]
	(
		@RoleId Bigint		
	)

AS

BEGIN
    
	SET NOCOUNT ON

	DECLARE @tx int
	SELECT @tx = @@TRANCOUNT
	IF @tx = 0 BEGIN TRANSACTION TX
	BEGIN

-----------------------------------------------------------------
-- Advice Case Status Change Role Links
-----------------------------------------------------------------
INSERT INTO dbo.TAdviceCaseStatusChangeRoleAudit (
	AdviceCaseStatusChangeId, RoleId, ConcurrencyId, AdviceCaseStatusChangeRoleId, StampAction, StampDateTime, StampUser)
SELECT
	A.AdviceCaseStatusChangeId, A.RoleId, A.ConcurrencyId, A.AdviceCaseStatusChangeRoleId, 'D', GETDATE(), 0
FROM 
	dbo.TAdviceCaseStatusChangeRole A
	LEFT JOIN Administration..TRole R ON R.RoleId = A.RoleId
WHERE
	A.RoleId = @RoleId
	--AND R.RoleId IS NULL	-- these are rows where the role has been removed	

DELETE
	A
FROM 
	dbo.TAdviceCaseStatusChangeRole A
	LEFT JOIN Administration..TRole R ON R.RoleId = A.RoleId
WHERE
	A.RoleId = @RoleId
	--AND R.RoleId IS NULL	-- these are rows where the role has been removed	


	
	IF @@ERROR != 0 GOTO errh
	IF @tx = 0 COMMIT TRANSACTION TX
		SELECT 1
	END
	RETURN (0)

	errh:
	  IF @tx = 0 ROLLBACK TRANSACTION TX
	  RETURN (100)

END
GO
