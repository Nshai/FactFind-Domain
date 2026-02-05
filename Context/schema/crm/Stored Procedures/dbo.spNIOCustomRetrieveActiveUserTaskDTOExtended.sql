USE CRM
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
Modification History (most recent first)
Date        Modifier        Issue          Description
----        ---------       -------        -------------
20200210    Nick Fairway    IP-51896       Performance enhancements
20200520    Nick Fairway    IP-76784       Performance enhancements
20250221    Nirmatt Gopal   CRMPM-16896    Redirect and Filter New Assigned Tasks for User View
20250826    Geethu N S      IOPM-5388      SQL Changes to Hide the "Save as Doc" Button in IO
*/
CREATE PROCEDURE dbo.spNIOCustomRetrieveActiveUserTaskDTOExtended 
	@UserId int, 
	@TenantId int,
	@IsShowSolicitor BIT = 0

AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  
SET NOCOUNT ON;
/* Create Temporary Table as we need to deal with three quite distinct entities  
- Tasks, Appointments, Emails  */  
DECLARE @ActiveUserTaskTable AS TABLE(      
       TaskId int
	   ,SequentialRef varchar(50),DueDate DateTime,Timezone varchar(100),[Subject] varchar(1000),  
       StartDate DateTime,AssignedUserId int, AssignedToUserId int,RefTaskStatusId int,CRMContactId int, JointCRMContactId int,  
       OrganiserActivityId int,PolicyId int,FeeId int,RetainerId int,OpportunityId int,AdviceCaseId int,  
       CompleteFG bit,EventListActivityId int,ActivityCategoryId int,RefPriorityId int, DateCompleted DATETIME, PerformedUserId int, PerformedUserName VARCHAR(255), ActivityOutcomeId int, ActivityOutcomeName VARCHAR(100),
	    AssignedToRoleId int, RoleName varchar(64), UpdatedByUserId int, AdviceCaseName varchar(255), CreatedDate DATETIME
	   )   
/* Create temporary table to retrieve plan related information as with the last retrieval we are facing perfomrance   
issue  
*/       
DECLARE @tmpActiveUserTaskPlanTable AS TABLE(TaskId int,PlanTypeName varchar(255),PlanTypeId int, PlanTypeProdSubTypeName varchar(255), ProviderName varchar(255),SolicitorName varchar(255), PolicyBusinessId INT)

DECLARE @spActiveUserTaskDTO AS TABLE(      
 OrganiserActivityId int
 ,TaskId int INDEX CLU_IDX Clustered
 ,TenantId int INDEX Ten_idx nonclustered
 ,SequentialRef varchar(50)
 , PriorityName varchar(255),DueDate DateTime,Timezone varchar(100),  
 [Subject] varchar(1000)
 , AssignedUserId int
 , AssignedUser varchar(255)
 , AssignedToUserId int INDEX IX1 NonClustered
 , AssignedToUser varchar(255), TaskStatus varchar(255), CaseRef varchar(50), ClientName varchar(255),  
 ClientPartyId int, 
 JointClientName varchar(255), JointClientPartyId int, RoleId int, RoleName varchar(255), PolicyId int,  
 FeeId int, RetainerId int, OpportunityId int
 , AdviceCaseId int INDEX AdviceCaseId_idx NONCLUSTERED
 , ActivityType varchar(255)
 ,EventListName varchar(255), StartDate DateTime, TaskType varchar(50), PlanTypeName varchar(255), IsDocumentExist bit
,PlanTypeId int,IsBillable BIT, DateCompleted DATETIME, PerformedUserName VARCHAR(255), ActivityOutcomeName VARCHAR(100)
,PerformedUserId int INDEX IX2 NonClustered
,RefTaskStatusId int INDEX IX3 NonClustered
,CRMContactId int INDEX IX4 NonClustered
, JointCRMContactId int INDEX IX5 NonClustered
, UpdatedByUserId int
, AdviceCaseName varchar(255)
, CreatedDate DATETIME
);

