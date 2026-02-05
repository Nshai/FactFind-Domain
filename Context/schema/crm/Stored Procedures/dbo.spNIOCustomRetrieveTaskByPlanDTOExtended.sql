SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNIOCustomRetrieveTaskByPlanDTOExtended]    
 @TenantId int,
 @PolicyId int    
AS    
    
/* Create Temporary Table as we need to deal with three quite distinct entities    
- Tasks, Appointments, Emails    
I did this with a join and it was quite long winded and slow*/    
    
If Object_Id('tempdb..#spNIOCustomRetrieveTaskDTOTable') Is Not Null        
 Drop Table #spNIOCustomRetrieveTaskDTOTable    
        
Create Table #spNIOCustomRetrieveTaskDTOTable(        
 OrganiserActivityId int,TaskId int,SequentialRef varchar(50), PriorityName varchar(255),DueDate DateTime, Timezone varchar(100),
 [Subject] varchar(1000), AssignedUserId int, AssignedUser varchar(255), AssignedToUserId int,    
 AssignedToUser varchar(255), TaskStatus varchar(255), CaseRef varchar(50), ClientName varchar(255),    
 ClientPartyId int, 
JointClientName varchar(255), JointClientPartyId int,
CompleteFG bit, RoleId int, RoleName varchar(255), PolicyId int,    
 FeeId int, RetainerId int, OpportunityId int, AdviceCaseId int, ActivityType varchar(255), IndigoClientId int,
EventListName varchar(255), StartDate DateTime, TaskType varchar(50), PlanTypeName varchar(255), IsDocumentExist bit,    
PlanTypeId int, IsBillable bit)        
    
-- lets get the data for the tasks    
Insert into #spNIOCustomRetrieveTaskDTOTable(        
 OrganiserActivityId, TaskId, SequentialRef, PriorityName , DueDate, Timezone, [Subject] ,AssignedUserId , AssignedUser ,AssignedToUserId,    
 AssignedToUser,TaskStatus,CaseRef  ,ClientName ,ClientPartyId , JointClientName ,JointClientPartyId, CompleteFG,RoleId,RoleName ,PolicyId ,FeeId,    
 RetainerId,OpportunityId,AdviceCaseId, ActivityType, IndigoClientId, EventListName, StartDate, TaskType, PlanTypeName, IsDocumentExist,    
 PlanTypeId,IsBillable)    
        
SELECT   
H.OrganiserActivityId,  
A.TaskId,  
A.SequentialRef,   
ISNULL(B.PriorityName, '') as PriorityName,  
A.DueDate,
A.Timezone, 
A.Subject,   
C.UserId As AssignedUserId,  
(D.FirstName + ' ' + D.LastName) As AssignedUser,   
E.UserId As AssignedToUserId ,
(F.FirstName + ' ' + F.LastName) As AssignedToUser,   
G.Name as TaskStatus,   
I.CaseRef,    
CASE        
 WHEN J.CRMContactType = 1 THEN J.FirstName + ' ' + J.LastName        
 WHEN J.CRMContactType = 2 THEN J.CorporateName        
 WHEN J.CRMContactType = 3 THEN J.CorporateName       
 END AS ClientName,     
J.CRMContactId as ClientPartyId,  

CASE        
 WHEN JJ.CRMContactType = 1 THEN JJ.FirstName + ' ' + JJ.LastName        
 WHEN JJ.CRMContactType = 2 THEN JJ.CorporateName        
 WHEN JJ.CRMContactType = 3 THEN JJ.CorporateName       
 END AS JointClientName,     
JJ.CRMContactId as JointClientPartyId,  

H.CompleteFG ,   
r.RoleId as RoleId,   
R.Identifier as RoleName,  
H.PolicyId,   
H.FeeId,     
H.RetainerId,   
H.OpportunityId,   
H.AdviceCaseId,     
'Task' + CASE     
    WHEN LEN(AR.RFCCode) > 0 THEN ' ('+   [dbo].[FnGetRecurrenceActivityType](AR.RFCCode) +')'    
    ELSE ''    
 END,    
