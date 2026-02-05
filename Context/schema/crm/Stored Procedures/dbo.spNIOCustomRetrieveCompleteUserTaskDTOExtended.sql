USE [CRM];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

/*
Modification History (most recent first)
Date        Modifier        Issue          Description
----        ---------       -------        -------------
20200131    Nick Fairway    IP-51896       Created by refactoring spNIOCustomRetrieveTaskDTOExtended
20200520    Nick Fairway    IP-76784       Perfromance tune
20250221    Nirmatt Gopal   CRMPM-16896    Redirect and Filter New Assigned Tasks for User View
20250826    Geethu N S      IOPM-5388      SQL Changes to Hide the "Save as Doc" Button in IO*/
CREATE PROCEDURE dbo.spNIOCustomRetrieveCompleteUserTaskDTOExtended
    @UserId       INT
,   @TenantId     INT
,   @StartDate    DATETIME = NULL
,   @EndDate      DATETIME = NULL
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
--SET ANSI_WARNINGS ON; - must be on from the calling proc; changing it here sometimes casuses this to hang
SET NOCOUNT ON;

/* Create Temporary Table as we need to deal with three quite distinct entities  
- Tasks, Appointments, Emails  */

DECLARE
    @ActiveUserTaskTable AS TABLE
(
    TaskId                 INT
,   SequentialRef          VARCHAR(50)
,   DueDate                DATETIME
,   Timezone               VARCHAR(100)
,   Subject                VARCHAR(1000)
,   StartDate              DATETIME
,   AssignedUserId         INT
,   AssignedToUserId       INT
,   RefTaskStatusId        INT
,   CRMContactId           INT
,   JointCRMContactId      INT
,   OrganiserActivityId    INT
,   PolicyId               INT
,   FeeId                  INT
,   RetainerId             INT
,   OpportunityId          INT
,   AdviceCaseId           INT
,   CompleteFG             BIT
,   EventListActivityId    INT
,   ActivityCategoryId     INT
,   RefPriorityId          INT
,   DateCompleted          DATETIME
,   PerformedUserId        INT
,   PerformedUserName      VARCHAR(255)
,   ActivityOutcomeId      INT
,   ActivityOutcomeName    VARCHAR(100)
,   AssignedToRoleId       INT
,   RoleName               VARCHAR(100)
,   UpdatedByUserId        INT
,   AdviceCaseName         VARCHAR(255)
,   CreatedDate            DATETIME
);

/* Create temporary table to retrieve plan related information as with the last retrieval we are facing perfomrance   
issue  
*/

DECLARE
    @tmpActiveUserTaskPlanTable AS TABLE
(
    TaskId                     INT
,   PlanTypeName               VARCHAR(255)
,   PlanTypeId                 INT
,   PlanTypeProdSubTypeName    VARCHAR(255)
,   ProviderName               VARCHAR(255)
,   SolicitorName              VARCHAR(255)
,   PolicyBusinessId           INT
);

DECLARE
    @spActiveUserTaskDTO AS TABLE
(
    OrganiserActivityId    INT
,   TaskId                 INT
,   SequentialRef          VARCHAR(50)
,   PriorityName           VARCHAR(255)
,   DueDate                DATETIME
,   Timezone               VARCHAR(100)
,   Subject                VARCHAR(1000)
,   AssignedUserId         INT
,   AssignedUser           VARCHAR(255)
,   AssignedToUserId       INT index ix_@spActiveUserTaskDTO_AssignedToUserId
,   AssignedToUser         VARCHAR(255)
,   TaskStatus             VARCHAR(255)
,   CaseRef                VARCHAR(50)
,   ClientName             VARCHAR(255)
,   ClientPartyId          INT
,   JointClientName        VARCHAR(255)
,   JointClientPartyId     INT
,   RoleId                 INT
,   RoleName               VARCHAR(255)
,   PolicyId               INT
,   FeeId                  INT
,   RetainerId             INT
,   OpportunityId          INT
,   AdviceCaseId           INT
,   ActivityType           VARCHAR(255)
,   EventListName          VARCHAR(255)
,   StartDate              DATETIME
,   TaskType               VARCHAR(50)
,   PlanTypeName           VARCHAR(255)
,   IsDocumentExist        BIT
,   PlanTypeId             INT
,   IsBillable             BIT
,   DateCompleted          DATETIME
,   PerformedUserName      VARCHAR(255)
,   ActivityOutcomeName    VARCHAR(100)
,   PerformedUserId        INT
,   RefTaskStatusId        INT
,   CRMContactId           INT
,   JointCRMContactId      INT
,   UpdatedByUserId        INT
,   AdviceCaseName         VARCHAR(255)
,   CreatedDate            DATETIME
);