DECLARE @assUsers TABLE(AssignedToUserId int PRIMARY KEY, AssignedToUser varchar(255));
DECLARE @perUsers TABLE(PerformedUserId int, PerformedUserName varchar(255));
DECLARE  @TFeetoTask TABLE(TaskId int PRIMARY KEY);

	-----------------------------------------------------------------
	-- Retrieve tasks for the user. Two selects here, one for AssignedUser
	-- and one for AssignedToUser, UNION is quicker than using an OR statement.
	-----------------------------------------------------------------
INSERT INTO @ActiveUserTaskTable(
	TaskId,
	SequentialRef, DueDate ,Timezone,[Subject], StartDate,AssignedUserId,AssignedToUserId,RefTaskStatusId,  
	CRMContactId,JointCRMContactId,OrganiserActivityId,PolicyId,FeeId,RetainerId,OpportunityId,AdviceCaseId,  
	CompleteFG,EventListActivityId,ActivityCategoryId,RefPriorityId,DateCompleted,PerformedUserId,ActivityOutcomeId,AssignedToRoleId,RoleName,UpdatedByUserId,AdviceCaseName,CreatedDate)
SELECT
	A.TaskId,
	A.SequentialRef,
    A.DueDate,
	A.Timezone,
	A.Subject,
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
	A.RefPriorityId,
	A.DateCompleted,
	A.PerformedUserId,
	A.ActivityOutcomeId,
	A.AssignedToRoleId,
	R.Identifier,
	H.UpdatedByUserId,
	AC.CaseName,
	H.CreatedDate
FROM 
	CRM..TTask A
	LEFT JOIN administration..TRole R on R.RoleId = A.AssignedToRoleId
	JOIN CRM..TOrganiserActivity H on A.TaskId = H.TaskId
	LEFT JOIN CRM..TAdviceCase AC ON H.AdviceCaseId = AC.AdviceCaseId
WHERE
	A.IndigoClientId = @TenantId
	AND	H.IndigoClientId=@TenantId
	AND (A.AssignedUserId = @UserId OR A.AssignedToUserId = @UserId)
	AND H.CompleteFG = 0


-- Remove Tasks for Deleted Clients 
DELETE A
FROM @ActiveUserTaskTable A
INNER JOIN dbo.TCRMCOntact B ON A.CRMCOntactID = B.CRMContactID
WHERE B.IsDeleted = 1

     
-- lets get the data for the tasks  
INSERT INTO @spActiveUserTaskDTO(      
 OrganiserActivityId, TaskId, TenantId, SequentialRef, PriorityName , DueDate ,Timezone,[Subject] ,AssignedUserId, AssignedUser, RoleId,RoleName ,PolicyId ,FeeId,  
 RetainerId,OpportunityId,AdviceCaseId, ActivityType, EventListName, StartDate, TaskType, PlanTypeName, IsDocumentExist,  
 PlanTypeId,IsBillable,DateCompleted,ActivityOutcomeName,PerformedUserId,
 RefTaskStatusId, CRMContactId, JointCRMContactId, AssignedToUserId, UpdatedByUserId, AdviceCaseName, CreatedDate)
 
SELECT   
	A.OrganiserActivityId,  
	A.TaskId,   
	TenantId = @TenantId,
	A.SequentialRef,  
	ISNULL(Pr.PriorityName, '') as PriorityName,   
	A.DueDate,
	A.Timezone,   
	A.Subject,   
	C.UserId As AssignedUserId,  
	(D.FirstName + ' ' + D.LastName) As AssignedUser,  
	A.AssignedToRoleId as RoleId,
	A.RoleName as RoleName,  
	A.PolicyId,   
	A.FeeId,   
	A.RetainerId,  
	A.OpportunityId,  
	A.AdviceCaseId,  
	'Task',  
	'' as EventListName,  
	A.StartDate,  
	AC.Name as TaskType,   
	NULL AS PlanTypeName,  
	0 as IsDocumentExist,  
	NULL As PlanTypeId,
	0 AS Billable,
	A.DateCompleted,
	AO.ActivityOutcomeName,
	A.PerformedUserId,
	A.RefTaskStatusId,
	A.CRMContactId,
	A.JointCRMContactId,
	A.AssignedToUserId,
	A.UpdatedByUserId,
	A.AdviceCaseName,
	A.CreatedDate
