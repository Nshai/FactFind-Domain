SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNIOCustomRetrieveQueueTaskDTO] @UserId bigint,@TenantId int,@_TopN bigint=0
AS  
  
/* Create temporary table to retrieve plan related information as with the last retrieval we are facing perfomrance   
issue  
*/  
If Object_Id('tempdb..#tmpTaskPlanQueueTable') Is Not Null      
 Drop Table #tmpTaskPlanQueueTable  
  
Create Table #tmpTaskPlanQueueTable(TaskId int,PlanTypeName varchar(255),PlanTypeId bigint)
  
Insert into #tmpTaskPlanQueueTable(TaskId, PlanTypeName,PlanTypeId)  
Select A.TaskId, PT.PlanTypeName + ' (' + PC.CorporateName + ')' AS PlanTypeName,  
     PB.PolicyBusinessId As PlanTypeId  
FROM CRM..TTask A  
INNER JOIN CRM..TOrganiserActivity H on A.TaskId=H.TaskId  
INNER JOIN Administration..TRole C on C.RoleId=A.AssignedToRoleId  
LEFT JOIN Administration..TUser L on L.UserId=A.AssignedUserId  
INNER JOIN PolicyManagement..TPolicyBusiness PB on PB.PolicyBusinessId=H.PolicyId  
LEFT JOIN PolicyManagement..TPolicyDetail PD on PD.PolicyDetailId=PB.PolicyDetailId  
LEFT JOIN PolicyManagement..TPlanDescription PS on PS.PlanDescriptionId=PD.PlanDescriptionId  
LEFT JOIN PolicyManagement..TRefPlanType2ProdSubType RP on RP.RefPlanType2ProdSubTypeId=PS.RefPlanType2ProdSubTypeId  
LEFT JOIN PolicyManagement..TRefPlantype PT on PT.RefPlanTypeId=RP.RefPlanTypeId  
LEFT JOIN PolicyManagement..TRefProdProvider PP ON PP.RefProdProviderId=PS.RefProdProviderId  
LEFT JOIN CRM..TCRMContact PC ON PC.CRMContactId=PP.CRMContactId  
Where A.IndigoClientId=@TenantId  
  
  
DECLARE @_UserId bigint  
  
IF EXISTS(SELECT 1 FROM Administration..TUser WHERE UserId = @UserId AND (SuperUser = 1 OR SuperViewer = 1))  
 SELECT @_UserId = @UserId * -1  
  
IF (@_TopN > 0) SET ROWCOUNT @_TopN  


SELECT DISTINCT
	H.OrganiserActivityId
	, A.TaskId
	, A.SequentialRef
	, B.PriorityName
	, A.DueDate
	, A.Subject
	, G.Name as TaskStatus
	, I.CaseRef
	, C.RoleId
	, C.Identifier as RoleName
	, CASE  
			WHEN J.CRMContactType = 1 THEN (J.FirstName + ' ' + J.LastName)      
			WHEN J.CRMContactType = 2 THEN J.CorporateName      
			WHEN J.CRMContactType = 3 THEN J.CorporateName  
		END AS ClientName
	, J.CRMContactId as ClientPartyId
	, CASE  
			WHEN JJ.CRMContactType = 1 THEN (JJ.FirstName + ' ' + JJ.LastName)      
			WHEN JJ.CRMContactType = 2 THEN JJ.CorporateName      
			WHEN JJ.CRMContactType = 3 THEN JJ.CorporateName  
		END AS JointClientName
	, JJ.CRMContactId as JointClientPartyId
	, NULL as AssignedUserId
	, (M.FirstName + ' ' + M.LAstName) as AssignedUser
	, NULL as AssignedToUserId
	, C.Identifier AS AssignedToUser
	, H.CompleteFG
	, H.PolicyId
	, H.FeeId
	, H.RetainerId
	, H.OpportunityId
	, H.AdviceCaseId
	, 'Task' + CASE WHEN H.IsRecurrence =1 THEN  
					' ('+   [dbo].[FnGetRecurrenceActivityType](AR.RFCCode) +')'  
					ELSE ''  
				END as ActivityType
	, A.IndigoClientId
	, NULL as EventListName
	, A.StartDate as StartDate
	, AC.Name as TaskType
	, TP.PlanTypeName AS PlanTypeName
	, CASE  
			WHEN (DV.DocVersionId > 0) AND (TD.EntityType=5) THEN 1 -- 5 is for task entity  
			ELSE 0  
		END AS IsDocumentExist
	, TP.PlanTypeId As PlanTypeId 
	, CASE WHEN  FT.TaskId IS NOT NULL THEN 1 ELSE 0 END AS IsBillable

FROM CRM..TTask A  
LEFT JOIN CRM..TRefPriority B on B.RefPriorityId=A.RefPriorityId  
INNER JOIN Administration..TRole C on C.RoleId=A.AssignedToRoleId  
LEFT JOIN CRM..TRefTaskStatus G on G.RefTaskStatusId=A.RefTaskStatusId  
INNER JOIN CRM..TOrganiserActivity H on A.TaskId=H.TaskId  
LEFT JOIN CRM..TAdviceCase I on I.AdviceCaseId=H.AdviceCaseId  
LEFT JOIN CRM..TCRMContact J on J.CRMContactId=H.CRMContactId  
LEFT JOIN CRM..TCRMContact JJ on JJ.CRMContactId=H.JointCRMContactId  
Inner Join Administration..TMembership K on K.RoleId=C.RoleId  
--lets get the assigned to user  
LEFT JOIN Administration..TUser L on L.UserId=A.AssignedUserId  
LEFT JOIN CRM..TCRMContact M on M.CRMContactId=L.CRMContactId  
  
 -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)    
LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = J._OwnerId    
LEFT JOIN VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = J.CRMContactId    
  
LEFT JOIN CRM..TActivityCategory AC on AC.ActivityCategoryId=H.ActivityCategoryId  
LEFT JOIN DocumentManagement..TDocument TD ON TD.EntityId=A.TaskId AND TD.IndigoClientId =@TenantId  
LEFT JOIN DocumentManagement..TDocVersion DV ON DV.DocumentId=TD.DocumentId AND  DV.IndigoClientId =@TenantId  
LEFT JOIN #tmpTaskPlanQueueTable TP ON TP.TaskId=A.TaskId  
LEFT JOIN TActivityRecurrence AR ON AR.OrganiserActivityId= H.OrganiserActivityId  
LEFT JOIN PolicyManagement..TFeetoTask FT ON A.TaskId = FT.TaskId AND FT.TenantId =@TenantId 
Where A.IndigoClientId=@TenantId And K.UserId=@UserId  
AND (@_UserId < 0 OR (J._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))    
Order by a.TaskId asc  
GO
