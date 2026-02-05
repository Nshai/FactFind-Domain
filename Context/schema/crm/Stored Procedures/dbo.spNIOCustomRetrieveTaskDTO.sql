SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNIOCustomRetrieveTaskDTO] 
	@UserId bigint, 
	@TenantId int,
	@PartyId bigint=0, 
	@Range tinyint=0, -- Historic = 0, Active = 1, All=2
	@GetAppointments tinyint =0
AS
SET Transaction Isolation Level read uncommitted  
  
/* Create Temporary Table as we need to deal with three quite distinct entities  
- Tasks, Appointments, Emails  
I did this with a join and it was quite long winded and slow*/  

declare @CompleteFG bit

if (@Range = 0)
  set @CompleteFG = 1
else 
  set @CompleteFG = 0
  
If Object_Id('tempdb..#TaskTable') Is Not Null      
 Drop Table #TaskTable  
  
Create Table #TaskTable(      
       TaskId int,SequentialRef varchar(50),DueDate DateTime,[Subject] varchar(1000), IndigoClientId int,
       StartDate DateTime,AssignedUserId bigint, AssignedToUserId bigint,RefTaskStatusId bigint,CRMContactId bigint, JointCRMContactId bigint,
       OrganiserActivityId bigint,PolicyId bigint,FeeId bigint,RetainerId bigint,OpportunityId bigint,AdviceCaseId bigint,  
       CompleteFG bit,EventListActivityId bigint,ActivityCategoryId bigint,RefPriorityId bigint)   
         
if @PartyId = 0   
begin
	-----------------------------------------------------------------
	-- Retrieve tasks for the user. Two selects here, one for AssignedUser
	-- and one for AssignedToUser, UNION is quicker than using an OR statement.
	-----------------------------------------------------------------
	Insert into #TaskTable(
		TaskId, SequentialRef, DueDate ,[Subject],IndigoClientId, StartDate,AssignedUserId,AssignedToUserId,RefTaskStatusId,  
		CRMContactId,JointCRMContactId,OrganiserActivityId,PolicyId,FeeId,RetainerId,OpportunityId,AdviceCaseId,  
		CompleteFG,EventListActivityId,ActivityCategoryId,RefPriorityId)      
	SELECT
		A.TaskId,
		A.SequentialRef,
		A.DueDate,
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
	FROM 
		CRM..TTask A
		JOIN CRM..TOrganiserActivity H on A.TaskId = H.TaskId
	WHERE
		A.IndigoClientId=@TenantId   
		AND H.IndigoClientId = A.IndigoClientId  
		AND A.AssignedUserId = @UserId
		AND H.CompleteFG = @CompleteFG

	UNION
	SELECT
		A.TaskId,
		A.SequentialRef,
		A.DueDate,
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
	FROM
		CRM..TTask A
		JOIN CRM..TOrganiserActivity H on A.TaskId = H.TaskId
	WHERE 
		A.IndigoClientId=@TenantId
		AND H.IndigoClientId = A.IndigoClientId
		AND A.AssignedToUserId = @UserId
		AND H.CompleteFG = @CompleteFG
end
else if @PartyId > 0  
begin
	Insert into #TaskTable(    
		TaskId, SequentialRef, DueDate ,[Subject],IndigoClientId, StartDate,AssignedUserId,  
		AssignedToUserId,RefTaskStatusId,CRMContactId,JointCRMContactId,OrganiserActivityId,PolicyId,FeeId,RetainerId,OpportunityId,AdviceCaseId,  
		CompleteFG,EventListActivityId,ActivityCategoryId,RefPriorityId)      
	SELECT   
		A.TaskId,   
		A.SequentialRef,   
		A.DueDate,   
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
	FROM 
		CRM..TTask A  
		JOIN CRM..TOrganiserActivity H on A.TaskId=H.TaskId  
	Where 
		A.IndigoClientId=@TenantId  
		and H.IndigoClientId = A.IndigoClientId  
		and (H.CRMContactId=@PartyId OR H.JointCRMContactId=@PartyId)
		and H.CompleteFG = @CompleteFG
end  
  
If Object_Id('tempdb..#spNIOCustomRetrieveTaskDTOTable') Is Not Null      
 Drop Table #spNIOCustomRetrieveTaskDTOTable  
      
Create Table #spNIOCustomRetrieveTaskDTOTable(      
 OrganiserActivityId bigint,TaskId int,SequentialRef varchar(50), PriorityName varchar(255),DueDate DateTime,
 [Subject] varchar(1000), AssignedUserId bigint, AssignedUser varchar(255), AssignedToUserId bigint,  
 AssignedToUser varchar(255), TaskStatus varchar(255), CaseRef varchar(50), ClientName varchar(255),  
 ClientPartyId bigint, 
 JointClientName varchar(255), JointClientPartyId bigint,
