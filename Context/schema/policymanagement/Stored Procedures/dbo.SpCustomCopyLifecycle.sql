SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SpCustomCopyLifecycle]
@SourceLifeCycleId bigint,
@NewLifeCycleName varchar(255),
@CloneStepTask bit, @CloneStepActions bit, @TransRules bit, @TransTasks bit 

as

declare @SourceAdviceTypeId bigint
declare @NewAdviceTypeId bigint
declare @indigoClientId bigint

DECLARE @StampUser varchar(50)
DECLARE @FirstId bigint, @LastId bigint
set @StampUser = '0'


SELECT @SourceAdviceTypeId = lc2rpt.AdviceTypeId from TLifeCycle2RefPlanType lc2rpt
where lc2rpt.LifeCycleId = @SourceLifeCycleId


-- insert advice Type
	DECLARE @AdviceTypeDescription varchar(255), @IntelligentOfficeAdviceType varchar(255)
	SELECT @IndigoClientId = IndigoClientId
	FROM TAdviceType WHERE AdviceTypeId = @SourceAdviceTypeId
	
	print 'Adding Advice Type ' + @AdviceTypeDescription
	exec SpCreateAdviceType @StampUser, @NewLifeCycleName, @NewLifeCycleName, 0, @IndigoClientId
	set @NewAdviceTypeId = IDENT_CURRENT('TAdviceType')
		

-- insert TLifeCycle
	DECLARE @PreQueueBehaviour varchar(50), @PostQueueBehaviour varchar(50), @NewLifeCycleId bigint, @CreatedDate datetime
	
	SELECT @PreQueueBehaviour = PreQueueBehaviour, @PostQueueBehaviour = PostQueueBehaviour
	FROM TLifeCycle
	WHERE LifeCycleId = @SourceLifeCycleId
		
	set @CreatedDate = getdate()
	
	print 'Adding LifeCycle ' + @NewLifeCycleName
	
	exec SpCreateLifeCycle @StampUser, @NewLifeCycleName, @NewLifeCycleName, 1, @PreQueueBehaviour, @PostQueueBehaviour, @CreatedDate, @StampUser, @IndigoClientId
	set @NewLifeCycleId = IDENT_CURRENT('TLifeCycle')
		
	
-- insert TLifeCycle2RefPlanType

	SET @FirstId = IDENT_CURRENT('TLifeCycle2RefPlanType')
	
	INSERT INTO TLifeCycle2RefPlanType(LifeCycleId, RefPlanTypeId, AdviceTypeId)
	SELECT @NewLifeCycleId, RefPlanTypeId, @NewAdviceTypeId	
	FROM TLifeCycle2RefPlanType
	WHERE LifeCycleId = @SourceLifeCycleId
	AND AdviceTypeId = @SourceAdviceTypeId

	SET @LastId = IDENT_CURRENT('TLifeCycle2RefPlanType')
	
	INSERT INTO TLifeCycle2RefPlanTypeAudit (LifeCycleId, RefPlanTypeId, AdviceTypeId, ConcurrencyId, LifeCycle2RefPlanTypeId, StampAction, StampDateTime, StampUser)
	SELECT LifeCycleId, RefPlanTypeId, AdviceTypeId, ConcurrencyId, LifeCycle2RefPlanTypeId, 'C', getdate(), @StampUser
	FROM TLifeCycle2RefPlanType WHERE LifeCycle2RefPlanTypeId BETWEEN (@FirstId+1) AND @LastId

			
