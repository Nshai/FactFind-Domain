SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomCopyLifeCycles]  
@FromIndigoClientId bigint,  
@ToIndigoClientId bigint  
  
as  
  
begin  
  
SET NOCOUNT ON  
  
DECLARE @StampUser varchar(50)  
DECLARE @FirstId bigint, @LastId bigint  
set @StampUser = '0'  
  
-- archive all advice types  
INSERT INTO TAdviceTypeAudit (Description, IntelligentOfficeAdviceType, ArchiveFg, IndigoClientId, ConcurrencyId, AdviceTypeId, StampAction, StampDateTime, StampUser)  
SELECT Description, IntelligentOfficeAdviceType, ArchiveFg, IndigoClientId, ConcurrencyId, AdviceTypeId, 'U', getdate(), @StampUser  
FROM TAdviceType WHERE IndigoClientId = @ToIndigoClientId AND ArchiveFg = 0  
  
UPDATE TAdviceType SET ArchiveFg = 1 WHERE IndigoClientId = @ToIndigoClientId AND ArchiveFg = 0  
  
-- archive all lifecycles  
INSERT INTO TLifeCycleAudit (Name, Descriptor, Status, PreQueueBehaviour, PostQueueBehaviour, CreatedDate, CreatedUser, IndigoClientId, ConcurrencyId, LifeCycleId, StampAction, StampDateTime, StampUser)  
SELECT Name, Descriptor, Status, PreQueueBehaviour, PostQueueBehaviour, CreatedDate, CreatedUser, IndigoClientId, ConcurrencyId, LifeCycleId, 'U', getdate(), @StampUser  
FROM TLifeCycle WHERE IndigoClientId = @ToIndigoClientId AND Status = 1  
  
UPDATE TLifeCycle SET Status = 0 WHERE IndigoClientId = @ToIndigoClientId  
  
-- insert missing records into TStatus  
 print 'Checking Plan Statuses...'  
 set @FirstId = IDENT_CURRENT('TStatus')  
  
 INSERT INTO TStatus (Name, OrigoStatusId, IntelligentOfficeStatusType, PreComplianceCheck, PostComplianceCheck, SystemSubmitFg, IndigoClientId, IsPipelineStatus)
 SELECT Name, OrigoStatusId, IntelligentOfficeStatusType, PreComplianceCheck, PostComplianceCheck, SystemSubmitFg, @ToIndigoClientId, IsPipelineStatus
 FROM TStatus t1   
 WHERE NOT EXISTS (SELECT * FROM TStatus t2 WHERE t2.Name = t1.Name AND t2.IndigoClientId = @ToIndigoClientId)  
 AND IndigoClientId = @FromIndigoClientId  
  
 set @LastId = IDENT_CURRENT('TStatus')  
  
 INSERT INTO TStatusAudit (Name, OrigoStatusId, IntelligentOfficeStatusType, PreComplianceCheck, PostComplianceCheck, SystemSubmitFg, IndigoClientId, ConcurrencyId, IsPipelineStatus, StatusId, StampAction, StampDateTime, StampUser)
 SELECT Name, OrigoStatusId, IntelligentOfficeStatusType, PreComplianceCheck, PostComplianceCheck, SystemSubmitFg, IndigoClientId, ConcurrencyId, IsPipelineStatus, StatusId, 'C', getdate(), @StampUser
 FROM TStatus WHERE StatusId BETWEEN (@FirstId+1) AND @LastId  
  
  
--insert missing records into TRole  
 print 'Checking Roles...'  
 declare @GroupingId bigint  
 set @GroupingId = (select GroupingId FROM Administration..TGrouping WHERE IndigoClientId = @ToIndigoClientId AND Identifier = 'Organisation')  
  
 set @FirstId = IDENT_CURRENT('Administration..TRole')  
  
 INSERT INTO Administration..TRole (Identifier, GroupingId, SuperUser, IndigoClientId, LicensedUserCount)  
 SELECT Identifier, @GroupingId, SuperUser, @ToIndigoClientId, 0    
 FROM Administration..TRole t1  
 WHERE NOT EXISTS (SELECT * FROM Administration..TRole t2 WHERE T2.Identifier = t1.Identifier AND T2.IndigoClientId = @ToIndigoClientId)  
 AND t1.IndigoClientId = @FromIndigoClientId  
  
 set @LastId = IDENT_CURRENT('Administration..TRole')  
  
 INSERT INTO Administration..TRoleAudit (Identifier, GroupingId, SuperUser, IndigoClientId, LicensedUserCount, ConcurrencyId, RoleId, HasGroupDataAccess, StampAction, StampDateTime, StampUser)  
 SELECT Identifier, GroupingId, SuperUser, IndigoClientId, LicensedUserCount, ConcurrencyId, RoleId, HasGroupDataAccess, 'C', getdate(), @StampUser  
 FROM Administration..TRole WHERE RoleId BETWEEN (@FirstId+1) AND @LastID  
  
