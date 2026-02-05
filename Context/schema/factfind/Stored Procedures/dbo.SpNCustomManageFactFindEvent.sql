SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomManageFactFindEvent]    
 @StampUser varchar (255),    
 @CRMContactId bigint,     
 @RefSystemEvent varchar(255),      
 @CompletedDate datetime,    
 @IsCreateNewTask bit=0    
AS    
    
DECLARE @RefSystemEventId bigint,@TaskId int,@PercentCompleted decimal,@DeclarationId bigint,@AssignedByUserId bigint
DECLARE @ActivityCategoryId bigint,@ActivityCategoryParentId bigint,@IndigoClientId int,@AdviserUserId bigint
    
    
SELECT @IndigoClientId=IndClientId FROM CRM..TCRMContact WHERE CRMContactId=@CRMContactId    
SELECT @AssignedByUserId=CONVERT(bigint,@StampUser)    
    
SELECT @RefSystemEventId = RefSystemEventId FROM CRM..TRefSystemEvent WHERE Identifier=@RefSystemEvent    
SELECT @PercentCompleted=100    
    
SELECT @ActivityCategoryId=MIN(t1.ActivityCategoryId)     
FROM CRM..TActivityCategory2RefSystemEvent t1    
JOIN CRM..TActivityCategory t2 ON t2.ActivityCategoryId = t1.ActivityCategoryId    
WHERE t1.RefSystemEventId=@RefSystemEventId    
AND t2.IndigoClientId = @IndigoClientId AND t2.GroupId IS NULL   
    
    
SELECT @ActivityCategoryParentId=ActivityCategoryParentId FROM CRM..TActivityCategory WHERE ActivityCategoryId=@ActivityCategoryId AND IndigoClientId=@IndigoClientId AND GroupId IS NULL   
    
SELECT @AdviserUserId=UserId FROM Administration..TUser A JOIN CRM..TCRMContact B ON A.CRMContactId=B.CurrentAdviserCRMId WHERE B.CRMContactId=@CRMContactId    
     
IF ISNULL(@ActivityCategoryId,0)>0    
    
BEGIN    
    
SET NOCOUNT OFF    
    
SET @TaskId=(SELECT TOP 1 A.TaskId  
FROM CRM..TTask A  
JOIN CRM..TOrganiserActivity B On A.TaskId=B.TaskId  
JOIN CRM..TActivityCategory2RefSystemEvent C ON B.ActivityCategoryId=C.ActivityCategoryId  
JOIN CRM..TRefSystemEvent D ON C.RefSystemEventId=D.RefSystemEventId  
WHERE D.RefSystemEventId=@RefSystemEventId
AND A.IndigoClientId=@IndigoClientId
AND A.CRMContactId=@CRMContactId  
AND B.CRMContactId=@CRMContactId  
ORDER BY TaskId DESC)  
    
IF (ISNULL(@TaskId,0)=0 OR @IsCreateNewTask=1)    
 BEGIN    
 SET NOCOUNT ON    
 DECLARE @Subject varchar(255),@RefTaskStatusId varchar(255)    
 SELECT @Subject=[Name] FROM CRM..TActivityCategory WHERE ActivityCategoryId=@ActivityCategoryId AND GroupId IS NULL   
    
 SELECT @RefTaskStatusId=RefTaskStatusId FROM CRM..TRefTaskStatus WHERE [Name]='Complete'    
    
 EXEC CRM..SpCreateTask @StampUser, @CompletedDate, @CompletedDate, @PercentCompleted, '', @AssignedByUserId, @AdviserUserId, @AdviserUserId, default, default, @Subject, default, '', 0, @CompletedDate, default, default, default, default, @CRMContactId, ''
, @RefTaskStatusId, default, default, @IndigoclientId, null  
    
 SELECT @TaskId=MAX(TaskId) FROM CRM..TTask WHERE CRMContactId=@CRMContactId AND AssignedToUserId=@AdviserUserId AND IndigoClientId=@IndigoClientId
    
 IF ISNULL(@TaskId,0)>0    
 BEGIN    
  EXEC CRM..SpCreateOrganiserActivity @StampUser, default, @ActivityCategoryParentId, @ActivityCategoryId, @TaskId, 1, default, default, default, NULL, default, @CRMContactId, @IndigoClientId    
      
 END    
 END    
ELSE    
 BEGIN    
 INSERT CRM..TTaskAudit(PercentComplete,DateCompleted,CRMContactId,ConcurrencyId,TaskId,AssignedToRoleId,IndigoClientId,Timezone,StampAction,StampDateTime,StampUser)  
 SELECT PercentComplete,DateCompleted,CRMContactId,ConcurrencyId,TaskId,AssignedToRoleId,@IndigoClientId,Timezone,'U',getdate(),@StampUser  
 FROM CRM..TTask  
 WHERE TaskId=@TaskId  
 AND CRMContactId=@CRMContactId  
  
  UPDATE CRM..TTask    
  SET PercentComplete=100,DateCompleted=@CompletedDate,ConcurrencyId=ConcurrencyId + 1  
  WHERE TaskId=@TaskId  
  AND CRMContactId=@CRMContactId  
   
    
 INSERT CRM..TOrganiserActivityAudit(ActivityCategoryParentId,ActivityCategoryId,TaskId,CompleteFG,PolicyId,FeeId,RetainerId,OpportunityId,EventListActivityId,CRMContactId,IndigoClientId,  
              ConcurrencyId,OrganiserActivityId,StampAction,StampDateTime,StampUser)  
 SELECT ActivityCategoryParentId,ActivityCategoryId,TaskId,CompleteFG,PolicyId,FeeId,RetainerId,OpportunityId,EventListActivityId,CRMContactId,IndigoClientId,  
               ConcurrencyId,OrganiserActivityId,'U',getdate(),@StampUser  
 FROM CRM..TOrganiserActivity  
 WHERE TaskId=@TaskId  
 AND CRMCOntactId=@CRMContactId   AND IndigoClientId=@IndigoClientId  
    
  UPDATE CRM..TOrganiserActivity  
  SET CompleteFg=1,ConcurrencyId=ConcurrencyId + 1  
  WHERE TaskId=@TaskId  
  AND CRMCOntactId=@CRMContactId  
  AND IndigoClientId=@IndigoClientId  
  
 END    
    
END    
    

GO