-- loop thru transitions and add steps and transitions
	DECLARE cTransitions CURSOR
	READ_ONLY
	FOR 
		SELECT LifeCycleTransitionId, lct.LifeCycleStepId, ToLifeCycleStepId, OrderNumber
		FROM TLifeCycleTransition lct
		INNER JOIN TLifeCycleStep lcs ON lcs.LifeCycleStepId = lct.LifeCycleStepId
		WHERE lcs.LifeCycleId = @SourceLifeCycleId
	
	DECLARE @SourceTransitionId bigint, @SourceFromStepId bigint, @SourceFromStatusId bigint, @SourceToStepId bigint, @SourceToStatusId bigint, @OrderNumber int
	DECLARE @NewTransitionId bigint, @NewFromStepId bigint, @NewToStepId bigint, @NewFromStatusId bigint, @NewToStatusId bigint
	DECLARE @SourceFromStatusName varchar(255), @SourceToStatusName varchar(255)
	OPEN cTransitions	
			
	FETCH NEXT FROM cTransitions INTO @SourceTransitionId, @SourceFromStepId, @SourceToStepId, @OrderNumber
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			
		-- Insert new FROM step
			SELECT @SourceFromStatusId = StatusId FROM TLifeCycleStep WHERE LifeCycleStepId = @SourceFromStepId
			SELECT @SourceFromStatusName = Name FROM TStatus WHERE StatusId = @SourceFromStatusId
			SELECT @NewFromStatusId = StatusId FROM TStatus WHERE Name = @SourceFromStatusName AND IndigoClientId = @IndigoClientId
			
			if (select count(*) FROM TLifeCycleStep WHERE StatusId = @NewFromStatusId AND LifeCycleId = @NewLifeCycleId) = 0
				begin
					print '...adding FROM step for status ' + @SourceFromStatusName
					exec SpCreateLifeCycleStep @StampUser, @NewFromStatusId, @NewLifeCycleId
					SET @NewFromStepId = IDENT_CURRENT('TLifeCycleStep')
				end
			else
				SELECT @NewFromStepId = LifeCycleStepId FROM TLifeCycleStep WHERE StatusId = @NewFromStatusId AND LifeCycleId = @NewLifeCycleId


		-- insert new TO step
			SELECT @SourceToStatusId = StatusId FROM TLifeCycleStep WHERE LifeCycleStepId = @SourceToStepId
			SELECT @SourceToStatusName = Name FROM TStatus WHERE StatusId = @SourceToStatusId
			SELECT @NewToStatusId = StatusId FROM TStatus WHERE Name = @SourceToStatusName AND IndigoClientId = @IndigoClientId
			if (select count(*) FROM TLifeCycleStep WHERE StatusId = @NewToStatusId AND LifeCycleId = @NewLifeCycleId) = 0
				begin
					print '...adding TO step for status ' + @SourceToStatusName
					exec SpCreateLifeCycleStep @StampUser, @NewToStatusId, @NewLifeCycleId
					SET @NewToStepId = IDENT_CURRENT('TLifeCycleStep')
				end
			else
				 SELECT @NewToStepId = LifeCycleStepId FROM TLifeCycleStep WHERE StatusId = @NewToStatusId AND LifeCycleId = @NewLifeCycleId				

		if(@CloneStepTask=1)
		begin


			IF NOT EXISTS (SELECT 1 FROM crm..tactivitycategory2lifecycleStep WHERE LifeCycleStepId = @NewFromStepId)
			BEGIN
			 -- insert new Step Task
				insert into crm..tactivitycategory2lifecycleStep
					(LifeCycleStepId, ActivityCategoryId, ConcurrencyId)
				select @NewFromStepId, ActivityCategoryId, ConcurrencyId 
					from crm..tactivitycategory2lifecycleStep t1
				where t1.LifeCycleStepId = @SourceFromStepId 
	
		     	 -- Audit Step Task
				INSERT INTO crm..tactivitycategory2lifecycleStepAudit 
					(LifeCycleStepId, ActivityCategoryId, ConcurrencyId, ActivityCategory2LifeCycleStepId, StampAction, StampDateTime, StampUser)
				SELECT LifeCycleStepId, ActivityCategoryId, ConcurrencyId, ActivityCategory2LifeCycleStepId, 'C', getdate(), @StampUser
				FROM crm..tactivitycategory2lifecycleStep WHERE LifeCycleStepId = @NewFromStepId
			END

			IF NOT EXISTS (SELECT 1 FROM crm..tactivitycategory2lifecycleStep WHERE LifeCycleStepId = @NewToStepId)
			BEGIN
			 -- insert new Step Task
				insert into crm..tactivitycategory2lifecycleStep
					(LifeCycleStepId, ActivityCategoryId, ConcurrencyId)
				select @NewToStepId, ActivityCategoryId, ConcurrencyId 
					from crm..tactivitycategory2lifecycleStep t1
				where t1.LifeCycleStepId = @SourceToStepId 
	
		     	 -- Audit Step Task
				INSERT INTO crm..tactivitycategory2lifecycleStepAudit 
					(LifeCycleStepId, ActivityCategoryId, ConcurrencyId, ActivityCategory2LifeCycleStepId, StampAction, StampDateTime, StampUser)
				SELECT LifeCycleStepId, ActivityCategoryId, ConcurrencyId, ActivityCategory2LifeCycleStepId, 'C', getdate(), @StampUser
				FROM crm..tactivitycategory2lifecycleStep WHERE LifeCycleStepId = @NewToStepId
			END
		end
		
		if(@CloneStepActions=1)
		begin
		
		 -- insert new Step Property Actions

		 	IF NOT EXISTS (SELECT 1 FROM TRefPlanActionStatusRole WHERE LifeCycleStepId = @NewFromStepId)  
		 	BEGIN  
				insert into TRefPlanActionStatusRole(LifeCycleStepId, RefPlanActionId, RoleId, ConcurrencyId)
				select @NewFromStepId, RefPlanActionId, RoleId, ConcurrencyId
				from TRefPlanActionStatusRole tr
				where tr.LifeCycleStepId = @SourceFromStepId
			
		 		-- Audit Step Property Actions	
				INSERT INTO TRefPlanActionStatusRoleAudit 
					(LifeCycleStepId, RefPlanActionId, RoleId, RefPlanActionStatusRoleId,
					ConcurrencyId, StampAction, StampDateTime, StampUser)
				SELECT LifeCycleStepId, RefPlanActionId, RoleId, RefPlanActionStatusRoleId,
					ConcurrencyId, 'C', getdate(), @StampUser
				FROM TRefPlanActionStatusRole WHERE LifeCycleStepId = @NewFromStepId
			END

			IF NOT EXISTS (SELECT 1 FROM TRefPlanActionStatusRole WHERE LifeCycleStepId = @NewToStepId)  
		 	BEGIN  
				insert into TRefPlanActionStatusRole(LifeCycleStepId, RefPlanActionId, RoleId, ConcurrencyId)
				select @NewToStepId, RefPlanActionId, RoleId, ConcurrencyId
				from TRefPlanActionStatusRole tr
				where tr.LifeCycleStepId = @SourceToStepId
			
		 		-- Audit Step Property Actions	
				INSERT INTO TRefPlanActionStatusRoleAudit 
					(LifeCycleStepId, RefPlanActionId, RoleId, RefPlanActionStatusRoleId,
					ConcurrencyId, StampAction, StampDateTime, StampUser)
				SELECT LifeCycleStepId, RefPlanActionId, RoleId, RefPlanActionStatusRoleId,
					ConcurrencyId, 'C', getdate(), @StampUser
				FROM TRefPlanActionStatusRole WHERE LifeCycleStepId = @NewToStepId
			END
		end
		
		-- insert transition
			print '...adding transition from ' + @SourceFromStatusName + ' to ' + @SourceToStatusName
			INSERT INTO TLifeCycleTransition (LifeCycleStepId, ToLifeCycleStepId, OrderNumber, Type, HideStep, AddToCommissionsFg)
			SELECT @NewFromStepId, @NewToStepId, OrderNumber, Type, HideStep, AddToCommissionsFg
			FROM TLifeCycleTransition
			WHERE LifeCycleTransitionId = @SourceTransitionId

			SET @NewTransitionId = IDENT_CURRENT('TLifeCycleTransition')

			INSERT INTO TLifeCycleTransitionAudit (LifeCycleStepId, ToLifeCycleStepId, OrderNumber, Type, HideStep, AddToCommissionsFg, ConcurrencyId, LifeCycleTransitionId, StampAction, StampDateTime, StampUser)
			SELECT LifeCycleStepId, ToLifeCycleStepId, OrderNumber, Type, HideStep, AddToCommissionsFg, ConcurrencyId, LifeCycleTransitionId, 'C', getdate(), @StampUser
			FROM TLifeCycleTransition WHERE LifeCycleTransitionId = @NewTransitionId



		-- insert transitionRule
			print '...adding Transition Rules'

			SET @FirstId = IDENT_CURRENT('TTransitionRule')

			INSERT INTO TTransitionRule (RuleSpName, LifeCycleTransitionId, Alias)
			SELECT RuleSpName, @NewTransitionId, Alias
			FROM TTransitionRule
			WHERE LifeCycleTransitionId = @SourceTransitionId
			

		
			SET @LastId = IDENT_CURRENT('TTransitionRule')
			
			INSERT INTO TTransitionRuleAudit (RuleSPName, LifeCycleTransitionId, Alias, ConcurrencyId, TransitionRuleId, StampAction, StampDateTime, StampUser)
			SELECT RuleSPName, LifeCycleTransitionId, Alias, ConcurrencyId, TransitionRuleId, 'C', getdate(), @StampUser
			FROM TTransitionRule WHERE TransitionRuleId BETWEEN (@FirstId+1) AND @LastId					
			
		if(@TransRules=1)
		begin
			
		-- insert TLifeCycleTransitionToLifeCycleTransitionRule
			
			SET @FirstId = IDENT_CURRENT('TLifeCycleTransitionToLifeCycleTransitionRule')
			
			insert into TLifeCycleTransitionToLifeCycleTransitionRule (LifeCycleTransitionId, LifeCycleTransitionRuleId, ConcurrencyId)
			select @NewTransitionId, LifeCycleTransitionRuleId, ConcurrencyId  
			from TLifeCycleTransitionToLifeCycleTransitionRule LCTrans2Rule
			where LCTrans2Rule.LifeCycleTransitionId = @SourceTransitionId
			
			SET @LastId = IDENT_CURRENT('TLifeCycleTransitionToLifeCycleTransitionRule')
		
		-- Audit Trans Rules
			
			INSERT INTO TLifeCycleTransitionToLifeCycleTransitionRuleAudit 
				(LifeCycleTransitionId, LifeCycleTransitionRuleId, ConcurrencyId, 
				LifeCycleTransitionToLifeCycleTransitionRuleId,
				StampAction, StampDateTime, StampUser)
			SELECT LifeCycleTransitionId, LifeCycleTransitionRuleId, ConcurrencyId, 
				LifeCycleTransitionToLifeCycleTransitionRuleId, 'C', getdate(), @StampUser
			FROM TLifeCycleTransitionToLifeCycleTransitionRule 
			WHERE LifeCycleTransitionToLifeCycleTransitionRuleId BETWEEN (@FirstId+1) AND @LastId

		end

		if(@TransTasks=1)
		begin

			SET @FirstId = IDENT_CURRENT('crm..tactivitycategory2lifecycletransition')

		-- insert tactivitycategory2lifecycletransition -- Transition Task 
			print '...adding Transition Tasks'
			insert into crm..tactivitycategory2lifecycletransition
				(LifeCycleTransitionId, ActivityCategoryId, ConcurrencyId, CheckOutcome, CheckDueDate)
			select @NewTransitionId, ActivityCategoryId, ConcurrencyId, CheckOutcome, CheckDueDate 
				from crm..tactivitycategory2lifecycletransition t1
			where t1.LifeCycleTransitionId = @SourceTransitionId 
		
			SET @LastId = IDENT_CURRENT('crm..tactivitycategory2lifecycletransition')
		
		-- Audit Trans Tasks
	
			INSERT INTO crm..tactivitycategory2lifecycletransitionAudit 
				(LifeCycleTransitionId, ActivityCategoryId, ConcurrencyId, 
				ActivityCategory2LifeCycleTransitionId,
				StampAction, StampDateTime, StampUser, CheckOutcome, CheckDueDate)
			SELECT LifeCycleTransitionId, ActivityCategoryId, ConcurrencyId, 
				ActivityCategory2LifeCycleTransitionId, 'C', getdate(), @StampUser, CheckOutcome, CheckDueDate
			FROM crm..tactivitycategory2lifecycletransition 
			WHERE ActivityCategory2LifeCycleTransitionId BETWEEN (@FirstId+1) AND @LastId

		end

		-- insert TTransitionRole
			print '...adding Transition Roles'

			SET @FirstId = IDENT_CURRENT('TTransitionRole')

			INSERT INTO TTransitionRole (RoleId, LifeCycleTransitionId)
			SELECT DISTINCT tr.RoleId, @NewTransitionId
			FROM TTransitionRole tr
			WHERE tr.LifeCycleTransitionId = @SourceTransitionId

			SET @LastId = IDENT_CURRENT('TTransitionRole')

			INSERT INTO TTransitionRoleAudit (RoleId, LifeCycleTransitionId, ConcurrencyId,TransitionRoleId,StampAction,StampDateTime, StampUser)
			SELECT RoleId, LifeCycleTransitionId, ConcurrencyId,TransitionRoleId, 'C', getdate(), @StampUser
			FROM TTransitionRole WHERE TransitionRoleId BETWEEN (@FirstId+1) AND @LastId




		END
		FETCH NEXT FROM cTransitions INTO @SourceTransitionId, @SourceFromStepId, @SourceToStepId, @OrderNumber
	END

	CLOSE cTransitions
	DEALLOCATE cTransitions




GO


