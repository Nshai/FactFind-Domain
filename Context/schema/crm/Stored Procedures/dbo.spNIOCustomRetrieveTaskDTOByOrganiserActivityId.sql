SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNIOCustomRetrieveTaskDTOByOrganiserActivityId] @UserId bigint, @TenantId int, @PartyId bigint, @OrganiserActivityId bigint
AS   
  
SET Transaction Isolation Level read uncommitted  
  
/* Create Temporary Table as we need to deal with three quite distinct entities  
- Tasks, Appointments, Emails  
I did this with a join and it was quite long winded and slow*/  
  
If Object_Id('tempdb..#TaskTable') Is Not Null      
 Drop Table #TaskTable  
  
Create Table #TaskTable(      
       TaskId int,SequentialRef varchar(50),DueDate DateTime, Timezone varchar(100), [Subject] varchar(1000), IndigoClientId int,
       StartDate DateTime,AssignedUserId bigint, AssignedToUserId bigint,RefTaskStatusId bigint,CRMContactId bigint,JointCRMContactId bigint,  
       OrganiserActivityId bigint,PolicyId bigint,FeeId bigint,RetainerId bigint,OpportunityId bigint,AdviceCaseId bigint,  
       CompleteFG bit,EventListActivityId bigint,ActivityCategoryId bigint,RefPriorityId bigint)   
         

  
 Insert into #TaskTable(    
     TaskId, SequentialRef, DueDate, Timezone, [Subject],IndigoClientId, StartDate,AssignedUserId,  
        AssignedToUserId,RefTaskStatusId,CRMContactId,JointCRMContactId,OrganiserActivityId,PolicyId,FeeId,RetainerId,OpportunityId,AdviceCaseId,  
     CompleteFG,EventListActivityId,ActivityCategoryId,RefPriorityId)      
 SELECT   
 A.TaskId,   
 A.SequentialRef,   
 A.DueDate,
 A.Timezone,   
 A.Subject,   
 A.IndigoClientId,   
 A.StartDate,  
 A.AssignedUserId,  
 A.AssignedToUserId,  
 A.RefTaskStatusId,   
 H.CRMContactId,  
 H.JointCRMContactId,  
 H.OrganiserActivityId,  
 H.PolicyId,  
 H.FeeId,   
    H.RetainerId,  
    H.OpportunityId,  
    H.AdviceCaseId,  
    H.CompleteFG,  
    H.EventListActivityId,  
    H.ActivityCategoryId,  
    A.RefPriorityId  
 FROM CRM..TTask A  
 INNER JOIN CRM..TOrganiserActivity H on A.TaskId=H.TaskId  
 Where A.IndigoClientId=@TenantId  
 and H.IndigoClientId = A.IndigoClientId  
 and (ISNULL(H.CRMContactId,0)=0 OR H.CRMContactId=@PartyId)  
 AND H.OrganiserActivityId=@OrganiserActivityId
  

  
If Object_Id('tempdb..#spNIOCustomRetrieveTaskDTOTable') Is Not Null      
 Drop Table #spNIOCustomRetrieveTaskDTOTable  
      
Create Table #spNIOCustomRetrieveTaskDTOTable(      
 OrganiserActivityId bigint,TaskId int,SequentialRef varchar(50), PriorityName varchar(255),DueDate DateTime, Timezone varchar(100),
 [Subject] varchar(1000), AssignedUserId bigint, AssignedUser varchar(255), AssignedToUserId bigint,  
 AssignedToUser varchar(255), TaskStatus varchar(255), CaseRef varchar(50), ClientName varchar(255),  
 ClientPartyId bigint,
JointClientName varchar(255), JointClientPartyId bigint,
 CompleteFG bit, RoleId bigint, RoleName varchar(255), PolicyId bigint,  
 FeeId bigint, RetainerId bigint, OpportunityId bigint, AdviceCaseId bigint, ActivityType varchar(255), IndigoClientId int,
EventListName varchar(255), StartDate DateTime, TaskType varchar(50), PlanTypeName varchar(255), IsDocumentExist bit,  
PlanTypeId bigint)      
  