CompleteFG bit, RoleId bigint, RoleName varchar(255), PolicyId bigint,  
 FeeId bigint, RetainerId bigint, OpportunityId bigint, AdviceCaseId bigint, ActivityType varchar(255), IndigoClientId int,
EventListName varchar(255), StartDate DateTime, TaskType varchar(50), PlanTypeName varchar(255), IsDocumentExist bit,  
PlanTypeId bigint,IsBillable bit)      
  
-- lets get the data for the tasks  
Insert into #spNIOCustomRetrieveTaskDTOTable(      
 OrganiserActivityId, TaskId, SequentialRef, PriorityName , DueDate ,[Subject] ,AssignedUserId , AssignedUser,CompleteFG,RoleId,RoleName ,PolicyId ,FeeId,  
 RetainerId,OpportunityId,AdviceCaseId, ActivityType, IndigoClientId, EventListName, StartDate, TaskType, PlanTypeName, IsDocumentExist,  
 PlanTypeId,IsBillable)  
      
SELECT   
A.OrganiserActivityId,  
A.TaskId,   
A.SequentialRef,  
ISNULL(Pr.PriorityName, '') as PriorityName,  
A.DueDate,   
A.Subject,   
C.UserId As AssignedUserId,  
(D.FirstName + ' ' + D.LastName) As AssignedUser,  
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
NULL As PlanTypeId,
0 AS Billable  
FROM #TaskTable A  
LEFT JOIN TRefPriority Pr on Pr.RefPriorityId=A.RefPriorityId  
LEFT JOIN Administration..Tuser C on C.UserId=A.AssignedUserId  
LEFT JOIN CRM..TCRMContact D on D.CRMcontactId=C.CRMcontactId  
LEFT JOIN CRM..TActivityCategory AC on AC.ActivityCategoryId=A.ActivityCategoryId  
Where A.IndigoClientId=@TenantId   
AND A.IndigoClientId=A.IndigoClientId  

-- Update the Table with AssignedToUser Values.
Update TDTO
Set AssignedToUserId = E.UserId,  
    AssignedToUser = (F.FirstName + ' ' + F.LastName)  
FROM #spNIOCustomRetrieveTaskDTOTable TDTO
Inner join #TaskTable A on TDTO.TaskId = A.TaskId
LEFT JOIN Administration..Tuser E on E.UserId=A.AssignedToUserId  
LEFT JOIN CRM..TCRMContact F on F.CRMcontactId=E.CRMcontactId  

-- Update Advice Case & Task Status Details
Update #spNIOCustomRetrieveTaskDTOTable
Set TaskStatus = G.Name,  
    CaseRef = I.CaseRef  
FROM #spNIOCustomRetrieveTaskDTOTable TDTO
Inner join #TaskTable A on TDTO.TaskId = A.TaskId
LEFT JOIN CRM..TRefTaskStatus G on G.RefTaskStatusId=A.RefTaskStatusId  
LEFT JOIN CRM..TAdviceCase I on I.AdviceCaseId=A.AdviceCaseId

-- Update Client & Join Client Information
Update #spNIOCustomRetrieveTaskDTOTable
SET ClientName = 
(
CASE      
 WHEN J.CRMContactType = 1 THEN J.FirstName + ' ' + J.LastName      
 WHEN J.CRMContactType = 2 THEN J.CorporateName      
 WHEN J.CRMContactType = 3 THEN J.CorporateName     
END ),
ClientPartyId = J.CRMContactId,
JointClientName = 
(
CASE      
 WHEN JJ.CRMContactType = 1 THEN JJ.FirstName + ' ' + JJ.LastName      
 WHEN JJ.CRMContactType = 2 THEN JJ.CorporateName      
 WHEN JJ.CRMContactType = 3 THEN JJ.CorporateName     
END ),
JointClientPartyId = JJ.CRMContactId
FROM #spNIOCustomRetrieveTaskDTOTable TDTO
Inner join #TaskTable A on TDTO.TaskId = A.TaskId
LEFT JOIN CRM..TCRMContact J on J.CRMContactId=A.CRMContactId
LEFT JOIN CRM..TCRMContact JJ on JJ.CRMContactId=A.JointCRMContactId
  
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
  