DECLARE @assUsers TABLE(AssignedToUserId int PRIMARY KEY, AssignedToUser varchar(255));
DECLARE @perUsers TABLE(PerformedUserId int, PerformedUserName varchar(255));
DECLARE  @TFeetoTask TABLE(TaskId int PRIMARY KEY);

-----------------------------------------------------------------
-- Retrieve tasks for the user. Two selects here, one for AssignedUser
-- and one for AssignedToUser, UNION is quicker than using an OR statement.
-----------------------------------------------------------------
INSERT INTO @ActiveUserTaskTable
(
    TaskId
  , SequentialRef
  , DueDate
  , Timezone
  , Subject
  , StartDate
  , AssignedUserId
  , AssignedToUserId
  , RefTaskStatusId
  , CRMContactId
  , JointCRMContactId
  , OrganiserActivityId
  , PolicyId
  , FeeId
  , RetainerId
  , OpportunityId
  , AdviceCaseId
  , CompleteFG
  , EventListActivityId
  , ActivityCategoryId
  , RefPriorityId
  , DateCompleted
  , PerformedUserId
  , ActivityOutcomeId
  , AssignedToRoleId
  , RoleName
  , UpdatedByUserId
  , AdviceCaseName
  , CreatedDate
)
SELECT
    A.TaskId
  , A.SequentialRef
  , A.DueDate
  , A.Timezone
  , A.Subject
  , A.StartDate
  , A.AssignedUserId
  , A.AssignedToUserId
  , A.RefTaskStatusId
  , H.CRMContactId
  , H.JointCRMContactId
  , H.OrganiserActivityId
  , H.PolicyId
  , H.FeeId
  , H.RetainerId
  , H.OpportunityId
  , H.AdviceCaseId
  , H.CompleteFG
  , H.EventListActivityId
  , H.ActivityCategoryId
  , A.RefPriorityId
  , A.DateCompleted
  , A.PerformedUserId
  , A.ActivityOutcomeId
  , A.AssignedToRoleId
  , R.Identifier
  , H.UpdatedByUserId
  , AC.CaseName
  , H.CreatedDate
FROM CRM..TTask A
LEFT JOIN administration..TRole R ON A.AssignedToRoleId = R.RoleId
JOIN CRM..TOrganiserActivity H
ON
    A.TaskId = H.TaskId
LEFT JOIN CRM..TAdviceCase AC ON H.AdviceCaseId = AC.AdviceCaseId
WHERE
    A.IndigoClientId = @TenantId
AND
(
A.AssignedUserId = @UserId
OR
    A.AssignedToUserId = @UserId)
AND
    H.CompleteFG = 1
AND
(
A.DateCompleted BETWEEN @StartDate AND @EndDate
OR
@StartDate IS NULL
AND
    A.DateCompleted <= @EndDate
OR
@EndDate IS NULL
AND
    A.DateCompleted >= @StartDate
OR
@StartDate IS NULL
AND
@EndDate IS NULL)

DELETE A
FROM @ActiveUserTaskTable A
INNER JOIN TCRMCOntact B
ON
    A.CRMCOntactID = B.CRMContactID
WHERE
    B.IsDeleted = 1;