-- lets get the data for the tasks  
Insert into #spNIOCustomRetrieveTaskDTOTable(      
 OrganiserActivityId, TaskId, SequentialRef, PriorityName , DueDate, Timezone, [Subject] ,AssignedUserId , AssignedUser ,AssignedToUserId,  
 AssignedToUser,TaskStatus,CaseRef  ,ClientName ,ClientPartyId, JointClientName ,JointClientPartyId ,CompleteFG,RoleId,RoleName ,PolicyId ,FeeId,  
 RetainerId,OpportunityId,AdviceCaseId, ActivityType, IndigoClientId, EventListName, StartDate, TaskType, PlanTypeName, IsDocumentExist,  
 PlanTypeId)  
      
SELECT   
A.OrganiserActivityId,  
A.TaskId,   
A.SequentialRef,  
'' as PriorityName,   
A.DueDate,
A.Timezone,
A.Subject,   
C.UserId As AssignedUserId,  
(D.FirstName + ' ' + D.LastName) As AssignedUser,  
E.UserId As AssignedToUserId ,  
(F.FirstName + ' ' + F.LastName) As AssignedToUser,  
G.Name as TaskStatus, I.CaseRef,  
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

A.CompleteFG ,  
NULL as RoleId,  
NULL as RoleName,  
A.PolicyId,   
A.FeeId,   
A.RetainerId,  
A.OpportunityId,  
A.AdviceCaseId,  
'Task',  
A.IndigoClientId,  
'' as EventListName,  
A.StartDate,  
AC.Name as TaskType,   
NULL AS PlanTypeName,  
0 as IsDocumentExist,  
--CASE  
--  WHEN (DV.DocVersionId > 0) AND (TD.EntityType=5) THEN 1 -- 5 is for task entity  
--  ELSE 0  
--END AS IsDocumentExist,  
NULL As PlanTypeId  
FROM #TaskTable A  
--LEFT JOIN CRM..TRefPriority B on B.RefPriorityId=A.RefPriorityId  
LEFT JOIN Administration..Tuser C on C.UserId=A.AssignedUserId  
LEFT JOIN CRM..TCRMContact D on D.CRMcontactId=C.CRMcontactId  
LEFT JOIN Administration..Tuser E on E.UserId=A.AssignedToUserId  
LEFT JOIN CRM..TCRMContact F on F.CRMcontactId=E.CRMcontactId  
LEFT JOIN CRM..TRefTaskStatus G on G.RefTaskStatusId=A.RefTaskStatusId  
LEFT JOIN CRM..TAdviceCase I on I.AdviceCaseId=A.AdviceCaseId  
LEFT JOIN CRM..TCRMContact J on J.CRMContactId=A.CRMContactId  
LEFT JOIN CRM..TCRMContact JJ on JJ.CRMContactId=A.JointCRMContactId  
--LEFT JOIN CRM..TEventListActivity N on N.EventListActivityId=A.EventListActivityId  
--LEFT JOIN CRM..TEventList O on O.EventListId=N.EventListId  
LEFT JOIN CRM..TActivityCategory AC on AC.ActivityCategoryId=A.ActivityCategoryId  
--LEFT JOIN DocumentManagement..TDocument TD ON TD.EntityId=A.TaskId AND TD.IndigoClientId =@TenantId  
--LEFT JOIN DocumentManagement..TDocVersion DV ON DV.DocumentId=TD.DocumentId AND DV.IndigoClientId =@TenantId  
Where A.IndigoClientId=@TenantId   
AND A.IndigoClientId=A.IndigoClientId  
  
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
  
/* Create temporary table to retrieve plan related information as with the last retrieval we are facing perfomrance   
issue  
*/  
If Object_Id('tempdb..#tmpTaskPlanTable') Is Not Null      
 Drop Table #tmpTaskPlanTable  
  
Create Table #tmpTaskPlanTable(TaskId int,PlanTypeName varchar(255),PlanTypeId bigint)
  
Insert into #tmpTaskPlanTable(TaskId, PlanTypeName,PlanTypeId)  
  
Select A.TaskId,   
       PT.PlanTypeName + ' (' + PC.CorporateName + ')' AS PlanTypeName,  
    PB.PolicyBusinessId As PlanTypeId  
