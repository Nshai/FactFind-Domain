SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNIOCustomRetrieveTaskByFeeIdDTO]  
  @TenantId int,
  @FeeId bigint    
AS    
set transaction isolation level read uncommitted

 SELECT   
  A.TaskId,  
  H.OrganiserActivityId,  
  A.StartDate,  
  A.DueDate,
  A.Timezone,   
  AC.Name as TaskType,   
  A.Subject as TaskName,  
  'Task' + CASE     
   WHEN LEN(AR.RFCCode) > 0 THEN ' ('+   [dbo].[FnGetRecurrenceActivityType](AR.RFCCode) +')'    
   ELSE ''    
   END AS ActivityType,  
  (F.FirstName + ' ' + F.LastName) As AssignedToUserName,   
  G.Name as TaskStatus,   
  0 AS IsDocumentExist,
  1 AS IsBillable,
  R.Identifier AS RoleName
  FROM TTask A    
  LEFT JOIN Administration..Tuser C on C.UserId=A.AssignedUserId
  LEFT JOIN Administration..TRole R on A.AssignedToRoleId=R.RoleId
  LEFT JOIN TCRMContact D on D.CRMcontactId=C.CRMcontactId    
  LEFT JOIN Administration..Tuser E on E.UserId=A.AssignedToUserId    
  LEFT JOIN TCRMContact F on F.CRMcontactId=E.CRMcontactId    
  LEFT JOIN TRefTaskStatus G on G.RefTaskStatusId=A.RefTaskStatusId    
  INNER JOIN TOrganiserActivity H on A.TaskId=H.TaskId    
  LEFT JOIN TActivityRecurrence AR ON AR.OrganiserActivityId= H.OrganiserActivityId    
  LEFT JOIN TCRMContact J on J.CRMContactId=H.CRMContactId    
  LEFT JOIN TActivityCategory AC on AC.ActivityCategoryId=H.ActivityCategoryId    
  LEFT JOIN policymanagement.dbo.TFeeToTask FTT ON FTT.TaskId = A.TaskId  
 Where     
  FTT.FeeId =@FeeId  
  AND A.IndigoClientId=@TenantId    
  AND A.IndigoClientId=H.IndigoClientId   
  AND FTT.TenantId = @TenantId   
 Order By DueDate asc  
GO