A.IndigoClientId,  
'' As EventListName,  
A.StartDate,  
AC.Name as TaskType,    
NULL AS  PlanTypeName,  
0 AS IsDocumentExist,    
NULL  As PlanTypeId,
0 AS IsBillable    
FROM TTask A    
LEFT JOIN TRefPriority B on B.RefPriorityId=A.RefPriorityId    
LEFT JOIN Administration..Tuser C on C.UserId=A.AssignedUserId    
LEFT JOIN TCRMContact D on D.CRMcontactId=C.CRMcontactId    
LEFT JOIN Administration..Tuser E on E.UserId=A.AssignedToUserId    
LEFT JOIN TCRMContact F on F.CRMcontactId=E.CRMcontactId    
LEFT JOIN TRefTaskStatus G on G.RefTaskStatusId=A.RefTaskStatusId    
INNER JOIN TOrganiserActivity H on A.TaskId=H.TaskId    
LEFT JOIN TActivityRecurrence AR ON AR.OrganiserActivityId= H.OrganiserActivityId    
LEFT JOIN TAdviceCase I on I.AdviceCaseId=H.AdviceCaseId    
LEFT JOIN TCRMContact J on J.CRMContactId=H.CRMContactId    
LEFT JOIN TCRMContact JJ on JJ.CRMContactId=H.JointCRMContactId    
LEFT JOIN TActivityCategory AC on AC.ActivityCategoryId=H.ActivityCategoryId    
--LEFT JOIN TEventListActivity N on N.EventListActivityId=H.EventListActivityId    
--LEFT JOIN TEventList O on O.EventListId=N.EventListId    
--LEFT JOIN DocumentManagement..TDocument TD ON TD.EntityId=A.TaskId  And TD.IndigoClientId=@TenantId    
--LEFT JOIN DocumentManagement..TDocVersion DV ON DV.DocumentId=TD.DocumentId    
LEFT JOIN Administration..TRole R on R.RoleId=A.AssignedToRoleId   
Where     
H.PolicyId=@PolicyId    
And A.IndigoClientId=@TenantId    
AND A.IndigoClientId=H.IndigoClientId    
  
--Update the IsDocument Flag if Task has any associated documents.  
UPDATE #spNIOCustomRetrieveTaskDTOTable  
 SET IsDocumentExist = 1  
 FROM (  
     SELECT A.TaskId  
  FROM #spNIOCustomRetrieveTaskDTOTable A  
  LEFT JOIN DocumentManagement..TDocument TD ON TD.EntityId=A.TaskId AND TD.EntityType=5  
  where A.IndigoClientId = @TenantId  
  and TD.IndigoClientId = @TenantId  
  GROUP BY A.TaskId  
  Having COUNT(TD.EntityId) > 0 ) Doc   
INNER JOIN #spNIOCustomRetrieveTaskDTOTable B ON Doc.TaskId= B.TaskId  

--update the IsBillable flas if task is linked with any fees
UPDATE #spNIOCustomRetrieveTaskDTOTable
SET IsBillable = 1
FROM #spNIOCustomRetrieveTaskDTOTable A
INNER JOIN PolicyManagement..TFeetoTask FT ON A.TaskId = FT.TaskId AND A.IndigoClientId = FT.TenantId


    
-- lets return the data set    
Select OrganiserActivityId,TaskId,SequentialRef, PriorityName, DueDate, Timezone, [Subject],AssignedUserId, AssignedUser,AssignedToUserId,    
 AssignedToUser,TaskStatus,CaseRef,ClientName,ClientPartyId,JointClientName,JointClientPartyId,CompleteFG,RoleId,RoleName,PolicyId,FeeId,    
 RetainerId,OpportunityId,AdviceCaseId, ActivityType,IndigoClientId,EventListName,StartDate,TaskType,PlanTypeName
 ,IsDocumentExist,PlanTypeId,IsBillable, NULL AS DateCompleted, '' AS ActivityOutcomeName, '' AS PerformedUserName,'' AS ProviderName, '' AS SolicitorName, '' AS PlanTypeProdSubTypeName
 , NULL AS UpdatedByUserId, '' AS AdviceCaseName, NULL As CreatedDate
 FROM #spNIOCustomRetrieveTaskDTOTable    
Order By DueDate asc    

GO