FROM @ActiveUserTaskTable A 
LEFT JOIN dbo.TRefPriority Pr on Pr.RefPriorityId=A.RefPriorityId AND Pr.IndClientId = @TenantId
LEFT JOIN Administration..Tuser C on C.UserId=A.AssignedUserId  
LEFT JOIN CRM..TCRMContact D on D.CRMcontactId=C.CRMcontactId  
LEFT JOIN CRM..TActivityCategory AC on AC.ActivityCategoryId=A.ActivityCategoryId  AND AC.IndigoClientId = @TenantId
LEFT JOIN CRM..TActivityOutcome AO on AO.ActivityOutcomeId=A.ActivityOutcomeId  AND AO.IndigoClientId = @TenantId

INSERT INTO @assUsers
SELECT DISTINCT AssignedToUserId, NULL 
FROM @spActiveUserTaskDTO
WHERE AssignedToUserId IS NOT NULL

UPDATE assU
SET AssignedToUser = (F.FirstName + ' ' + F.LastName)
FROM @assUsers assU
JOIN Administration..Tuser E on E.UserId=assU.AssignedToUserId 
JOIN CRM..TCRMContact F on F.CRMcontactId=E.CRMcontactId

UPDATE TDTO
SET AssignedToUser = assU.AssignedToUser
FROM @spActiveUserTaskDTO TDTO
JOIN @assUsers assU on assU.AssignedToUserId=TDTO.AssignedToUserId

-- Update the Table with PerformedUserName Values.
INSERT INTO @perUsers
SELECT DISTINCT PerformedUserId, NULL 
FROM @spActiveUserTaskDTO
WHERE PerformedUserId IS NOT NULL

-- Update the Table with PerformedUserName Values.
UPDATE perfU
SET PerformedUserName = (F.FirstName + ' ' + F.LastName)
FROM @perUsers perfU
JOIN Administration..Tuser E on E.UserId=perfU.PerformedUserId 
JOIN CRM..TCRMContact F on F.CRMcontactId=E.CRMcontactId
UPDATE TDTO
SET PerformedUserName = perfU.PerformedUserName
FROM @spActiveUserTaskDTO TDTO
JOIN @perUsers perfU ON perfU.PerformedUserId=TDTO.PerformedUserId


-- Update Advice Case & Task Status Details
UPDATE @spActiveUserTaskDTO
SET TaskStatus = G.Name,  
    CaseRef = I.CaseRef
FROM @spActiveUserTaskDTO TDTO
LEFT JOIN CRM..TRefTaskStatus G on G.RefTaskStatusId=TDTO.RefTaskStatusId  
LEFT JOIN CRM..TAdviceCase I on I.AdviceCaseId=TDTO.AdviceCaseId


-- Update Client & Join Client Information
UPDATE @spActiveUserTaskDTO
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
FROM @spActiveUserTaskDTO TDTO
LEFT JOIN CRM..TCRMContact J on J.CRMContactId=TDTO.CRMContactId
LEFT JOIN CRM..TCRMContact JJ on JJ.CRMContactId=TDTO.JointCRMContactId


--Update the IsDocument Flag if Task has any associated documents.  
UPDATE @spActiveUserTaskDTO  
 SET IsDocumentExist = 1  
 FROM (  
     SELECT A.TaskId  
  FROM @spActiveUserTaskDTO A    
  LEFT JOIN DocumentManagement..TDocument TD ON TD.EntityId=A.TaskId AND TD.EntityType=5  
  WHERE 
	TD.IndigoClientId = @TenantId  
  GROUP BY A.TaskId  
  Having COUNT(TD.EntityId) > 0 ) Doc
INNER JOIN @spActiveUserTaskDTO B ON Doc.TaskId= B.TaskId  

INSERT @TFeetoTask
SELECT DISTINCT TaskId 
FROM	PolicyManagement..TFeetoTask
WHERE TenantId = @TenantId
--update the IsBillable flag if task is linked with any fees
UPDATE @spActiveUserTaskDTO
SET IsBillable = 1
FROM @spActiveUserTaskDTO A
INNER JOIN	@TFeetoTask FT 
ON	A.TaskId	= FT.TaskId 