FROM #spNIOCustomRetrieveTaskDTOTable A  
INNER JOIN PolicyManagement..TPolicyBusiness PB on PB.PolicyBusinessId=A.PolicyId  
LEFT JOIN PolicyManagement..TPolicyDetail PD on PD.PolicyDetailId=PB.PolicyDetailId  
LEFT JOIN PolicyManagement..TPlanDescription PS on PS.PlanDescriptionId=PD.PlanDescriptionId  
LEFT JOIN PolicyManagement..TRefPlanType2ProdSubType RP on RP.RefPlanType2ProdSubTypeId=PS.RefPlanType2ProdSubTypeId  
LEFT JOIN PolicyManagement..TRefPlantype PT on PT.RefPlanTypeId=RP.RefPlanTypeId  
LEFT JOIN PolicyManagement..TRefProdProvider PP ON PP.RefProdProviderId=PS.RefProdProviderId  
LEFT JOIN CRM..TCRMContact PC ON PC.CRMContactId=PP.CRMContactId  
Where A.IndigoClientId=@TenantId   
AND PB.IndigoClientId=A.IndigoClientId  
  
-- lets get data for the emails  
Insert into #spNIOCustomRetrieveTaskDTOTable(      
 OrganiserActivityId,TaskId,SequentialRef, PriorityName , DueDate ,[Subject] ,AssignedUserId , AssignedUser ,AssignedToUserId,  
 AssignedToUser,TaskStatus,CaseRef ,ClientName ,ClientPartyId,JointClientName ,JointClientPartyId ,CompleteFG,RoleId,RoleName ,PolicyId ,FeeId,  
 RetainerId,OpportunityId,AdviceCaseId, ActivityType, IndigoClientId, StartDate, TaskType, PlanTypeName, IsDocumentExist, PlanTypeId)  
  
SELECT Distinct A.OrganiserActivityId,NULL, 'N/A',NULL,K.SentDate,K.Subject,M.UserId,(L.FirstName + ' ' + L.LastName),M.UserId,  
(L.FirstName + ' ' + L.LastName),  
  
CASE      
 WHEN (EO.EntityOrganiserActivityId > 0) THEN 'Complete'  
 ELSE 'Incomplete'  
END AS TaskStatus,    
  
--NULL,  
NULL,NULL,NULL,NULL,NULL,A.CompleteFG,NULL,NULL,NULL,NULL,  
NULL,NULL,NULL,'Email', A.IndigoClientId, NULL, 'Email', NULL,   
CASE  
 WHEN (TA.AttachmentId > 0) THEN 1  
 ELSE 0  
END AS IsDocumentExist  
, NULL  
FROM TOrganiserActivity A   
JOIN CRM..TEmail K on K.OrganiserActivityId=A.OrganiserActivityId  
LEFT JOIN CRM..TEntityOrganiserActivity EO on A.OrganiserActivityId = EO.OrganiserActivityId  
LEFT JOIN CRM..TCRMContact L on L.CRMContactId=K.OwnerPartyId  
LEFT JOIN ADMINISTRATION..TUser M on M.CRMContactId=L.CRMContactId  
LEFT JOIN CRM..TAttachment TA ON TA.EmailId = K.EmailId  
--Check for Tenant  
Where M.IndigoClientId=@TenantId  
--Records for User if Party Id is 0  
AND ((M.UserId = @UserId AND @PartyId=0) OR (@PartyId>0))  
--Records for Party.  
AND EO.EntityId = @PartyId  

  
UPDATE  #spNIOCustomRetrieveTaskDTOTable  
  SET ActivityType = ActivityType+' ('+ [dbo].[FnGetRecurrenceActivityType](AR.RFCCode) +')'  
FROM #spNIOCustomRetrieveTaskDTOTable A  
INNER JOIN TActivityRecurrence AR ON AR.OrganiserActivityId= A.OrganiserActivityId  
  
-- lets return the data set  
Select TOP 1 A.OrganiserActivityId,A.TaskId,A.SequentialRef, A.PriorityName, A.DueDate, A.Timezone, A.[Subject],A.AssignedUserId, A.AssignedUser,A.AssignedToUserId,    
 A.AssignedToUser,A.TaskStatus,A.CaseRef,A.ClientName,A.ClientPartyId,A.JointClientName,A.JointClientPartyId,A.CompleteFG,A.RoleId,A.RoleName,A.PolicyId,A.FeeId,    
 A.RetainerId,A.OpportunityId,A.AdviceCaseId, A.ActivityType,A.IndigoClientId,A.EventListName,A.StartDate,A.TaskType,B.PlanTypeName,A.IsDocumentExist,B.PlanTypeId    
 FROM #spNIOCustomRetrieveTaskDTOTable  A  
LEFT OUTER JOIN #tmpTaskPlanTable B on A.Taskid = B.TaskId  
Order By DueDate asc  
  