-- create cursor to loop thru lifecycles  
  
 DECLARE cLifecycles CURSOR  
 READ_ONLY  
 FOR   
  SELECT lc2rpt.LifeCycleId, lc2rpt.AdviceTypeId from TLifeCycle2RefPlanType lc2rpt  
  inner join TLifeCycle lc on lc.LifeCycleId = lc2rpt.LifeCycleId  
  inner join TAdviceType adv on adv.AdviceTypeId = lc2rpt.AdviceTypeId  
  where lc.IndigoClientId = @FromIndigoClientId  
  and adv.ArchiveFg = 0  
  and lc.status = 1  
  group by lc2rpt.LifeCycleId, lc2rpt.AdviceTypeId  
  
 DECLARE @SourceLifeCycleId bigint, @SourceAdviceTypeId bigint  
 OPEN cLifecycles  
   
 FETCH NEXT FROM cLifecycles INTO @SourceLifeCycleId, @SourceAdviceTypeId  
 WHILE (@@fetch_status <> -1)  
 BEGIN  
  IF (@@fetch_status <> -2)  
  BEGIN  
  
      -- insert advice Types  
   DECLARE @AdviceTypeDescription varchar(255), @IntelligentOfficeAdviceType varchar(255), @NewAdviceTypeId bigint  
   
   SELECT @AdviceTypeDescription = Description, @IntelligentOfficeAdviceType = IntelligentOfficeAdviceType  
   FROM TAdviceType WHERE AdviceTypeId = @SourceAdviceTypeId  
   
   print 'Adding Advice Type ' + @AdviceTypeDescription  
   exec SpCreateAdviceType @StampUser, @AdviceTypeDescription, @IntelligentOfficeAdviceType, 0, @ToIndigoClientId  
   set @NewAdviceTypeId = IDENT_CURRENT('TAdviceType')  
   
   
      -- insert TLifeCycle  
   DECLARE @LifeCycleName varchar(255), @LifeCycleDescriptor varchar(255), @PreQueueBehaviour varchar(50), @PostQueueBehaviour varchar(50), @NewLifeCycleId bigint, @CreatedDate datetime  
   
   SELECT @LifeCycleName = Name, @LifeCycleDescriptor = Descriptor, @PreQueueBehaviour = PreQueueBehaviour, @PostQueueBehaviour = PostQueueBehaviour  
   FROM TLifeCycle  
   WHERE LifeCycleId = @SourceLifeCycleId  
   
   set @CreatedDate = getdate()  
  
   print 'Adding LifeCycle ' + @LifeCycleName  
  
   exec SpCreateLifeCycle @StampUser, @LifeCycleName, @LifeCycleDescriptor, 1, @PreQueueBehaviour, @PostQueueBehaviour, @CreatedDate, @StampUser, @ToIndigoClientId  
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
     SELECT @NewFromStatusId = StatusId FROM TStatus WHERE Name = @SourceFromStatusName AND IndigoClientId = @ToIndigoClientId  
       
     if (select count(*) FROM TLifeCycleStep WHERE StatusId = @NewFromStatusId AND LifeCycleId = @NewLifeCycleId) = 0  
      begin  
       print '...adding FROM step for status ' + @SourceFromStatusName  
       exec SpCreateLifeCycleStep @StampUser, @NewFromStatusId, @NewLifeCycleId  
       SET @NewFromStepId = IDENT_CURRENT('TLifeCycleStep')  
      end  
     else  
      SELECT @NewFromStepId = LifeCycleStepId FROM TLifeCycleStep WHERE StatusId = @NewFromStatusId AND LifeCycleId = @NewLifeCycleId  
  
	-- ### Insert new FROM step into TRefPlanActionStatusRole		
	IF NOT EXISTS (SELECT 1 FROM TRefPlanActionStatusRole WHERE LifeCycleStepId = @NewFromStepId)
	BEGIN
		INSERT INTO TRefPlanActionStatusRole (RoleId, LifeCycleStepId, RefPlanActionId)    
		SELECT r2.RoleId, @NewFromStepId, tr.RefPlanActionId    
		FROM TRefPlanActionStatusRole tr    
			INNER JOIN Administration..TRole r1 ON tr.RoleId = r1.RoleId    
			INNER JOIN Administration..TRole r2 ON r1.Identifier = r2.Identifier    
		WHERE r2.IndigoClientId = @ToIndigoClientId    
			AND tr.LifeCycleStepId = @SourceFromStepId   
			
		--Insert TRefPlanActionStatusRoleAudit	
		INSERT INTO TRefPlanActionStatusRoleAudit (LifeCycleStepId,RefPlanActionId,RoleId,ConcurrencyId,RefPlanActionStatusRoleId,StampAction,StampDateTime,StampUser)  
		SELECT tr.LifeCycleStepId, tr.RefPlanActionId, r2.RoleId, tr.ConcurrencyId, tr.RefPlanActionStatusRoleId, 'C', GETDATE(), @StampUser
		FROM TRefPlanActionStatusRole tr    
			INNER JOIN Administration..TRole r1 ON tr.RoleId = r1.RoleId    
			INNER JOIN Administration..TRole r2 ON r1.Identifier = r2.Identifier    
		WHERE r2.IndigoClientId = @ToIndigoClientId    
			AND tr.LifeCycleStepId = @SourceFromStepId   
	END
	-- ###    			
  
    -- insert new TO step  
     SELECT @SourceToStatusId = StatusId FROM TLifeCycleStep WHERE LifeCycleStepId = @SourceToStepId  
     SELECT @SourceToStatusName = Name FROM TStatus WHERE StatusId = @SourceToStatusId  
     SELECT @NewToStatusId = StatusId FROM TStatus WHERE Name = @SourceToStatusName AND IndigoClientId = @ToIndigoClientId  
     if (select count(*) FROM TLifeCycleStep WHERE StatusId = @NewToStatusId AND LifeCycleId = @NewLifeCycleId) = 0  
      begin  
       print '...adding TO step for status ' + @SourceToStatusName  
       exec SpCreateLifeCycleStep @StampUser, @NewToStatusId, @NewLifeCycleId  
       SET @NewToStepId = IDENT_CURRENT('TLifeCycleStep')  
      end  
     else  
       SELECT @NewToStepId = LifeCycleStepId FROM TLifeCycleStep WHERE StatusId = @NewToStatusId AND LifeCycleId = @NewLifeCycleId      
  
	-- ### Insert new TO step into TRefPlanActionStatusRole
	IF NOT EXISTS (SELECT 1 FROM TRefPlanActionStatusRole WHERE LifeCycleStepId = @NewToStepId)
	BEGIN
		INSERT INTO TRefPlanActionStatusRole (RoleId, LifeCycleStepId, RefPlanActionId)    
		SELECT r2.RoleId, @NewToStepId, tr.RefPlanActionId    
		FROM TRefPlanActionStatusRole tr    
			INNER JOIN Administration..TRole r1 ON tr.RoleId = r1.RoleId    
			INNER JOIN Administration..TRole r2 ON r1.Identifier = r2.Identifier    
		WHERE r2.IndigoClientId = @ToIndigoClientId    
			AND tr.LifeCycleStepId = @SourceToStepId   
			
		--Insert TRefPlanActionStatusRoleAudit	
		INSERT INTO TRefPlanActionStatusRoleAudit (LifeCycleStepId,RefPlanActionId,RoleId,ConcurrencyId,RefPlanActionStatusRoleId,StampAction,StampDateTime,StampUser)  
		SELECT @NewFromStepId, tr.RefPlanActionId, r2.RoleId, tr.ConcurrencyId, tr.RefPlanActionStatusRoleId, 'C', GETDATE(), @StampUser
		FROM TRefPlanActionStatusRole tr    
			INNER JOIN Administration..TRole r1 ON tr.RoleId = r1.RoleId    
			INNER JOIN Administration..TRole r2 ON r1.Identifier = r2.Identifier    
		WHERE r2.IndigoClientId = @ToIndigoClientId    
			AND tr.LifeCycleStepId = @SourceToStepId  
	END 			
	--- ###
  
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
  
  
  
    -- insert TTransitionRole  
     print '...adding Transition Roles'  
  
     SET @FirstId = IDENT_CURRENT('TTransitionRole')  
  
     INSERT INTO TTransitionRole (RoleId, LifeCycleTransitionId)  
     SELECT r2.RoleId, @NewTransitionId  
     FROM TTransitionRole tr  
     INNER JOIN Administration..TRole r1 ON tr.RoleId = r1.RoleId  
     INNER JOIN Administration..TRole r2 ON r1.Identifier = r2.Identifier  
     WHERE r2.IndigoClientId = @ToIndigoClientId  
     AND tr.LifeCycleTransitionId = @SourceTransitionId  
  
     SET @LastId = IDENT_CURRENT('TTransitionRole')  
  
     INSERT INTO TTransitionRoleAudit (RoleId, LifeCycleTransitionId, ConcurrencyId,TransitionRoleId,StampAction,StampDateTime, StampUser)  
     SELECT RoleId, LifeCycleTransitionId, ConcurrencyId,TransitionRoleId, 'C', getdate(), @StampUser  
     FROM TTransitionRole WHERE TransitionRoleId BETWEEN (@FirstId+1) AND @LastId  
  
  
  
  
    END  
    FETCH NEXT FROM cTransitions INTO @SourceTransitionId, @SourceFromStepId, @SourceToStepId, @OrderNumber  
   END  
  
   CLOSE cTransitions  
   DEALLOCATE cTransitions  
  
  END  
  FETCH NEXT FROM cLifecycles INTO @SourceLifeCycleId, @SourceAdviceTypeId  
END  
  
CLOSE cLifecycles  
DEALLOCATE cLifecycles  
  
end  
GO
