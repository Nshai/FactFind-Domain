CREATE PROCEDURE [dbo].[spCustomCreateRolePermissionsForLifeCycleTransitionsForNewTenant]
(
	@NewTenantId BIGINT
)
AS

BEGIN TRANSACTION

BEGIN

--### Delete all existing status transitions role permissions

	-- Audit records before deleting
		INSERT INTO PolicyManagement.dbo.TTransitionRoleAudit(
			TransitionRoleId, RoleId, LifeCycleTransitionId, ConcurrencyId,
			StampAction,StampDateTime,StampUser)		
		SELECT tr.TransitionRoleId, tr.RoleId, tr.LifeCycleTransitionId, tr.ConcurrencyId,
			'D', GETDATE(), 0
		FROM PolicyManagement.dbo.TTransitionRole tr  
			INNER JOIN PolicyManagement.dbo.TLifeCycleTransition t on t.LifeCycleTransitionId = tr.LifeCycleTransitionId
			INNER JOIN PolicyManagement.dbo.TLifeCycleStep lcs on lcs.LifeCycleStepId = t.LifeCycleStepId		
			INNER JOIN PolicyManagement.dbo.TStatus s on s.StatusId = lcs.StatusId
			INNER JOIN Administration.dbo.TRole r1 ON tr.RoleId = r1.RoleId  			
		WHERE r1.IndigoClientId = @NewTenantId
			AND s.IndigoClientId = @NewTenantId
	
	--Delete
		DELETE tr 
		--SELECT tr.*
		FROM PolicyManagement.dbo.TTransitionRole tr  
			INNER JOIN PolicyManagement.dbo.TLifeCycleTransition t on t.LifeCycleTransitionId = tr.LifeCycleTransitionId
			INNER JOIN PolicyManagement.dbo.TLifeCycleStep lcs on lcs.LifeCycleStepId = t.LifeCycleStepId		
			INNER JOIN PolicyManagement.dbo.TStatus s on s.StatusId = lcs.StatusId
			INNER JOIN Administration.dbo.TRole r1 ON tr.RoleId = r1.RoleId  			
		WHERE r1.IndigoClientId = @NewTenantId
			AND s.IndigoClientId = @NewTenantId

--###
	
	DECLARE @LifeCycleTransitionId BIGINT
	DECLARE @FirstId BIGINT, @LastId BIGINT  

	DECLARE lifecycletransition_cursor CURSOR        
	FOR SELECT lct.LifeCycleTransitionId FROM PolicyManagement.dbo.TLifeCycleTransition lct
			INNER JOIN PolicyManagement.dbo.TLifeCycleStep lcs on lcs.LifeCycleStepId = lct.LifeCycleStepId
			INNER JOIN PolicyManagement.dbo.TLifeCycle lc on lc.LifeCycleId = lcs.LifeCycleId
			INNER JOIN PolicyManagement.dbo.TStatus s on s.StatusId = lcs.StatusId
		WHERE lc.IndigoClientId = @NewTenantId
		and s.IndigoClientId = @NewTenantId 
	
	OPEN lifecycletransition_cursor
	        
	 FETCH NEXT FROM lifecycletransition_cursor Into @LifeCycleTransitionId
	        
	 WHILE @@FETCH_STATUS = 0        
	 BEGIN        
	  
		--Insert	  
			SET @FirstId = IDENT_CURRENT('TTransitionRole')  
		  
			INSERT INTO PolicyManagement.dbo.TTransitionRole (RoleId, LifeCycleTransitionId, ConcurrencyId)
			SELECT RoleId, @LifeCycleTransitionId, 1 
			FROM Administration.dbo.TRole WHERE Indigoclientid = @NewTenantId      
			ORDER BY roleid      
			
			SET @LastId = IDENT_CURRENT('TTransitionRole')  
			
		--Audit
			INSERT INTO PolicyManagement.dbo.TTransitionRoleAudit(
				RoleId, LifeCycleTransitionId, ConcurrencyId,TransitionRoleId,
				StampAction, StampDateTime, StampUser)
			SELECT RoleId, LifeCycleTransitionId, ConcurrencyId,TransitionRoleId,
				'C', GETDATE(), 0
			FROM PolicyManagement.dbo.TTransitionRole WHERE TransitionRoleId BETWEEN (@FirstId+1) AND @LastId  		

	 FETCH NEXT FROM lifecycletransition_cursor INTO @LifeCycleTransitionId       
	 END        
                  
	CLOSE lifecycletransition_cursor        
	DEALLOCATE lifecycletransition_cursor      

END

COMMIT TRANSACTION
