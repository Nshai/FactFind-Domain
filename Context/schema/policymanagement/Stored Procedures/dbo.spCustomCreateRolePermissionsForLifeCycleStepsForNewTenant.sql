CREATE PROCEDURE [dbo].[spCustomCreateRolePermissionsForLifeCycleStepsForNewTenant]
(
	@NewTenantId BIGINT
)
AS

BEGIN TRANSACTION

BEGIN

--### Delete all existing lifecycle steps role permissions

	-- Audit records before deleting
	INSERT INTO PolicyManagement.dbo.TRefPlanActionStatusRoleAudit(
		LifeCycleStepId, RefPlanActionId, RoleId, ConcurrencyId, RefPlanActionStatusRoleId, 
		StampAction, StampDateTime, StampUser)
	--SELECT rpasr.*
	SELECT rpasr.LifeCycleStepId, rpasr.RefPlanActionId, rpasr.RoleId, rpasr.ConcurrencyId, rpasr.RefPlanActionStatusRoleId,
		'D', GETDATE(), 0
	FROM PolicyManagement.dbo.TRefPlanActionStatusRole rpasr
		INNER JOIN PolicyManagement.dbo.TLifeCycleStep lcs on rpasr.LifeCycleStepId = lcs.LifeCycleStepId
		INNER JOIN PolicyManagement.dbo.TStatus s on s.StatusId = lcs.StatusId      
	WHERE s.IndigoClientId = @NewTenantID	
	
	--Delete existing lifecycle role permissions
	DELETE rpasr 
	--SELECT rpasr.*
	FROM PolicyManagement.dbo.TRefPlanActionStatusRole rpasr
		INNER JOIN PolicyManagement.dbo.TLifeCycleStep lcs on rpasr.LifeCycleStepId = lcs.LifeCycleStepId
		INNER JOIN PolicyManagement.dbo.TStatus s on s.StatusId = lcs.StatusId      
	WHERE s.IndigoClientId = @NewTenantID

--### Populate lifecycle steps role permissions
	
	DECLARE @RefPlanActionId BIGINT
	DECLARE @FirstId BIGINT, @LastId BIGINT  

	DECLARE refplanaction_cursor CURSOR        
	FOR SELECT RefPlanActionId FROM PolicyManagement.dbo.TRefPlanAction	
		WHERE Identifier NOT IN ('filequeue','filechecking','Proposals')
	OPEN refplanaction_cursor
	        
	 FETCH NEXT FROM refplanaction_cursor Into @RefPlanActionId
	        
	 WHILE @@FETCH_STATUS = 0        
	 BEGIN        
	  
		--Insert records
			SET @FirstId = IDENT_CURRENT('TRefPlanActionStatusRole')  
			Print @FirstId
		  
			INSERT INTO PolicyManagement.dbo.TRefPlanActionStatusRole (LifeCycleStepId,RefPlanActionId, RoleId,ConcurrencyId)      
			SELECT lcs.LifeCycleStepId, @RefPlanActionId, r.RoleId, 1 
			FROM PolicyManagement.dbo.TLifeCycleStep lcs      
				INNER JOIN PolicyManagement.dbo.TStatus s ON s.StatusId = lcs.StatusId      
				LEFT JOIN Administration.dbo.TRole r ON s.IndigoClientId = r.IndigoClientId      
			WHERE s.indigoclientid = @NewTenantId      
			ORDER BY roleid      
			
			SET @LastId = IDENT_CURRENT('TRefPlanActionStatusRole')  
			Print @LastId
			
		--Audit records
			INSERT INTO PolicyManagement.dbo.TRefPlanActionStatusRoleAudit(
				LifeCycleStepId, RefPlanActionId, RoleId, ConcurrencyId, RefPlanActionStatusRoleId, 
				StampAction, StampDateTime, StampUser)
			SELECT LifeCycleStepId, RefPlanActionId, RoleId, ConcurrencyId, RefPlanActionStatusRoleId,
				'C', GETDATE(), 0
			FROM PolicyManagement.dbo.TRefPlanActionStatusRole WHERE RefPlanActionStatusRoleId BETWEEN (@FirstId+1) AND @LastId
			
	 FETCH NEXT FROM refplanaction_cursor INTO @RefPlanActionId       
	 END        
                  
	CLOSE refplanaction_cursor        
	DEALLOCATE refplanaction_cursor      

END

COMMIT TRANSACTION
