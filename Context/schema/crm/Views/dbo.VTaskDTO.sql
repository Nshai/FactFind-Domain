SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[VTaskDTO] 
AS



WITH CTE_Tasks(    
	OrganiserActivityId, TaskId, SequentialRef, PriorityName , DueDate, Timezone, [Subject] ,AssignedUserId , AssignedUser ,AssignedToUserId,
	AssignedToUser,RoleId,RoleName ,TaskStatus,CaseRef  ,ClientName ,ClientPartyId , JointClientName ,JointClientPartyId ,CompleteFG,PolicyId ,FeeId,
	RetainerId,OpportunityId,AdviceCaseId, ActivityType, IndigoClientId, EventListName, StartDate, TaskType, PlanTypeName, IsDocumentExist,
	PlanTypeId,IsBillable,DateCompleted,ActivityOutcomeName,PerformedUserName,ProviderName,SolicitorName,PlanTypeProdSubTypeName,UpdatedByUserId,AdviceCaseName,CreatedDate)
	as
	(
SELECT
	OA.OrganiserActivityId,
	OA.TaskId,
	T.SequentialRef,
	RP.PriorityName,
	T.DueDate,
	T.Timezone,
	T.Subject,
	T.AssignedUserId,
	(D.FirstName + ' ' + D.LastName) As AssignedUser,
	T.AssignedToUserId,
	(F.FirstName + ' ' + F.LastName) As AssignedToUser,
	T.AssignedToRoleId AS RoleId,
	TATR.Identifier AS RoleName,
	RTS.Name AS TaskStatus,
	AC.CaseRef,
	CASE
		WHEN ClientP.PersonId IS NOT NULL THEN ClientP.FirstName+' '+ClientP.LastName
		WHEN ClientC.CorporateId IS NOT NULL THEN ClientC.CorporateName
		WHEN ClientT.TrustId IS NOT NULL THEN ClientT.TrustName
		ELSE ''
	END AS ClientName,
	Client.CRMContactId AS ClientPartyId,
	CASE
		WHEN JointClientP.PersonId IS NOT NULL THEN JointClientP.FirstName+' '+ JointClientP.LastName
		WHEN JointClientC.CorporateId IS NOT NULL THEN JointClientC.CorporateName
		WHEN JointClientT.TrustId IS NOT NULL THEN JointClientT.TrustName
		ELSE ''
	END AS JointClientName,
	JointClient.CRMContactId AS JointClientPartyId,
	OA.CompleteFG,
	OA.PolicyId,
	OA.FeeId,
	OA.RetainerId,
	OA.OpportunityId,
	OA.AdviceCaseId,
	'Task' AS ActivityType,
	OA.IndigoClientId,
	'' AS EventListName,
	T.StartDate as StartDate,
	Category.Name as TaskType,
    '' as PlanTypeName,
     0 as IsDocumentExist,
    NULL as PlanTypeId,
    0 as IsBillable,
	T.DateCompleted AS DateCompleted,
	'' AS ActivityOutcomeName,
	'' AS PerformedUserName,
	'' AS ProviderName,
	'' AS SolicitorName,
	'' AS PlanTypeProdSubTypeName,
	NULL AS UpdatedByUserId,
	'' AS AdviceCaseName,
	NULL AS CreatedDate
FROM 
	CRM.dbo.TOrganiserActivity OA
	JOIN CRM.dbo.TTask T
		ON T.TaskId = OA.TaskId
	LEFT JOIN CRM.dbo.TRefPriority RP
		ON RP.RefPriorityId = T.RefPriorityId
		LEFT JOIN CRM..TActivityCategory Category on Category.ActivityCategoryId=OA.ActivityCategoryId
		
	LEFT JOIN Administration..TUser TABU
		ON TABU.UserId = T.AssignedUserId
		--Join for fetching the assigned user crm contact name
	LEFT JOIN CRM..TCRMContact D on D.CRMcontactId=TABU.CRMcontactId
			
	LEFT JOIN Administration..TUser TATU
		ON TATU.UserId = T.AssignedToUserId
	--Join for fetching the assigned to user crm contact name
	LEFT JOIN CRM..TCRMContact F on F.CRMcontactId=TATU.CRMcontactId
		
	LEFT JOIN Administration.dbo.TRole TATR
		ON TATR.RoleId = T.AssignedToRoleId
	LEFT JOIN CRM.dbo.TRefTaskStatus RTS
		ON RTS.RefTaskStatusId = T.RefTaskStatusId
	LEFT JOIN CRM.dbo.TAdviceCase AC
		ON AC.AdviceCaseId = OA.AdviceCaseId
	
	LEFT JOIN CRM.dbo.TCRMContact Client
		ON Client.CRMContactId = OA.CRMContactId
	LEFT JOIN CRM.dbo.TPerson ClientP
		ON ClientP.PersonId = Client.PersonId
	LEFT JOIN CRM.dbo.TCorporate ClientC
		ON ClientC.CorporateId = Client.CorporateId
	LEFT JOIN CRM.dbo.TTrust ClientT
		ON ClientT.TrustId = Client.TrustId

	LEFT JOIN CRM.dbo.TCRMContact JointClient
		ON JointClient.CRMContactId = OA.JointCRMContactId
	LEFT JOIN CRM.dbo.TPerson JointClientP
		ON JointClientP.PersonId = JointClient.PersonId
	LEFT JOIN CRM.dbo.TCorporate JointClientC
		ON JointClientC.CorporateId = JointClient.CorporateId
	LEFT JOIN CRM.dbo.TTrust JointClientT
		ON JointClientT.TrustId = JointClient.TrustId
		),
		CTE_TasksDocuments (TaskId,IsDocumentExist)
	as
	(
		select A.TaskId, (case when COUNT(TD.EntityId)=0 then 0 else 1 end) AS IsDocumentExist from CTE_Tasks A
		LEFT JOIN DocumentManagement..TDocument TD ON TD.EntityId=A.TaskId AND TD.EntityType=5 and A.IndigoClientId = TD.IndigoClientId
		GROUP BY A.TaskId
		
	),
	CTE_TasksType (ActivityType,OrganiserActivityId)
	as
	(
		select ISNULL(ActivityType+' ('+ [dbo].[FnGetRecurrenceActivityType](AR.RFCCode) +')','Task'),A.OrganiserActivityId
		from CTE_Tasks A
		LEFT JOIN TActivityRecurrence AR ON AR.OrganiserActivityId= A.OrganiserActivityId
		
	),
	CTE_TaskBillable(TaskId,IsBillable)
	AS
	(
		SELECT A.TaskId, CASE WHEN FT.TaskId IS NOT NULL THEN 1 ELSE 0 END AS IsBillable 
		FROM CRM..TTask A  
		LEFT JOIN PolicyManagement..TFeetoTask FT ON A.TaskId = FT.TaskId AND A.IndigoClientId = FT.TenantId		
	)
	select 
		x.OrganiserActivityId, x.TaskId, SequentialRef, PriorityName , DueDate, Timezone, [Subject] ,AssignedUserId , AssignedUser ,AssignedToUserId,
	AssignedToUser,RoleId,RoleName ,TaskStatus,CaseRef  ,ClientName ,ClientPartyId, JointClientName, JointClientPartyId ,CompleteFG,PolicyId ,FeeId,
	RetainerId,OpportunityId,AdviceCaseId, z.ActivityType, IndigoClientId, EventListName, StartDate, TaskType, PlanTypeName, y.IsDocumentExist,
	PlanTypeId,b.IsBillable, DateCompleted, ActivityOutcomeName, PerformedUserName, x.ProviderName, x.SolicitorName, x.PlanTypeProdSubTypeName, x.UpdatedByUserId, x.AdviceCaseName, x.CreatedDate
		 from CTE_Tasks x 
		  JOIN CTE_TasksType z on z.OrganiserActivityId=x.OrganiserActivityId
		 JOIN CTE_TasksDocuments y on x.TaskId=y.TaskId
		 JOIN CTE_TaskBillable b on x.TaskId = b.TaskId
		 


GO
