SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spNIOCustomRetrieveTaskDTOByBusinessEntityId] 
(
@PartyId bigint=0, 
@OpportunityId bigInt=0, 
@ServicecaseId bigInt=0,
@UserId bigint, 
@TenantId int
)
AS     
    
SET Transaction Isolation Level read uncommitted    
 
Declare @sqlTask Varchar(8000)    
    
If Object_Id('tempdb..#TaskTable') Is Not Null        
 Drop Table #TaskTable    
    
Create Table #TaskTable(        
       TaskId int,SequentialRef varchar(50),DueDate DateTime,[Subject] varchar(1000), IndigoClientId int,
       StartDate DateTime,AssignedUserId bigint, AssignedToUserId bigint,RefTaskStatusId bigint,CRMContactId bigint, JointCRMContactId bigint,
       OrganiserActivityId bigint,PolicyId bigint,FeeId bigint,RetainerId bigint,OpportunityId bigint,AdviceCaseId bigint,    
       CompleteFG bit,EventListActivityId bigint,ActivityCategoryId bigint,RefPriorityId bigint)              
                              
 SET @sqlTask = 'SELECT A.TaskId, A.SequentialRef, A.DueDate, A.[Subject], A.IndigoClientId, A.StartDate, A.AssignedUserId, A.AssignedToUserId,    
             A.RefTaskStatusId, H.CRMContactId, H.JointCRMContactId, H.OrganiserActivityId, H.PolicyId, H.FeeId, H.RetainerId, H.OpportunityId,    
             H.AdviceCaseId, H.CompleteFG, H.EventListActivityId, H.ActivityCategoryId, A.RefPriorityId    
FROM CRM..TTask A WITH(NOLOCK)    
INNER JOIN CRM..TOrganiserActivity H WITH(NOLOCK) on A.TaskId = H.TaskId AND H.IndigoClientId = A.IndigoClientId   
WHERE A.IndigoClientId = '+ Convert(Varchar(25),@TenantId) +' AND (H.CRMContactId = ' +  Convert(Varchar(25),@PartyId) + ' OR H.JointCRMContactId = ' +  Convert(Varchar(25),@PartyId) + ')' 

--Conditionally add where clause for opportunity or service case
If @OpportunityId > 0 
      SET @sqlTask = @sqlTask + ' AND H.OpportunityId = '+ Convert(Varchar(25),@OpportunityId)
If @ServicecaseId > 0 
      SET @sqlTask = @sqlTask + ' AND H.AdviceCaseId = '+ Convert(Varchar(25),@ServicecaseId)


Insert into #TaskTable(TaskId, SequentialRef, DueDate ,[Subject],IndigoClientId, StartDate,AssignedUserId,    
                  AssignedToUserId,RefTaskStatusId,CRMContactId, JointCRMContactId, OrganiserActivityId,PolicyId,FeeId,RetainerId,OpportunityId,AdviceCaseId,    
                  CompleteFG,EventListActivityId,ActivityCategoryId,RefPriorityId)   
Exec(@sqlTask) 
    
    
If Object_Id('tempdb..#spNIOCustomRetrieveTaskDTOTable') Is Not Null        
 Drop Table #spNIOCustomRetrieveTaskDTOTable    
        
Create Table #spNIOCustomRetrieveTaskDTOTable(        
                  OrganiserActivityId bigint,TaskId int,SequentialRef varchar(50), PriorityName varchar(255),DueDate DateTime,

                  [Subject] varchar(1000), AssignedUserId bigint, AssignedUser varchar(255), AssignedToUserId bigint,    
                  AssignedToUser varchar(255), TaskStatus varchar(255), CaseRef varchar(50), ClientName varchar(255),    
                  ClientPartyId bigint, JointClientName varchar(255), JointClientPartyId bigint, CompleteFG bit, RoleId bigint, RoleName varchar(255), PolicyId bigint,    
                  FeeId bigint, RetainerId bigint, OpportunityId bigint, AdviceCaseId bigint, ActivityType varchar(255), IndigoClientId int,
                  EventListName varchar(255), StartDate DateTime, TaskType varchar(50), PlanTypeName varchar(255), IsDocumentExist bit, PlanTypeId bigint,IsBillable bit)        
    
-- lets get the data for the tasks    
Insert into #spNIOCustomRetrieveTaskDTOTable(        
                  OrganiserActivityId, TaskId, SequentialRef, PriorityName , DueDate ,[Subject] ,AssignedUserId , AssignedUser,CompleteFG,RoleId,RoleName ,PolicyId ,FeeId,    
                  RetainerId,OpportunityId,AdviceCaseId, ActivityType, IndigoClientId, EventListName, StartDate, TaskType, PlanTypeName, IsDocumentExist, PlanTypeId,IsBillable)    
        
SELECT            A.OrganiserActivityId, A.TaskId, A.SequentialRef, '' as PriorityName, A.DueDate, A.[Subject], C.UserId As AssignedUserId, (D.FirstName + ' ' + D.LastName) As AssignedUser,    
                  A.CompleteFG , NULL as RoleId, NULL as RoleName, A.PolicyId, A.FeeId, A.RetainerId, A.OpportunityId, A.AdviceCaseId, 'Task', A.IndigoClientId, '' as EventListName,    
                  A.StartDate, AC.Name as TaskType,NULL AS PlanTypeName,0 as IsDocumentExist, NULL As PlanTypeId, 0 AS Billable    
FROM #TaskTable A    
                  LEFT JOIN Administration..Tuser C WITH(NOLOCK) on C.UserId = A.AssignedUserId    
                  LEFT JOIN CRM..TCRMContact D WITH(NOLOCK) on D.CRMcontactId=C.CRMcontactId    
                  LEFT JOIN CRM..TActivityCategory AC WITH(NOLOCK) on AC.ActivityCategoryId=A.ActivityCategoryId    
                  Where A.IndigoClientId = @TenantId --AND A.IndigoClientId=A.IndigoClientId    
  
