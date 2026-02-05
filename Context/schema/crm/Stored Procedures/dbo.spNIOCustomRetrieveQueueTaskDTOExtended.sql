USE [CRM]
GO
SET QUOTED_IDENTIFIER ON
GO


SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue           Description
----        ---------       -------         -------------
20201014    Nick Fairway    IP-90106        Performance issue: CTE used instead of temp table
20250221    Nirmatt Gopal   CRMPM-16896     Redirect and Filter New Assigned Tasks for User View
20250826    Geethu N S      IOPM-5388      SQL Changes to Hide the "Save as Doc" Button in IO*/
CREATE PROCEDURE dbo.spNIOCustomRetrieveQueueTaskDTOExtended @UserId int,@TenantId int,@_TopN int=0
AS  

SET NOCOUNT ON;

DECLARE @_UserId int = @UserId
  
IF EXISTS(SELECT 1 FROM Administration.dbo.TUser WHERE UserId = @UserId AND (SuperUser = 1 OR SuperViewer = 1))  
 SELECT @_UserId = @UserId * -1  
  
IF (@_TopN > 0) SET ROWCOUNT @_TopN; 
  
WITH CTE_Plans AS 
(
    SELECT
		PB.PolicyBusinessId,
		PT.PlanTypeName + ' (' + PC.CorporateName + ')' AS PlanTypeName,  
        PB.PolicyBusinessId AS PlanTypeId  
    FROM 
		PolicyManagement.dbo.TPolicyBusiness PB
		INNER JOIN PolicyManagement.dbo.TPolicyDetail PD ON PD.PolicyDetailId = PB.PolicyDetailId  
		INNER JOIN PolicyManagement.dbo.TPlanDescription PS ON PS.PlanDescriptionId = PD.PlanDescriptionId  
		INNER JOIN PolicyManagement.dbo.TRefPlanType2ProdSubType RP ON RP.RefPlanType2ProdSubTypeId = PS.RefPlanType2ProdSubTypeId  
		INNER JOIN PolicyManagement.dbo.TRefPlantype PT ON PT.RefPlanTypeId = RP.RefPlanTypeId  
		INNER JOIN PolicyManagement.dbo.TRefProdProvider PP ON PP.RefProdProviderId = PS.RefProdProviderId  
		INNER JOIN CRM.dbo.TCRMContact PC ON PC.CRMContactId = PP.CRMContactId  
    WHERE PB.IndigoClientId = @TenantId 
),
CTE_Activities AS
(
	SELECT
		H.TaskId,
		H.OrganiserActivityId,
		I.CaseRef, 
		CASE  
			WHEN J.CRMContactType = 1 THEN (J.FirstName + ' ' + J.LastName)      
			ELSE J.CorporateName
		END AS ClientName,
		J.CRMContactId AS ClientPartyId,
		CASE  
			WHEN JJ.CRMContactType = 1 THEN (JJ.FirstName + ' ' + JJ.LastName)      
			ELSE JJ.CorporateName  
		END AS JointClientName,
		JJ.CRMContactId AS JointClientPartyId,
		H.CompleteFG, 
		H.PolicyId,
		H.FeeId,
		H.RetainerId,
		H.OpportunityId,
		H.AdviceCaseId,
		'Task' + CASE WHEN H.IsRecurrence = 1 THEN  
					' (' + [dbo].[FnGetRecurrenceActivityType](AR.RFCCode) + ')'  
					ELSE ''  
				END AS ActivityType,
		AC.Name AS TaskType,
		TP.PlanTypeName AS PlanTypeName,
		TP.PlanTypeId AS PlanTypeId
	FROM
		CRM.dbo.TOrganiserActivity H
		
		LEFT JOIN CRM.dbo.TCRMContact JJ ON JJ.IndClientId = @TenantId AND JJ.CRMContactId = H.JointCRMContactId AND JJ.IsDeleted = 0
		
		LEFT JOIN CRM.dbo.TCRMContact J ON J.IndClientId = @TenantId AND J.CRMContactId = H.CRMContactId AND J.IsDeleted = 0  
		-- Secure (we have two joins, one for ownership rights & one for specific user/role rights)    
		LEFT JOIN CRM.dbo.VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = J._OwnerId    
		LEFT JOIN CRM.dbo.VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = J.CRMContactId
		
		LEFT JOIN CRM.dbo.TActivityCategory AC ON AC.ActivityCategoryId = H.ActivityCategoryId  
		LEFT JOIN CRM.dbo.TAdviceCase I ON I.AdviceCaseId = H.AdviceCaseId  
		LEFT JOIN CRM.dbo.TActivityRecurrence AR ON AR.OrganiserActivityId = H.OrganiserActivityId  
		
		LEFT JOIN CTE_Plans TP ON TP.PolicyBusinessId = H.PolicyId  
	WHERE
		@_UserId < 0 OR J._OwnerId = @_UserId OR TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL
),
CTE_Documents AS 
(
	SELECT 
		1 AS IsDocumentExist,
		TD.EntityId,
		TD.IndigoClientId
	FROM 
		DocumentManagement.dbo.TDocument TD
		JOIN DocumentManagement.dbo.TDocVersion DV ON DV.DocumentId = TD.DocumentId
	WHERE TD.EntityType = 5
)
SELECT DISTINCT	
	TA.OrganiserActivityId
	, A.TaskId
	, A.SequentialRef
	, ISNULL(B.PriorityName, '') AS PriorityName
	, A.DueDate
	, A.Timezone
	, A.Subject
	, G.Name AS TaskStatus
	, TA.CaseRef
	, C.RoleId
	, C.Identifier AS RoleName
	, TA.ClientName
	, TA.ClientPartyId
	, TA.JointClientName
	, TA.JointClientPartyId
	, NULL AS AssignedUserId
	, (M.FirstName + ' ' + M.LAstName) AS AssignedUser
	, NULL AS AssignedToUserId
	, C.Identifier AS AssignedToUser
	, TA.CompleteFG
	, TA.PolicyId
	, TA.FeeId
	, TA.RetainerId
	, TA.OpportunityId
	, TA.AdviceCaseId
	, TA.ActivityType
	, A.IndigoClientId
	, NULL AS EventListName
	, A.StartDate AS StartDate
	, TA.TaskType
	, TA.PlanTypeName
	, ISNULL(TD.IsDocumentExist, 0) AS IsDocumentExist
	, TA.PlanTypeId 
	, CASE WHEN FT.TaskId IS NOT NULL THEN 1 ELSE 0 END AS IsBillable,
	NULL AS DateCompleted,
	'' AS ActivityOutcomeName,
	'' AS PerformedUserName,
	'' AS ProviderName,
	'' AS SolicitorName,
	'' AS PlanTypeProdSubTypeName,
	NULL AS UpdatedByUserId,
	'' AS AdviceCaseName,
	NULL AS CreatedDate

