SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDeleteRefPlanActionStatusRoleById]
	@RefPlanActionStatusRoleId Bigint,
	@StampUser varchar (255)
	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN

	INSERT INTO TRefPlanActionStatusRoleAudit (
		LifeCycleStepId, 
		RefPlanActionId, 
		RoleId, 
		ConcurrencyId,
		RefPlanActionStatusRoleId,
		StampAction,
    		StampDateTime,
    		StampUser)
		
	SELECT 
		T1.LifeCycleStepId, 
		T1.RefPlanActionId, 
		T1.RoleId, 
		T1.ConcurrencyId,
		T1.RefPlanActionStatusRoleId,
		'D',
    		GetDate(),
    		@StampUser 
	FROM TRefPlanActionStatusRole T1	
	WHERE T1.RefPlanActionStatusRoleId = @RefPlanActionStatusRoleId

	DELETE T1 FROM TRefPlanActionStatusRole T1
	WHERE T1.RefPlanActionStatusRoleId = @RefPlanActionStatusRoleId

	SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