INSERT INTO @tmpActiveUserTaskPlanTable(TaskId, PlanTypeName,PlanTypeId,PlanTypeProdSubTypeName,ProviderName,SolicitorName,PolicyBusinessId)  

SELECT DISTINCT A.TaskId,   
       PT.PlanTypeName + ' (' + PC.CorporateName + ')' AS PlanTypeName,  
    PB.PolicyBusinessId As PlanTypeId,    
	CASE WHEN PSub.ProdSubTypeName IS NULL THEN PT.PlanTypeName 
		 ELSE PT.PlanTypeName + ' (' +PSub.ProdSubTypeName + ')' END AS PlanTypeProdSubTypeName,  
		 PC.CorporateName,
	NULL AS SolicitorName,
	PB.PolicyBusinessId   
FROM @spActiveUserTaskDTO A  
INNER JOIN PolicyManagement..TPolicyBusiness PB on PB.PolicyBusinessId=A.PolicyId  
LEFT JOIN PolicyManagement..TPolicyDetail PD on PD.PolicyDetailId=PB.PolicyDetailId  
LEFT JOIN PolicyManagement..TPlanDescription PS on PS.PlanDescriptionId=PD.PlanDescriptionId  
LEFT JOIN PolicyManagement..TRefPlanType2ProdSubType RP on RP.RefPlanType2ProdSubTypeId=PS.RefPlanType2ProdSubTypeId  
LEFT JOIN PolicyManagement..TRefPlantype PT on PT.RefPlanTypeId=RP.RefPlanTypeId  
LEFT JOIN PolicyManagement..TRefProdProvider PP ON PP.RefProdProviderId=PS.RefProdProviderId  
LEFT JOIN CRM..TCRMContact PC ON PC.CRMContactId=PP.CRMContactId
LEFT JOIN [policymanagement].[dbo].[TProdSubType] AS PSub ON PSub.ProdSubTypeId = RP.ProdSubTypeId  
Where  
PB.IndigoClientId=@TenantId 
GROUP BY  TaskId,  PT.PlanTypeName, PlanTypeId,PC.CorporateName ,PB.PolicyBusinessId, PSub.ProdSubTypeName  

----------------------------------------------------------------------------------
-- Fill a SolicitorName
----------------------------------------------------------------------------------
IF (@IsShowSolicitor = 1) /*IP-28321 -  Show Solicitor only for the following tenants: 11776, 11631, 99 */
BEGIN
UPDATE @tmpActiveUserTaskPlanTable
SET SolicitorName =  STUFF 
	    (     
			(SELECT DISTINCT  ' ' + ISNULL(PCON.CompanyName, '') 
				FROM [policymanagement].[dbo].[TPolicyBusinessToProfessionalContact] AS PBPC
				INNER JOIN [factfind].[dbo].[TProfessionalContact] AS PCON ON PCON.ProfessionalContactId = PBPC.ProfessionalContactId AND PCON.ContactType = 'Solicitor' 
				WHERE PBPC.PolicyBusinessId = t.PolicyBusinessId
				FOR XML PATH (''),TYPE ).value( '(./text())[1]','VARCHAR(MAX)' ),1,1,'' 

		)
		FROM @tmpActiveUserTaskPlanTable t     
END
-- lets get data for the emails  
INSERT INTO @spActiveUserTaskDTO(      
 OrganiserActivityId,TaskId,SequentialRef, PriorityName , DueDate ,[Subject] ,AssignedUserId , AssignedUser ,AssignedToUserId,  
 AssignedToUser,TaskStatus,CaseRef ,ClientName ,ClientPartyId,RoleId,RoleName ,PolicyId ,FeeId,  
 RetainerId,OpportunityId,AdviceCaseId, ActivityType, StartDate, TaskType, PlanTypeName, IsDocumentExist, PlanTypeId, DateCompleted, PerformedUserName) 

SELECT Distinct A.OrganiserActivityId,NULL, 'N/A',NULL,K.SentDate,K.Subject,M.UserId,(L.FirstName + ' ' + L.LastName),
	M.UserId, (L.FirstName + ' ' + L.LastName),  