FROM 
	CRM.dbo.TTask A  
	LEFT JOIN CRM.dbo.TRefTaskStatus G ON G.RefTaskStatusId = A.RefTaskStatusId  
	LEFT JOIN CRM.dbo.TRefPriority B ON B.RefPriorityId = A.RefPriorityId  

	--lets get the assigned to user  
	LEFT JOIN Administration.dbo.TUser L ON L.IndigoClientId = @TenantId AND L.UserId = A.AssignedUserId  
	LEFT JOIN CRM.dbo.TCRMContact M ON M.IndClientId = @TenantId AND M.CRMContactId = L.CRMContactId  

	INNER JOIN Administration.dbo.TRole C ON C.IndigoClientId = @TenantId AND C.RoleId = A.AssignedToRoleId  
	INNER JOIN Administration.dbo.TMembership K ON K.RoleId = C.RoleId AND K.UserId = @UserId   
	
	LEFT JOIN PolicyManagement.dbo.TFeetoTask FT ON FT.TenantId = @TenantId AND A.TaskId = FT.TaskId
	LEFT JOIN CTE_Documents TD ON TD.IndigoClientId = @TenantId AND TD.EntityId = A.TaskId

	INNER JOIN CTE_Activities TA ON A.TaskId = TA.TaskId  
WHERE A.IndigoClientId = @TenantId
ORDER BY A.TaskId
GO