SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateRefPlanActionStatusRole]
	@StampUser varchar (255),
	@LifeCycleStepId bigint, 
	@RefPlanActionId bigint, 
	@RoleId bigint	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @RefPlanActionStatusRoleId bigint
			
	SELECT @RefPlanActionStatusRoleId = RefPlanActionStatusRoleId	
	FROM TRefPlanActionStatusRole
	WHERE RefPlanActionId = @RefPlanActionId AND LifeCycleStepId = @LifeCycleStepId AND RoleId = @RoleId
	
	IF(@RefPlanActionStatusRoleId IS NULL) --Create only if not exists (BAU-1943)
	BEGIN
	
	INSERT INTO TRefPlanActionStatusRole (
		LifeCycleStepId, 
		RefPlanActionId, 
		RoleId, 
		ConcurrencyId)
		
	VALUES(
		@LifeCycleStepId, 
		@RefPlanActionId, 
		@RoleId,
		1)

	SELECT @RefPlanActionStatusRoleId = SCOPE_IDENTITY()

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
		LifeCycleStepId, 
		RefPlanActionId, 
		RoleId, 
		ConcurrencyId,
		RefPlanActionStatusRoleId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TRefPlanActionStatusRole
	WHERE RefPlanActionStatusRoleId = @RefPlanActionStatusRoleId

	END
	
	EXEC SpRetrieveRefPlanActionStatusRoleById @RefPlanActionStatusRoleId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