-- lets get the data for the tasks  
INSERT INTO @spActiveUserTaskDTO
(
    OrganiserActivityId
  , TaskId
  , SequentialRef
  , PriorityName
  , DueDate
  , Timezone
  , Subject
  , AssignedUserId
  , AssignedUser
  , RoleId
  , RoleName
  , PolicyId
  , FeeId
  , RetainerId
  , OpportunityId
  , AdviceCaseId
  , ActivityType
  , EventListName
  , StartDate
  , TaskType
  , PlanTypeName
  , IsDocumentExist
  , PlanTypeId
  , IsBillable
  , DateCompleted
  , ActivityOutcomeName
  , PerformedUserId
  , RefTaskStatusId
  , CRMContactId
  , JointCRMContactId
  , AssignedToUserId
  , UpdatedByUserId
  , AdviceCaseName
  , CreatedDate
)
SELECT
    A.OrganiserActivityId
  , A.TaskId
  , A.SequentialRef
  , ISNULL(Pr.PriorityName, '') AS    PriorityName
  , A.DueDate
  , A.Timezone
  , A.Subject
  , C.UserId AS                       AssignedUserId
  , D.FirstName + ' ' + D.LastName AS AssignedUser
  , A.AssignedToRoleId AS             RoleId
  , A.RoleName AS                     RoleName
  , A.PolicyId
  , A.FeeId
  , A.RetainerId
  , A.OpportunityId
  , A.AdviceCaseId
  , 'Task'
  , '' AS                             EventListName
  , A.StartDate
  , AC.Name AS                        TaskType
  , NULL AS                           PlanTypeName
  , 0 AS                              IsDocumentExist
  , NULL AS                           PlanTypeId
  , 0 AS                              Billable
  , A.DateCompleted
  , AO.ActivityOutcomeName
  , A.PerformedUserId
  , A.RefTaskStatusId
  , A.CRMContactId
  , A.JointCRMContactId
  , A.AssignedToUserId
  , A.UpdatedByUserId
  , A.AdviceCaseName
  , A.CreatedDate
FROM @ActiveUserTaskTable A
LEFT JOIN TRefPriority Pr
ON
Pr.RefPriorityId = A.RefPriorityId
AND
    Pr.IndClientId = @TenantId
LEFT JOIN Administration..Tuser C
ON
    C.UserId = A.AssignedUserId
LEFT JOIN CRM..TCRMContact D
ON
    D.CRMcontactId = C.CRMcontactId
LEFT JOIN CRM..TActivityCategory AC
ON
AC.ActivityCategoryId = A.ActivityCategoryId
AND
    AC.IndigoClientId = @TenantId
LEFT JOIN CRM..TActivityOutcome AO
ON
AO.ActivityOutcomeId = A.ActivityOutcomeId
AND
    AO.IndigoClientId = @TenantId;

-- Update the Table with AssignedToUser Values.
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
FROM   @spActiveUserTaskDTO TDTO
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
FROM   @spActiveUserTaskDTO TDTO
JOIN @perUsers perfU ON perfU.PerformedUserId=TDTO.PerformedUserId


-- Update Advice Case & Task Status Details
UPDATE @spActiveUserTaskDTO
SET
    TaskStatus = G.Name
  , CaseRef = I.CaseRef
FROM   @spActiveUserTaskDTO TDTO
LEFT JOIN CRM..TRefTaskStatus G
ON
    G.RefTaskStatusId = TDTO.RefTaskStatusId
LEFT JOIN CRM..TAdviceCase I
ON
    I.AdviceCaseId = TDTO.AdviceCaseId;

-- Update Client & Join Client Information
UPDATE @spActiveUserTaskDTO
SET
    ClientName = CASE WHEN
    J.CRMContactType = 1 THEN J.FirstName + ' ' + J.LastName WHEN
    J.CRMContactType = 2 THEN J.CorporateName WHEN
    J.CRMContactType = 3 THEN J.CorporateName
                 END
  , ClientPartyId = J.CRMContactId
  , JointClientName = CASE WHEN
    JJ.CRMContactType = 1 THEN JJ.FirstName + ' ' + JJ.LastName WHEN
    JJ.CRMContactType = 2 THEN JJ.CorporateName WHEN
    JJ.CRMContactType = 3 THEN JJ.CorporateName
                      END
  , JointClientPartyId = JJ.CRMContactId
FROM   @spActiveUserTaskDTO TDTO
LEFT JOIN CRM..TCRMContact J
ON
    J.CRMContactId = TDTO.CRMContactId
LEFT JOIN CRM..TCRMContact JJ
ON
    JJ.CRMContactId = TDTO.JointCRMContactId;

--Update the IsDocument Flag if Task has any associated documents.  
UPDATE  @spActiveUserTaskDTO
SET
    IsDocumentExist = 1
FROM
(
    SELECT
        A.TaskId
    FROM @spActiveUserTaskDTO A
    LEFT JOIN DocumentManagement..TDocument TD
    ON
    TD.EntityId = A.TaskId
    AND
        TD.EntityType = 5
    WHERE
        TD.IndigoClientId = @TenantId
    GROUP BY
        A.TaskId
    HAVING
        COUNT(TD.EntityId) > 0
) Doc
INNER JOIN @spActiveUserTaskDTO B
ON
    Doc.TaskId = B.TaskId;

--update the IsBillable flag if task is linked with any fees
INSERT @TFeetoTask
SELECT DISTINCT TaskId 
FROM	PolicyManagement..TFeetoTask
WHERE TenantId = @TenantId