--update the IsBillable flag if task is linked with any fees
UPDATE #spNIOCustomRetrieveTaskDTOTable
SET IsBillable = 1
FROM #spNIOCustomRetrieveTaskDTOTable A
INNER JOIN PolicyManagement..TFeetoTask FT ON A.TaskId = FT.TaskId AND  FT.TenantId = @TenantId


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
 AssignedToUser,TaskStatus,CaseRef ,ClientName ,ClientPartyId ,CompleteFG,RoleId,RoleName ,PolicyId ,FeeId,  
 RetainerId,OpportunityId,AdviceCaseId, ActivityType, IndigoClientId, StartDate, TaskType, PlanTypeName, IsDocumentExist, PlanTypeId)  
  
SELECT Distinct A.OrganiserActivityId,NULL, 'N/A',NULL,K.SentDate,K.Subject,M.UserId,(L.FirstName + ' ' + L.LastName),
	M.UserId, (L.FirstName + ' ' + L.LastName),  
CASE      
 WHEN (EO.EntityOrganiserActivityId > 0) THEN 'Complete'  
 ELSE 'Incomplete'  
END AS TaskStatus,
NULL,NULL,NULL,A.CompleteFG,NULL,NULL,NULL,NULL,  
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
AND (M.UserId = @UserId AND @PartyId=0)

union

SELECT Distinct A.OrganiserActivityId,NULL, 'N/A',NULL,K.SentDate,K.Subject,M.UserId,(L.FirstName + ' ' + L.LastName),
	M.UserId, (L.FirstName + ' ' + L.LastName),  
CASE      
 WHEN (EO.EntityOrganiserActivityId > 0) THEN 'Complete'  
 ELSE 'Incomplete'  
END AS TaskStatus,
NULL,NULL,NULL,A.CompleteFG,NULL,NULL,NULL,NULL,  
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
--Records for Party.  
AND (@PartyId > 0 AND EO.EntityId = @PartyId)

-- this was better than including the Complete bit field in the clauses above since the bit cannot be indexed  
  
If (@Range=0) -- this is histroic stuff so complete  
 delete from #spNIOCustomRetrieveTaskDTOTable where CompleteFG=0  
  
If (@Range=1) -- this is currently active so no complete stuff  
 delete from #spNIOCustomRetrieveTaskDTOTable where CompleteFG=1  
  
if(@GetAppointments =1)    
Begin    
    
 -- lets get data for the Appointments      
 Insert into #spNIOCustomRetrieveTaskDTOTable(          
  OrganiserActivityId,TaskId,SequentialRef, PriorityName , DueDate ,[Subject] ,AssignedUserId , AssignedUser ,AssignedToUserId,      
  AssignedToUser,TaskStatus,CaseRef ,ClientName ,ClientPartyId , JointClientName ,JointClientPartyId ,CompleteFG,RoleId,RoleName ,PolicyId ,FeeId,      
  RetainerId,OpportunityId,AdviceCaseId, ActivityType, IndigoClientId, StartDate, TaskType, PlanTypeName, IsDocumentExist, PlanTypeId)      
     
     
 SELECT distinct     
 A.OrganiserActivityId,C.AppointmentId, NULL,'N/A',C.EndTime,C.Subject,D.CRMContactId ,(D.FirstName + ' ' + D.LastName),D.CRMContactId,    
 (D.FirstName + ' ' + D.LastName),   
 Case   
  When A.CompleteFG = 0 Then 'Incomplete'   
  Else 'Complete'   
 End AS TaskStatus,  
 NULL,NULL,A.CRMContactId,NULL,A.JointCRMContactId,NULL,NULL,NULL,NULL,NULL,    
 NULL,NULL,NULL,'Diary', A.IndigoClientId,C.StartTime,B.Name,NULL,NULL,NULL    
 FROM   CRM.dbo.TOrganiserActivity A    
     left outer join CRM.dbo.TActivityCategory B    
    on A.ActivityCategoryId = B.ActivityCategoryId    
     inner join CRM.dbo.TAppointment C    
    on A.AppointmentId = C.AppointmentId    
     left outer join CRM.dbo.TCRMContact D    
    on C.OrganizerCRMContactId = D.CRMContactId    
       
 WHERE  (A.CRMContactId = @PartyId OR A.JointCRMContactId = @PartyId)   
     and A.IndigoClientId = @TenantId    
     and A.CompleteFG = Case When @Range =1 Then 0 Else 1 End     
    
End      
  
