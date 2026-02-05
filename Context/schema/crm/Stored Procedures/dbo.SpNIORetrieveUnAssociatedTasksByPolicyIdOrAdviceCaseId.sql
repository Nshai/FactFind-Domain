SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE PROCEDURE [dbo].[SpNIORetrieveUnAssociatedTasksByPolicyIdOrAdviceCaseId]  
  @TenantId int,
  @ClientId bigint,  
  @PolicyId bigint = -1,  
  @AdviceCaseId bigint = -1,  
  -- filters with length max since we are not restricting users  
  @TaskTypeFilter varchar(Max) = '',  
  @TaskNameFilter varchar(Max) = '',  
  @AssignedToUserNameFilter varchar(Max) = ''   
AS    
 -- Filters with wild characters  
 Declare @WildTaskTypeFilter varchar(Max) = null  
 Declare @WildTaskNameFilter varchar(Max) = null  
 Declare @WildAssignedToUserNameFilter varchar(Max) = null   
 Set @WildTaskTypeFilter = '%' + @TaskTypeFilter + '%'  
 Set @WildTaskNameFilter = '%' + @TaskNameFilter + '%'  
 Set @WildAssignedToUserNameFilter = '%' + @AssignedToUserNameFilter + '%'  
  
 SELECT   
   A.TaskId,  
   H.OrganiserActivityId,  
   A.StartDate,  
   A.DueDate,
   A.Timezone,  
   AC.Name as TaskType,   
   A.[Subject] as TaskName,  
   'Task' + CASE     
    WHEN LEN(AR.RFCCode) > 0 THEN ' ('+   [dbo].[FnGetRecurrenceActivityType](AR.RFCCode) +')'    
    ELSE ''    
    END AS ActivityType,  
   (F.FirstName + ' ' + F.LastName) As AssignedToUserName,   
   G.Name as TaskStatus,   
   0 AS IsDocumentExist,  
   H.AdviceCaseId,  
   H.PolicyId,
   CASE WHEN FT.TaskId IS NOT NULL THEN 1 ELSE 0 END AS IsBillable  
   FROM TTask A    
   LEFT JOIN Administration..Tuser C on C.UserId=A.AssignedUserId    
   LEFT JOIN TCRMContact D on D.CRMcontactId=C.CRMcontactId    
   LEFT JOIN Administration..Tuser E on E.UserId=A.AssignedToUserId    
   LEFT JOIN TCRMContact F on F.CRMcontactId=E.CRMcontactId    
   LEFT JOIN TRefTaskStatus G on G.RefTaskStatusId=A.RefTaskStatusId    
   INNER JOIN TOrganiserActivity H on A.TaskId=H.TaskId    
   LEFT JOIN TActivityRecurrence AR ON AR.OrganiserActivityId= H.OrganiserActivityId    
   LEFT JOIN TCRMContact J on J.CRMContactId=H.CRMContactId    
   LEFT JOIN TActivityCategory AC on AC.ActivityCategoryId=H.ActivityCategoryId 
   LEFT JOIN PolicyManagement..TFeeToTask FT ON A.TaskId = FT.TaskId AND FT.TenantId =  @TenantId    
  WHERE       
   A.IndigoClientId=@TenantId    
   AND A.CRMContactId = @ClientId  
   And (H.PolicyId != @PolicyId Or H.PolicyId Is Null Or @PolicyId = -1)  
   And (H.AdviceCaseId != @AdviceCaseId Or H.AdviceCaseId Is Null Or @AdviceCaseId = -1)  
   --filters  
   And (AC.Name Like @WildTaskTypeFilter Or @TaskTypeFilter = '')  
   And (A.[Subject] Like @WildTaskNameFilter Or @TaskNameFilter = '')  
   And ((F.FirstName + ' ' + F.LastName) Like @WildAssignedToUserNameFilter Or @AssignedToUserNameFilter = '')  
  
  
GO