UPDATE @spActiveUserTaskDTO
SET IsBillable = 1
FROM   @spActiveUserTaskDTO A
INNER JOIN	@TFeetoTask FT 
ON	A.TaskId	= FT.TaskId 



INSERT INTO @tmpActiveUserTaskPlanTable
(
    TaskId
  , PlanTypeName
  , PlanTypeId
  , PlanTypeProdSubTypeName
  , ProviderName
  , SolicitorName
  , PolicyBusinessId
)
SELECT DISTINCT
    A.TaskId
  , PT.PlanTypeName + ' (' + PC.CorporateName + ')' AS PlanTypeName
  , PB.PolicyBusinessId AS                             PlanTypeId
  , CASE WHEN PSub.ProdSubTypeName IS NULL THEN PT.PlanTypeName
                           ELSE PT.PlanTypeName + ' (' + PSub.
                           ProdSubTypeName + ')'
    END AS                                             PlanTypeProdSubTypeName
  , PC.CorporateName
  , NULL AS                                            SolicitorName
  , PB.PolicyBusinessId
FROM       @spActiveUserTaskDTO                         A
INNER JOIN PolicyManagement..TPolicyBusiness            PB
ON
    PB.PolicyBusinessId = A.PolicyId
LEFT JOIN PolicyManagement..TPolicyDetail               PD
ON
    PD.PolicyDetailId = PB.PolicyDetailId
LEFT JOIN PolicyManagement..TPlanDescription            PS
ON
    PS.PlanDescriptionId = PD.PlanDescriptionId
LEFT JOIN PolicyManagement..TRefPlanType2ProdSubType    RP
ON
    RP.RefPlanType2ProdSubTypeId = PS.RefPlanType2ProdSubTypeId
LEFT JOIN PolicyManagement..TRefPlantype                PT
ON
    PT.RefPlanTypeId = RP.RefPlanTypeId
LEFT JOIN PolicyManagement..TRefProdProvider            PP
ON
    PP.RefProdProviderId = PS.RefProdProviderId
LEFT JOIN CRM..TCRMContact                              PC
ON
    PC.CRMContactId = PP.CRMContactId
LEFT JOIN policymanagement.dbo.TProdSubType AS          PSub
ON
    PSub.ProdSubTypeId = RP.ProdSubTypeId
WHERE
    PB.IndigoClientId = @TenantId
GROUP BY
    TaskId
  , PT.PlanTypeName
  , PlanTypeId
  , PC.CorporateName
  , PB.PolicyBusinessId
  , PSub.ProdSubTypeName;

-- lets get data for the emails  
INSERT INTO @spActiveUserTaskDTO
(
    OrganiserActivityId
  , TaskId
  , SequentialRef
  , PriorityName
  , DueDate
  , Timezone
  , Subject
  , AssignedUserId
  , AssignedUser
  , AssignedToUserId
  , AssignedToUser
  , TaskStatus
  , CaseRef
  , ClientName
  , ClientPartyId
  , RoleId
  , RoleName
  , PolicyId
  , FeeId
  , RetainerId
  , OpportunityId
  , AdviceCaseId
  , ActivityType
  , StartDate
  , TaskType
  , PlanTypeName
  , IsDocumentExist
  , PlanTypeId
  , DateCompleted
  , PerformedUserName
  , UpdatedByUserId
  , AdviceCaseName
  , CreatedDate
)
SELECT DISTINCT
    A.OrganiserActivityId
  , NULL
  , 'N/A'
  , NULL
  , K.SentDate
  , NULL
  , K.Subject
  , M.UserId
  , L.FirstName + ' ' + L.LastName
  , M.UserId
  , L.FirstName + ' ' + L.LastName
  , CASE WHEN
    EO.EntityOrganiserActivityId > 0 THEN 'Complete'
                          ELSE 'Incomplete'
    END AS TaskStatus
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , 'Email'
  , NULL
  , 'Email'
  , NULL
  , CASE WHEN
    TA.AttachmentId > 0 THEN 1
    ELSE 0
    END AS IsDocumentExist
  , NULL
  , k.SentDate
  , L.FirstName + ' ' + L.LastName
  , A.UpdatedByUserId
  , AC.CaseName
  , A.CreatedDate
FROM        dbo.TOrganiserActivity          A
JOIN        CRM..TEmail                     K
ON
    K.OrganiserActivityId = A.OrganiserActivityId
