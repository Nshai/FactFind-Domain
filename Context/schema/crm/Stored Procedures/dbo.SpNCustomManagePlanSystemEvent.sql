SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomManagePlanSystemEvent]        
 @StampUser bigint,        
 @CRMContactId bigint,         
 @PolicyBusinessId bigint,        
 @RefSystemEvent varchar(255),          
 @EventDate datetime,        
 @IsCreateNewTask bit=0        
AS        
        
DECLARE @RefSystemEventId bigint,@TaskId int,@PercentCompleted decimal,@DeclarationId bigint,@AssignedByUserId bigint,@IsComplete bit
DECLARE @ActivityCategoryId bigint,@ActivityCategoryParentId bigint,@IndigoClientId int,@AdviserUserId bigint
DECLARE @DueDate datetime        
        
        
SELECT @IndigoClientId=IndClientId FROM CRM..TCRMContact WHERE CRMContactId=@CRMContactId        
SELECT @AssignedByUserId=CONVERT(bigint,@StampUser)        
        
SELECT @RefSystemEventId = RefSystemEventId FROM CRM..TRefSystemEvent WHERE Identifier=@RefSystemEvent        
        
IF ISNULL(@RefSystemEventId,0)!=0        
        
BEGIN        
        
SET @ActivityCategoryId=(SELECT MIN(A.ActivityCategoryId) FROM CRM..TActivityCategory2RefSystemEvent A      
       JOIN TActivityCategory B ON A.ActivityCategoryId=B.ActivityCategoryId      
       WHERE A.RefSystemEventId=@RefSystemEventId        
       AND B.IndigoClientId=@IndigoClientId)      
      
SET @ActivityCategoryParentId=(SELECT ActivityCategoryParentId FROM CRM..TActivityCategory WHERE ActivityCategoryId=@ActivityCategoryId AND IndigoClientId=@IndigoClientId)      
        
SELECT @AdviserUserId=UserId FROM Administration..TUser A JOIN CRM..TCRMContact B ON A.CRMContactId=B.CurrentAdviserCRMId WHERE B.CRMContactId=@CRMContactId        
         
IF ISNULL(@ActivityCategoryId,0)>0        
        