CASE      
 WHEN (EO.EntityOrganiserActivityId > 0) THEN 'Complete'  
 ELSE 'Incomplete'  
END AS TaskStatus,
NULL,NULL,NULL, NULL,NULL,NULL,NULL,  
NULL,NULL,NULL,'Email', NULL, 'Email', NULL,   
CASE  
 WHEN (TA.AttachmentId > 0) THEN 1  
 ELSE 0  
END AS IsDocumentExist  
, NULL,k.SentDate,(L.FirstName + ' ' + L.LastName)
FROM TOrganiserActivity A  
JOIN CRM..TEmail K on K.OrganiserActivityId=A.OrganiserActivityId 
LEFT JOIN CRM..TEntityOrganiserActivity EO on A.OrganiserActivityId = EO.OrganiserActivityId  
LEFT JOIN CRM..TCRMContact L on L.CRMContactId=K.OwnerPartyId  
LEFT JOIN ADMINISTRATION..TUser M on M.CRMContactId=L.CRMContactId  
LEFT JOIN CRM..TAttachment TA ON TA.EmailId = K.EmailId
--Check for Tenant  
WHERE M.IndigoClientId=@TenantId  
--Records for User if Party Id is 0  
AND M.UserId = @UserId
AND A.CompleteFG = 0


UPDATE  @spActiveUserTaskDTO  
  SET ActivityType = ActivityType+' ('+ [dbo].[FnGetRecurrenceActivityType](AR.RFCCode) +')'  
FROM @spActiveUserTaskDTO A  
INNER JOIN TActivityRecurrence AR ON AR.OrganiserActivityId= A.OrganiserActivityId  


-- lets return the data set
SELECT  A.OrganiserActivityId,A.TaskId,A.SequentialRef, A.PriorityName, A.DueDate,A.Timezone ,A.[Subject],A.AssignedUserId, A.AssignedUser,A.AssignedToUserId,    
 A.AssignedToUser,A.TaskStatus,A.CaseRef,A.ClientName,A.ClientPartyId,A.JointClientName,A.JointClientPartyId, CAST('FALSE' as bit) as CompleteFG, A.RoleId,A.RoleName,A.PolicyId,A.FeeId,    
 A.RetainerId,A.OpportunityId,A.AdviceCaseId, A.ActivityType,@TenantId as IndigoClientId,A.EventListName,A.StartDate,A.TaskType
 ,PlanTypeName = NULL
 ,A.IsDocumentExist
 ,PlanTypeId = NULL
 ,A.IsBillable,A.DateCompleted,A.ActivityOutcomeName,A.PerformedUserName
 ,ProviderName = NULL, SolicitorName = NULL, PlanTypeProdSubTypeName = NULL
 ,A.UpdatedByUserId
 ,A.AdviceCaseName
 ,A.CreatedDate
FROM @spActiveUserTaskDTO  A  
WHERE A.PolicyId IS NULL

UNION

SELECT A.OrganiserActivityId,A.TaskId,A.SequentialRef, A.PriorityName, A.DueDate,A.Timezone, A.[Subject],A.AssignedUserId, A.AssignedUser,A.AssignedToUserId,    
 A.AssignedToUser,A.TaskStatus,A.CaseRef,A.ClientName,A.ClientPartyId,A.JointClientName,A.JointClientPartyId, CAST('FALSE' as bit) as CompleteFG, A.RoleId,A.RoleName,A.PolicyId,A.FeeId,    
 A.RetainerId,A.OpportunityId,A.AdviceCaseId, A.ActivityType,@TenantId as IndigoClientId,A.EventListName,A.StartDate,A.TaskType,B.PlanTypeName,A.IsDocumentExist
 ,B.PlanTypeId,A.IsBillable,A.DateCompleted,A.ActivityOutcomeName,A.PerformedUserName,B.ProviderName, B.SolicitorName , B.PlanTypeProdSubTypeName, A.UpdatedByUserId, A.AdviceCaseName, A.CreatedDate
 FROM @spActiveUserTaskDTO  A  
INNER JOIN @tmpActiveUserTaskPlanTable B ON A.Taskid = B.TaskId
AND A.PolicyId IS NOT NULL
ORDER BY DueDate ASC;
          
GO