LEFT JOIN   CRM..TEntityOrganiserActivity   EO
ON
    A.OrganiserActivityId = EO.OrganiserActivityId
LEFT JOIN CRM..TCRMContact                  L
ON
    L.CRMContactId = K.OwnerPartyId
LEFT JOIN ADMINISTRATION..TUser             M
ON
    M.CRMContactId = L.CRMContactId
LEFT JOIN CRM..TAttachment                  TA
ON
    TA.EmailId = K.EmailId
LEFT JOIN CRM..TAdviceCase AC ON A.AdviceCaseId = AC.AdviceCaseId
--Check for Tenant  
WHERE
    M.IndigoClientId = @TenantId
--Records for User if Party Id is 0  
AND
    M.UserId = @UserId
AND
    A.CompleteFG = 1
AND
(
    k.SentDate BETWEEN @StartDate AND @EndDate
OR
    @StartDate IS NULL
AND
    k.SentDate <= @EndDate
OR
    @EndDate IS NULL
AND
    k.SentDate >= @StartDate
OR
    @StartDate IS NULL
AND
    @EndDate IS NULL);

UPDATE @spActiveUserTaskDTO
SET
    ActivityType = ActivityType + ' (' + dbo.FnGetRecurrenceActivityType (AR.RFCCode) + ')'
FROM        @spActiveUserTaskDTO    A
INNER JOIN  dbo.TActivityRecurrence AR
ON
    AR.OrganiserActivityId = A.OrganiserActivityId;

-- lets return the data set
SELECT
    A.OrganiserActivityId
  , A.TaskId
  , A.SequentialRef
  , A.PriorityName
  , A.DueDate
  , A.Timezone
  , A.Subject
  , A.AssignedUserId
  , A.AssignedUser
  , A.AssignedToUserId
  , A.AssignedToUser
  , A.TaskStatus
  , A.CaseRef
  , A.ClientName
  , A.ClientPartyId
  , A.JointClientName
  , A.JointClientPartyId
  , CAST('TRUE' AS BIT) AS CompleteFG
  , A.RoleId
  , A.RoleName
  , A.PolicyId
  , A.FeeId
  , A.RetainerId
  , A.OpportunityId
  , A.AdviceCaseId
  , A.ActivityType
  , @TenantId AS            IndigoClientId
  , A.EventListName
  , A.StartDate
  , A.TaskType
  , PlanTypeName = NULL
  , A.IsDocumentExist
  , PlanTypeId = NULL
  , A.IsBillable
  , A.DateCompleted
  , A.ActivityOutcomeName
  , A.PerformedUserName
  , ProviderName = NULL
  , SolicitorName = NULL
  , PlanTypeProdSubTypeName = NULL
  , A.UpdatedByUserId
  , AdviceCaseName
  , A.CreatedDate
FROM   @spActiveUserTaskDTO A
WHERE A.PolicyId IS NULL

UNION ALL

SELECT
    A.OrganiserActivityId
  , A.TaskId
  , A.SequentialRef
  , A.PriorityName
  , A.DueDate
  , A.Timezone
  , A.Subject
  , A.AssignedUserId
  , A.AssignedUser
  , A.AssignedToUserId
  , A.AssignedToUser
  , A.TaskStatus
  , A.CaseRef
  , A.ClientName
  , A.ClientPartyId
  , A.JointClientName
  , A.JointClientPartyId
  , CAST('TRUE' AS BIT) AS CompleteFG
  , A.RoleId
  , A.RoleName
  , A.PolicyId
  , A.FeeId
  , A.RetainerId
  , A.OpportunityId
  , A.AdviceCaseId
  , A.ActivityType
  , @TenantId AS            IndigoClientId
  , A.EventListName
  , A.StartDate
  , A.TaskType
  , B.PlanTypeName
  , A.IsDocumentExist
  , B.PlanTypeId
  , A.IsBillable
  , A.DateCompleted
  , A.ActivityOutcomeName
  , A.PerformedUserName
  , B.ProviderName
  , B.SolicitorName
  , B.PlanTypeProdSubTypeName
  , A.UpdatedByUserId
  , A.AdviceCaseName
  , A.CreatedDate
FROM        @spActiveUserTaskDTO        A
INNER JOIN  @tmpActiveUserTaskPlanTable B
ON
    A.Taskid = B.TaskId
AND
    A.PolicyId IS NOT NULL
ORDER BY
    DueDate ASC;

GO