BEGIN        
 SET DATEFORMAT DMY        
 SELECT @DueDate=cast(@EventDate as datetime)        
        
 SET NOCOUNT OFF        
         
 SELECT @TaskId=MAX(A.TaskId)        
 FROM CRM..TTask A        
 JOIN CRM..TOrganiserActivity B ON A.TaskId=B.TaskId        
 JOIN CRM..TActivityCategory2RefSystemEvent C ON B.ActivityCategoryId=C.ActivityCategoryId        
 WHERE C.RefSystemEventId=@RefSystemEventId        
 AND B.ActivityCategoryId=@ActivityCategoryId        
 AND B.ActivityCategoryParentId=@ActivityCategoryParentId        
 AND A.CRMContactId=@CRMContactId        
 AND B.CRMContactId=@CRMContactId        
 AND B.IndigoClientId=@IndigoClientId        
 AND B.PolicyId=@PolicyBusinessId
 AND A.IndigoClientId=@IndigoClientId
         
 IF ISNULL(@TaskId,0)>0        
 BEGIN        
  SELECT @IsComplete=CompleteFG FROM CRM..TOrganiserActivity WHERE TaskId=@TaskId AND CRMContactId=@CRMContactId AND PolicyId=@PolicyBusinessId        
 END        
         
 IF (ISNULL(@TaskId,0)=0 OR @IsCreateNewTask=1 OR ISNULL(@IsComplete,0)=1)        
   BEGIN        
   SET NOCOUNT ON        
   DECLARE @Subject varchar(255),@RefTaskStatusId varchar(255)        
   SELECT @Subject=[Name] FROM CRM..TActivityCategory WHERE ActivityCategoryId=@ActivityCategoryId     
          
   SELECT @RefTaskStatusId=RefTaskStatusId FROM CRM..TRefTaskStatus WHERE [Name]='Incomplete'        
   SELECT @PercentCompleted=0     

	INSERT CRM..TTask (StartDate,DueDate,PercentComplete,AssignedUserId,
								PerformedUserId,AssignedToUserId,[Subject],
								PrivateFg,CRMContactId,RefTaskStatusId,
								IndigoClientId,ConcurrencyId)
	SELECT @DueDate,@DueDate,@PercentCompleted,@AssignedByUserId,
				@AdviserUserId,@AdviserUserId,@Subject,0,@CRMContactId,
				@RefTaskStatusId,@IndigoClientId,1

	SELECT @TaskId=SCOPE_IDENTITY()

	--Audit
	INSERT CRM..TTaskAudit(StartDate,DueDate,Timezone,PercentComplete,Notes,AssignedUserId,
									PerformedUserId,AssignedToUserId,AssignedToRoleId,ReminderId,
									Subject,RefPriorityId,Other,PrivateFg,DateCompleted,EstimatedTimeHrs,
									EstimatedTimeMins,ActualTimeHrs,ActualTimeMins,CRMContactId,URL,
									RefTaskStatusId,ActivityOutcomeId,SequentialRef,IndigoClientId,ReturnToRoleId,
									ConcurrencyId,TaskId,StampAction,StampDateTime,StampUser)

	SELECT StartDate,DueDate,Timezone,PercentComplete,Notes,AssignedUserId,
									PerformedUserId,AssignedToUserId,AssignedToRoleId,ReminderId,
									Subject,RefPriorityId,Other,PrivateFg,DateCompleted,EstimatedTimeHrs,
									EstimatedTimeMins,ActualTimeHrs,ActualTimeMins,CRMContactId,URL,
									RefTaskStatusId,ActivityOutcomeId,SequentialRef,IndigoClientId,ReturnToRoleId,
									ConcurrencyId,TaskId,'C',GETDATE(),@StampUser
	FROM CRM..TTask
	WHERE TaskId=@TaskId AND IndigoClientId=@IndigoClientId
	
          
   IF ISNULL(@TaskId,0)>0        
   BEGIN        
		EXEC CRM..SpCreateOrganiserActivity @StampUser, default, @ActivityCategoryParentId, @ActivityCategoryId, @TaskId, 0, @PolicyBusinessId, default, default, NULL, default, @CRMContactId, @IndigoClientId          
   END        
   END        
	ELSE        
          
   BEGIN        
   --Audit        
   INSERT CRM..TTaskAudit(StartDate,DueDate,Timezone,PercentComplete,Notes,AssignedUserId,PerformedUserId,AssignedToUserId,        
      ReminderId,Subject,RefPriorityId,Other,PrivateFg,DateCompleted,EstimatedTimeHrs,EstimatedTimeMins,        
      ActualTimeHrs,ActualTimeMins,CRMContactId,URL,RefTaskStatusId,ActivityOutcomeId,IndigoClientId,ConcurrencyId,      
      TaskId,AssignedToRoleId,StampAction,StampDateTime,StampUser)        
          
   SELECT StartDate,DueDate,Timezone,PercentComplete,Notes,AssignedUserId,PerformedUserId,AssignedToUserId,        
          ReminderId,Subject,RefPriorityId,Other,PrivateFg,DateCompleted,EstimatedTimeHrs,EstimatedTimeMins,        
          ActualTimeHrs,ActualTimeMins,CRMContactId,URL,RefTaskStatusId,ActivityOutcomeId,IndigoClientId,ConcurrencyId,        
          TaskId,AssignedToRoleId,'U',getdate(),@StampUser        
   FROM CRM..TTask WHERE TaskId=@TaskId AND IndigoClientId=@IndigoClientId
          
   UPDATE CRM..TTAsk        
   SET DueDate=@DueDate        
   WHERE TaskId=@TaskId AND IndigoClientId=@IndigoClientId
   END        
END        
END 
GO