-- Update the Table with AssignedToUser Values.  
UPDATE TDTO  
SET AssignedToUserId = E.UserId, AssignedToUser = (F.FirstName + ' ' + F.LastName)    
      FROM #spNIOCustomRetrieveTaskDTOTable TDTO  
      INNER JOIN #TaskTable A on TDTO.TaskId = A.TaskId  
      LEFT JOIN Administration..Tuser E WITH(NOLOCK) on E.UserId = A.AssignedToUserId    
      LEFT JOIN CRM..TCRMContact F WITH(NOLOCK) on F.CRMcontactId = E.CRMcontactId    
  
-- Update Advice Case & Task Status Details  
UPDATE #spNIOCustomRetrieveTaskDTOTable  
SET TaskStatus = G.Name, CaseRef = I.CaseRef    
      FROM #spNIOCustomRetrieveTaskDTOTable TDTO  
      Inner join #TaskTable A on TDTO.TaskId = A.TaskId  
      LEFT JOIN CRM..TRefTaskStatus G WITH(NOLOCK) on G.RefTaskStatusId=A.RefTaskStatusId    
      LEFT JOIN CRM..TAdviceCase I WITH(NOLOCK) on I.AdviceCaseId=A.AdviceCaseId  
  
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
        LEFT JOIN DocumentManagement..TDocument TD WITH(NOLOCK) ON TD.EntityId=A.TaskId AND TD.EntityType=5    
        WHERE A.IndigoClientId = @TenantId and TD.IndigoClientId = @TenantId    
        GROUP BY A.TaskId Having COUNT(TD.EntityId) > 0 ) Doc     
        INNER JOIN #spNIOCustomRetrieveTaskDTOTable B ON Doc.TaskId= B.TaskId    
    
--update the IsBillable flag if task is linked with any fees  
UPDATE #spNIOCustomRetrieveTaskDTOTable  
SET IsBillable = 1  
      FROM #spNIOCustomRetrieveTaskDTOTable A  
      INNER JOIN PolicyManagement..TFeetoTask FT WITH(NOLOCK) ON A.TaskId = FT.TaskId AND  FT.TenantId = @TenantId  
  
  
/* Create temporary table to retrieve plan related information as with the last retrieval we are facing perfomrance     
issue    
*/    
If Object_Id('tempdb..#tmpTaskPlanTable') Is Not Null        
 Drop Table #tmpTaskPlanTable    
    
Create Table #tmpTaskPlanTable(TaskId int,PlanTypeName varchar(255),PlanTypeId bigint)
    
Insert into #tmpTaskPlanTable(TaskId, PlanTypeName,PlanTypeId)    
    
Select A.TaskId, PT.PlanTypeName + ' (' + PC.CorporateName + ')' AS PlanTypeName, PB.PolicyBusinessId As PlanTypeId    
FROM #spNIOCustomRetrieveTaskDTOTable A    
INNER JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyBusinessId = A.PolicyId    
LEFT JOIN PolicyManagement..TPolicyDetail PD WITH(NOLOCK) ON PD.PolicyDetailId = PB.PolicyDetailId    
LEFT JOIN PolicyManagement..TPlanDescription PS WITH(NOLOCK) ON PS.PlanDescriptionId = PD.PlanDescriptionId    
LEFT JOIN PolicyManagement..TRefPlanType2ProdSubType RP WITH(NOLOCK) ON RP.RefPlanType2ProdSubTypeId = PS.RefPlanType2ProdSubTypeId    
LEFT JOIN PolicyManagement..TRefPlantype PT WITH(NOLOCK) ON PT.RefPlanTypeId = RP.RefPlanTypeId    
LEFT JOIN PolicyManagement..TRefProdProvider PP WITH(NOLOCK) ON PP.RefProdProviderId = PS.RefProdProviderId    
LEFT JOIN CRM..TCRMContact PC WITH(NOLOCK) ON PC.CRMContactId = PP.CRMContactId    
Where A.IndigoClientId = @TenantId AND PB.IndigoClientId = A.IndigoClientId   
      
    
UPDATE  #spNIOCustomRetrieveTaskDTOTable    
  SET ActivityType = ActivityType+' ('+ [dbo].[FnGetRecurrenceActivityType](AR.RFCCode) +')'    
      FROM #spNIOCustomRetrieveTaskDTOTable A    
      INNER JOIN TActivityRecurrence AR WITH(NOLOCK) ON AR.OrganiserActivityId= A.OrganiserActivityId    
    
-- lets return the data set    
Select A.OrganiserActivityId,A.TaskId,A.SequentialRef, A.PriorityName, A.DueDate,A.[Subject],A.AssignedUserId, A.AssignedUser,A.AssignedToUserId,      
 A.AssignedToUser,A.TaskStatus,A.CaseRef,A.ClientName,A.ClientPartyId,A.JointClientName,A.JointClientPartyId,A.CompleteFG,A.RoleId,A.RoleName,A.PolicyId,A.FeeId,      
 A.RetainerId,A.OpportunityId,A.AdviceCaseId, A.ActivityType,A.IndigoClientId,A.EventListName,A.StartDate,A.TaskType,B.PlanTypeName,A.IsDocumentExist  
 ,B.PlanTypeId,A.IsBillable      
 FROM #spNIOCustomRetrieveTaskDTOTable  A    
LEFT OUTER JOIN #tmpTaskPlanTable B on A.Taskid = B.TaskId    
Order By DueDate asc

    
GO