--### IO-15426
--lets get data for selected partyid as diary appointment attendees
 Insert into #spNIOCustomRetrieveTaskDTOTable(          
  OrganiserActivityId,TaskId,SequentialRef, PriorityName , DueDate ,[Subject] ,AssignedUserId , AssignedUser ,AssignedToUserId,      
  AssignedToUser,TaskStatus,CaseRef ,ClientName ,ClientPartyId , JointClientName ,JointClientPartyId ,CompleteFG,RoleId,RoleName ,PolicyId ,FeeId,      
  RetainerId,OpportunityId,AdviceCaseId, ActivityType, IndigoClientId, StartDate, TaskType, PlanTypeName, IsDocumentExist, PlanTypeId)      
 SELECT distinct     
 A.OrganiserActivityId,C.AppointmentId, NULL,'N/A',C.EndTime,C.Subject,D.CRMContactId ,(D.FirstName + ' ' + D.LastName),D.CRMContactId,    
 (D.FirstName + ' ' + D.LastName),   
 Case   
  When A.CompleteFG = 0 Then 'Incomplete'   
  Else 'Complete'   
 End AS TaskStatus,  
 NULL,NULL,A.CRMContactId,NULL,A.JointCRMContactId,NULL,NULL,NULL,NULL,NULL,    
 NULL,NULL,NULL,'Diary', A.IndigoClientId,C.StartTime,B.Name,NULL,NULL,NULL    
 FROM   CRM.dbo.TOrganiserActivity A    
     left outer join CRM.dbo.TActivityCategory B on A.ActivityCategoryId = B.ActivityCategoryId    
     inner join CRM.dbo.TAppointment C on A.AppointmentId = C.AppointmentId    
	 inner join CRM..TAttendees att on att.AppointmentId = C.AppointmentId
     left outer join CRM.dbo.TCRMContact D on C.OrganizerCRMContactId = D.CRMContactId    
       
 WHERE  (att.CRMContactId = @PartyId)    
     and A.IndigoClientId = @TenantId    
     and A.CompleteFG = Case When @Range =1 Then 0 Else 1 End    

union 

 SELECT distinct     
 A.OrganiserActivityId,C.AppointmentId, NULL,'N/A',C.EndTime,C.Subject,D.CRMContactId ,(D.FirstName + ' ' + D.LastName),D.CRMContactId,    
 (D.FirstName + ' ' + D.LastName),   
 Case   
  When A.CompleteFG = 0 Then 'Incomplete'   
  Else 'Complete'   
 End AS TaskStatus,  
 NULL,NULL,A.CRMContactId,NULL,A.JointCRMContactId,NULL,NULL,NULL,NULL,NULL,    
 NULL,NULL,NULL,'Diary', A.IndigoClientId,C.StartTime,B.Name,NULL,NULL,NULL    
 FROM   CRM.dbo.TOrganiserActivity A    
     left outer join CRM.dbo.TActivityCategory B on A.ActivityCategoryId = B.ActivityCategoryId    
     inner join CRM.dbo.TAppointment C on A.AppointmentId = C.AppointmentId    
	 inner join CRM..TAttendees att on att.AppointmentId = C.AppointmentId
     left outer join CRM.dbo.TCRMContact D on C.OrganizerCRMContactId = D.CRMContactId    
       
 WHERE  (A.JointCRMContactId = @PartyId)    
     and A.IndigoClientId = @TenantId    
     and A.CompleteFG = Case When @Range =1 Then 0 Else 1 End
--### Eof IO-15426

  
UPDATE  #spNIOCustomRetrieveTaskDTOTable  
  SET ActivityType = ActivityType+' ('+ [dbo].[FnGetRecurrenceActivityType](AR.RFCCode) +')'  
FROM #spNIOCustomRetrieveTaskDTOTable A  
INNER JOIN TActivityRecurrence AR ON AR.OrganiserActivityId= A.OrganiserActivityId  
  
-- lets return the data set  
Select distinct A.OrganiserActivityId,A.TaskId,A.SequentialRef, A.PriorityName, A.DueDate,A.[Subject],A.AssignedUserId, A.AssignedUser,A.AssignedToUserId,    
 A.AssignedToUser,A.TaskStatus,A.CaseRef,A.ClientName,A.ClientPartyId,A.JointClientName,A.JointClientPartyId,A.CompleteFG,A.RoleId,A.RoleName,A.PolicyId,A.FeeId,    
 A.RetainerId,A.OpportunityId,A.AdviceCaseId, A.ActivityType,A.IndigoClientId,A.EventListName,A.StartDate,A.TaskType,B.PlanTypeName,A.IsDocumentExist
 ,B.PlanTypeId,A.IsBillable    
 FROM #spNIOCustomRetrieveTaskDTOTable  A  
LEFT OUTER JOIN #tmpTaskPlanTable B on A.Taskid = B.TaskId  
Order By DueDate asc  
  
GO
