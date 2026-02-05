USE [CRM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue           Description
----        ---------       -------         -------------
20200131    Nick Fairway    IP-51896        Created by refactoring spNIOCustomRetrieveTaskDTOExtended
20250221    Nirmatt Gopal   CRMPM-16896     Redirect and Filter New Assigned Tasks for User View
20250826    Geethu N S      IOPM-5388      SQL Changes to Hide the "Save as Doc" Button in IO
*/
CREATE PROCEDURE dbo.spNIOCustomRetrievePartyTaskDTOExtended 
    @UserId int, 
	@TenantId int,
	@PartyId int=0, 
	@Range tinyint=0, -- Historic = 0, Active = 1, All=2
	@GetAppointments tinyint =0
AS
SET Transaction Isolation Level read uncommitted  
  
/* Create Temporary Table as we need to deal with three quite distinct entities  
- Tasks, Appointments, Emails  
I did this with a join and it was quite long winded and slow*/  
declare @CompleteFG bit
DECLARE @DateCompletedStart DATETIME;
DECLARE @DateCompletedEnd DATETIME;
--Adjust end date to the end of the day
DECLARE @assUsers TABLE(AssignedToUserId int PRIMARY KEY, AssignedToUser varchar(255))
DECLARE @perUsers TABLE(PerformedUserId int, PerformedUserName varchar(255))


CREATE TABLE #TaskTable
(
    TaskId                 INT
,   SequentialRef          VARCHAR(50)
,   DueDate                DATETIME
,   Timezone               VARCHAR(100)
,   Subject                VARCHAR(1000)
,   IndigoClientId         INT
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
,   RoleName               VARCHAR(1000)
,   UpdatedByUserId        INT
,   AdviceCaseName         VARCHAR(255)
,   CreatedDate            DATETIME
);

CREATE TABLE #spNIOCustomRetrieveTaskDTOTable
(
    OrganiserActivityId    INT INDEX IX1 NONCLUSTERED
,   TaskId                 INT
,   SequentialRef          VARCHAR(50)
,   PriorityName           VARCHAR(255)
,   DueDate                DATETIME
,   Timezone               VARCHAR(100)
,   Subject                VARCHAR(1000)
,   AssignedUserId         INT
,   AssignedUser           VARCHAR(255)
,   AssignedToUserId       INT
,   AssignedToUser         VARCHAR(255)
,   TaskStatus             VARCHAR(255)
,   CaseRef                VARCHAR(50)
,   ClientName             VARCHAR(255)
,   ClientPartyId          INT
,   JointClientName        VARCHAR(255)
,   JointClientPartyId     INT
,   CompleteFG             BIT
,   RoleId                 INT
,   RoleName               VARCHAR(255)
,   PolicyId               INT
,   FeeId                  INT
,   RetainerId             INT
,   OpportunityId          INT
,   AdviceCaseId           INT
,   ActivityType           VARCHAR(255)
,   IndigoClientId         INT
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

CREATE TABLE #tmpTaskPlanTable
(
    TaskId                     INT
,   PlanTypeName               VARCHAR(255)
,   PlanTypeId                 INT
,   PlanTypeProdSubTypeName    VARCHAR(255)
,   ProviderName               VARCHAR(255)
,   SolicitorName              VARCHAR(255)
,   PolicyBusinessId           INT
);
if (@Range = 0)
BEGIN
  set @CompleteFG = 1
END
ELSE IF (@Range = 1)
BEGIN
  SET @CompleteFG = 0
END
 
 INSERT INTO #TaskTable
(
    TaskId
  , SequentialRef
  , DueDate
  , Timezone
  , Subject
  , IndigoClientId
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
  , A.IndigoClientId
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
FROM CRM..TTask                 A
LEFT JOIN administration..TRole R ON A.AssignedToRoleId = R.RoleId
JOIN CRM..TOrganiserActivity    H
ON
    A.TaskId = H.TaskId
LEFT JOIN CRM..TAdviceCase AC ON H.AdviceCaseId = AC.AdviceCaseId
WHERE
	A.IndigoClientId = @TenantId
AND
    H.IndigoClientId = @TenantId
AND
(
    H.CRMContactId = @PartyId
OR
    H.JointCRMContactId = @PartyId)
AND
(
    @CompleteFG IS NULL
OR
    H.CompleteFG = @CompleteFG)
AND
(
@DateCompletedEnd IS NULL
OR
    A.DateCompleted <= @DateCompletedEnd
OR
    @DateCompletedStart IS NULL
AND
    A.DateCompleted IS NULL)
AND
(
    @DateCompletedStart IS NULL
OR
    A.DateCompleted >= @DateCompletedStart);

DELETE A
FROM        #TaskTable      A
INNER JOIN  dbo.TCRMCOntact B
ON
    A.CRMCOntactID = B.CRMContactID
WHERE
    B.IsDeleted = 1;

-- lets get the data for the tasks  
INSERT INTO #spNIOCustomRetrieveTaskDTOTable
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
  , CompleteFG
  , RoleId
  , RoleName
  , PolicyId
  , FeeId
  , RetainerId
  , OpportunityId
  , AdviceCaseId
  , ActivityType
  , IndigoClientId
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
    --C.UserId As AssignedUserId,  
  , A.AssignedUserId
  , D.FirstName + ' ' + D.LastName AS AssignedUser
  , A.CompleteFG
  , A.AssignedToRoleId AS                           RoleId
  , A.RoleName AS                           RoleName
  , A.PolicyId
  , A.FeeId
  , A.RetainerId
  , A.OpportunityId
  , A.AdviceCaseId
  , 'Task'
  , A.IndigoClientId
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
FROM        #TaskTable          A
LEFT JOIN   dbo.TRefPriority    Pr
ON  Pr.RefPriorityId = A.RefPriorityId
LEFT JOIN Administration..Tuser C
ON  C.UserId = A.AssignedUserId
LEFT JOIN CRM..TCRMContact D
ON  D.CRMcontactId = C.CRMcontactId
LEFT JOIN CRM..TActivityCategory AC
ON  AC.ActivityCategoryId = A.ActivityCategoryId
LEFT JOIN CRM..TActivityOutcome AO
ON  AO.ActivityOutcomeId = A.ActivityOutcomeId
WHERE
    A.IndigoClientId = @TenantId
AND
    A.IndigoClientId = A.IndigoClientId;

-- Update the Table with AssignedToUser Values.
INSERT INTO @assUsers
SELECT DISTINCT AssignedToUserId, NULL 
FROM #spNIOCustomRetrieveTaskDTOTable
WHERE AssignedToUserId IS NOT NULL

UPDATE assU
SET AssignedToUser = (F.FirstName + ' ' + F.LastName)
FROM @assUsers assU
JOIN Administration..Tuser E on E.UserId=assU.AssignedToUserId 
JOIN CRM..TCRMContact F on F.CRMcontactId=E.CRMcontactId

UPDATE TDTO
SET AssignedToUser = assU.AssignedToUser
FROM   #spNIOCustomRetrieveTaskDTOTable TDTO
JOIN @assUsers assU on assU.AssignedToUserId=TDTO.AssignedToUserId



-- Update the Table with PerformedUserName Values.
INSERT INTO @perUsers
SELECT DISTINCT PerformedUserId, NULL 
FROM #spNIOCustomRetrieveTaskDTOTable
WHERE PerformedUserId IS NOT NULL

UPDATE perfU
SET PerformedUserName = (F.FirstName + ' ' + F.LastName)
FROM @perUsers perfU
JOIN Administration..Tuser E on E.UserId=perfU.PerformedUserId 
JOIN CRM..TCRMContact F on F.CRMcontactId=E.CRMcontactId

UPDATE TDTO
SET PerformedUserName = perfU.PerformedUserName
FROM   #spNIOCustomRetrieveTaskDTOTable TDTO
--Inner join #TaskTable A on TDTO.TaskId = A.TaskId
JOIN @perUsers perfU ON perfU.PerformedUserId=TDTO.PerformedUserId


-- Update Advice Case & Task Status Details
UPDATE #spNIOCustomRetrieveTaskDTOTable
SET TaskStatus = G.Name,  
    CaseRef = I.CaseRef
FROM   #spNIOCustomRetrieveTaskDTOTable TDTO
--Inner join #TaskTable A on TDTO.TaskId = A.TaskId
LEFT JOIN CRM..TRefTaskStatus G on G.RefTaskStatusId=TDTO.RefTaskStatusId  
LEFT JOIN CRM..TAdviceCase I on I.AdviceCaseId=TDTO.AdviceCaseId

-- Update Client & Join Client Information
UPDATE #spNIOCustomRetrieveTaskDTOTable
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
FROM   #spNIOCustomRetrieveTaskDTOTable TDTO
LEFT JOIN CRM..TCRMContact J
ON
    J.CRMContactId = TDTO.CRMContactId
LEFT JOIN CRM..TCRMContact JJ
ON
    JJ.CRMContactId = TDTO.JointCRMContactId;

--Update the IsDocument Flag if Task has any associated documents.  

UPDATE #spNIOCustomRetrieveTaskDTOTable
SET
    IsDocumentExist = 1
FROM
(
    SELECT
        A.TaskId
    FROM
                #spNIOCustomRetrieveTaskDTOTable    A
    LEFT JOIN   DocumentManagement..TDocument       TD
    ON  TD.EntityId = A.TaskId
    AND
        TD.EntityType = 5
    WHERE
        A.IndigoClientId = @TenantId
    AND
        TD.IndigoClientId = @TenantId
    GROUP BY
        A.TaskId
    HAVING
        COUNT(TD.EntityId) > 0
) Doc
INNER JOIN #spNIOCustomRetrieveTaskDTOTable B
ON  Doc.TaskId = B.TaskId;

--update the IsBillable flag if task is linked with any fees
UPDATE #spNIOCustomRetrieveTaskDTOTable
SET
    IsBillable = 1
FROM        #spNIOCustomRetrieveTaskDTOTable A
INNER JOIN  PolicyManagement..TFeetoTask FT
ON  A.TaskId    = FT.TaskId
AND FT.TenantId = @TenantId;

/* Create temporary table to retrieve plan related information as with the last retrieval we are facing perfomrance   
issue  
*/



INSERT INTO #tmpTaskPlanTable
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
  , CASE
        WHEN PSub.ProdSubTypeName IS NULL
        THEN PT.PlanTypeName
        ELSE PT.PlanTypeName + ' (' + PSub.ProdSubTypeName + ')'
    END AS                                             PlanTypeProdSubTypeName
  , PC.CorporateName
  , NULL AS                                            SolicitorName
  , PB.PolicyBusinessId
FROM        #spNIOCustomRetrieveTaskDTOTable    A
INNER JOIN  PolicyManagement..TPolicyBusiness   PB
    ON
    PB.PolicyBusinessId = A.PolicyId
LEFT JOIN PolicyManagement..TPolicyDetail PD
    ON
    PD.PolicyDetailId = PB.PolicyDetailId
LEFT JOIN PolicyManagement..TPlanDescription PS
    ON
    PS.PlanDescriptionId = PD.PlanDescriptionId
LEFT JOIN PolicyManagement..TRefPlanType2ProdSubType RP
    ON
    RP.RefPlanType2ProdSubTypeId = PS.RefPlanType2ProdSubTypeId
LEFT JOIN PolicyManagement..TRefPlantype PT
    ON
    PT.RefPlanTypeId = RP.RefPlanTypeId
LEFT JOIN PolicyManagement..TRefProdProvider PP
    ON
    PP.RefProdProviderId = PS.RefProdProviderId
LEFT JOIN CRM..TCRMContact PC
    ON
    PC.CRMContactId = PP.CRMContactId
LEFT JOIN policymanagement.dbo.TProdSubType AS PSub
    ON
    PSub.ProdSubTypeId = RP.ProdSubTypeId
WHERE
    PB.IndigoClientId = A.IndigoClientId
GROUP BY
    TaskId
  , PT.PlanTypeName
  , PlanTypeId
  , PC.CorporateName
  , PB.PolicyBusinessId
  , PSub.ProdSubTypeName;

----------------------------------------------------------------------------------

	INSERT INTO #spNIOCustomRetrieveTaskDTOTable
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
		  , CompleteFG
		  , RoleId
		  , RoleName
		  , PolicyId
		  , FeeId
		  , RetainerId
		  , OpportunityId
		  , AdviceCaseId
		  , ActivityType
		  , IndigoClientId
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
	SELECT
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
	  , CASE
			WHEN
		EO.EntityOrganiserActivityId > 0
			THEN 'Complete'
			ELSE 'Incomplete'
		END AS TaskStatus
	  , NULL
	  , NULL
	  , NULL
	  , A.CompleteFG
	  , T.AssignedToRoleId
	  , T.RoleName
	  , NULL
	  , NULL
	  , NULL
	  , NULL
	  , NULL
	  , 'Email'
	  , A.IndigoClientId
	  , NULL
	  , 'Email'
	  , NULL
	  , CASE
			WHEN
		TA.AttachmentId > 0
			THEN 1
			ELSE 0
		END AS IsDocumentExist
	  , NULL
	  , k.SentDate
	  , L.FirstName + ' ' + L.LastName
	  , A.UpdatedByUserId
	  , AC.AdviceCaseId
      , A.CreatedDate
	FROM        dbo.TOrganiserActivity          A
	LEFT JOIN #TaskTable T ON A.TaskId = T.TaskId
	JOIN        CRM..TEmail                     K
	ON  K.OrganiserActivityId = A.OrganiserActivityId
	LEFT JOIN   CRM..TEntityOrganiserActivity   EO
	ON  A.OrganiserActivityId = EO.OrganiserActivityId
	LEFT JOIN   CRM..TCRMContact                L
	ON  L.CRMContactId = K.OwnerPartyId
	LEFT JOIN   ADMINISTRATION..TUser           M
	ON  M.CRMContactId = L.CRMContactId
	LEFT JOIN   CRM..TAttachment                TA
	ON  TA.EmailId = K.EmailId
	LEFT JOIN CRM..TAdviceCase AC ON A.AdviceCaseId = AC.AdviceCaseId
	--Check for Tenant  
	WHERE
		M.IndigoClientId = @TenantId
	--Records for Party.  
	AND
		@PartyId > 0
	AND
		EO.EntityId = @PartyId
	AND
	(
	@DateCompletedEnd IS NULL
	OR
		k.SentDate <= @DateCompletedEnd
	OR
	@DateCompletedStart IS NULL
	AND
	k.SentDate IS NULL)
	AND
	(
	@DateCompletedStart IS NULL
	OR
		k.SentDate >= @DateCompletedStart);
	-- this was better than including the Complete bit field in the clauses above since the bit cannot be indexed  

IF @Range = 0 -- this is histroic stuff so complete  
    DELETE FROM #spNIOCustomRetrieveTaskDTOTable
    WHERE
        CompleteFG = 0;

IF @Range = 1 -- this is currently active so no complete stuff  
    DELETE FROM #spNIOCustomRetrieveTaskDTOTable
    WHERE
        CompleteFG = 1;
IF @GetAppointments = 1
BEGIN
    -- lets get data for the Appointments      
    INSERT INTO #spNIOCustomRetrieveTaskDTOTable
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
      , JointClientName
      , JointClientPartyId
      , CompleteFG
      , RoleId
      , RoleName
      , PolicyId
      , FeeId
      , RetainerId
      , OpportunityId
      , AdviceCaseId
      , ActivityType
      , IndigoClientId
      , StartDate
      , TaskType
      , PlanTypeName
      , IsDocumentExist
      , PlanTypeId
      , DateCompleted
      , PerformedUserName
      , ActivityOutcomeName
      , UpdatedByUserId
      , AdviceCaseName
      , CreatedDate
    )
    SELECT DISTINCT
        A.OrganiserActivityId
      , C.AppointmentId
      , NULL
      , 'N/A'
      , C.EndTime
	  , C.Timezone
      , C.Subject
      , ISNULL(A.CreatedByUserId, C.CreatedByUserId)
      , D.FirstName + ' ' + D.LastName
      , D.CRMContactId
      , D.FirstName + ' ' + D.LastName
      , CASE
            WHEN
        A.CompleteFG = 0
            THEN 'Incomplete'
            ELSE 'Complete'
        END AS TaskStatus
      , NULL
      , NULL
      , A.CRMContactId
      , NULL
      , A.JointCRMContactId
      , A.CompleteFG
      , T.AssignedToRoleId
      , T.RoleName
      , NULL
      , NULL
      , NULL
      , NULL
      , NULL
      , 'Diary'
      , A.IndigoClientId
      , C.StartTime
      , B.Name
      , NULL
      , NULL
      , NULL
      , C.EndTime
      , D.FirstName + ' ' + D.LastName
      , AO.ActivityOutcomeName
      , A.UpdatedByUserId
	  , AC.CaseName
      , A.CreatedDate
    FROM            CRM.dbo.TOrganiserActivity  A
    LEFT JOIN #TaskTable T ON T.TaskId = A.TaskId
    LEFT OUTER JOIN CRM.dbo.TActivityCategory   B
    ON
        A.ActivityCategoryId    = B.ActivityCategoryId
    INNER JOIN      CRM.dbo.TAppointment        C
    ON  A.AppointmentId         = C.AppointmentId
    LEFT OUTER JOIN CRM.dbo.TCRMContact         D
    ON  C.OrganizerCRMContactId = D.CRMContactId
    LEFT JOIN CRM..TActivityOutcome             AO
    ON  AO.ActivityOutcomeId    = C.ActivityOutcomeId
	LEFT JOIN CRM..TAdviceCase AC ON A.AdviceCaseId = AC.AdviceCaseId
    WHERE
    (
    A.CRMContactId = @PartyId
    OR
        A.JointCRMContactId = @PartyId)
    AND
        A.IndigoClientId = @TenantId
    AND
    (
    @CompleteFG IS NULL
    OR
        A.CompleteFG = CASE
                           WHEN
        @Range = 1
                           THEN 0
                           ELSE 1
                       END)
    AND
    (
    @DateCompletedEnd IS NULL
    OR
        C.EndTime <= @DateCompletedEnd
    OR
    @DateCompletedStart IS NULL
    AND
    C.EndTime IS NULL)
    AND
    (
    @DateCompletedStart IS NULL
    OR
        C.EndTime >= @DateCompletedStart);

END;

--### IO-15426
--lets get data for selected partyid as diary appointment attendees

INSERT INTO #spNIOCustomRetrieveTaskDTOTable
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
  , JointClientName
  , JointClientPartyId
  , CompleteFG
  , RoleId
  , RoleName
  , PolicyId
  , FeeId
  , RetainerId
  , OpportunityId
  , AdviceCaseId
  , ActivityType
  , IndigoClientId
  , StartDate
  , TaskType
  , PlanTypeName
  , IsDocumentExist
  , PlanTypeId
  , DateCompleted
  , PerformedUserName
  , ActivityOutcomeName
  , UpdatedByUserId
  , AdviceCaseName
  , CreatedDate
)
SELECT
    A.OrganiserActivityId
  , C.AppointmentId
  , NULL
  , 'N/A'
  , C.EndTime
  , C.Timezone
  , C.Subject
  , ISNULL(A.CreatedByUserId, C.CreatedByUserId)
  , D.FirstName + ' ' + D.LastName
  , D.CRMContactId
  , D.FirstName + ' ' + D.LastName
  , CASE
        WHEN
    A.CompleteFG = 0
        THEN 'Incomplete'
        ELSE 'Complete'
    END AS TaskStatus
  , NULL
  , NULL
  , A.CRMContactId
  , NULL
  , A.JointCRMContactId
  , A.CompleteFG
  , T.AssignedToRoleId
  , T.RoleName
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , 'Diary'
  , A.IndigoClientId
  , C.StartTime
  , B.Name
  , NULL
  , NULL
  , NULL
  , c.EndTime
  , D.FirstName + ' ' + D.LastName
  , AO.ActivityOutcomeName
  , A.UpdatedByUserId
  , AC.CaseName
  , A.CreatedDate
FROM            CRM.dbo.TOrganiserActivity  A
LEFT JOIN #TaskTable T ON T.TaskId = A.TaskId
LEFT OUTER JOIN CRM.dbo.TActivityCategory   B
ON  A.ActivityCategoryId = B.ActivityCategoryId
INNER JOIN      CRM.dbo.TAppointment        C
ON  A.AppointmentId = C.AppointmentId
INNER JOIN      CRM..TAttendees             att
ON  att.AppointmentId = C.AppointmentId
LEFT OUTER JOIN CRM.dbo.TCRMContact         D
ON  C.OrganizerCRMContactId = D.CRMContactId
LEFT JOIN       CRM..TActivityOutcome       AO
ON  AO.ActivityOutcomeId = C.ActivityOutcomeId
LEFT JOIN CRM..TAdviceCase AC ON A.AdviceCaseId = AC.AdviceCaseId
WHERE
    att.CRMContactId = @PartyId
AND
    A.IndigoClientId = @TenantId
AND
(
@CompleteFG IS NULL
OR
    A.CompleteFG = CASE
                       WHEN
    @Range = 1
                       THEN 0
                       ELSE 1
                   END)
AND
(
@DateCompletedEnd IS NULL
OR
    C.EndTime <= @DateCompletedEnd
OR
@DateCompletedStart IS NULL
AND
C.EndTime IS NULL)
AND
(
@DateCompletedStart IS NULL
OR
    C.EndTime >= @DateCompletedStart)
AND
    att.CRMContactId <> C.CRMContactId
    
UNION

SELECT
    A.OrganiserActivityId
  , C.AppointmentId
  , NULL
  , 'N/A'
  , C.EndTime
  , C.Timezone
  , C.Subject
  , ISNULL(A.CreatedByUserId, C.CreatedByUserId)
  , D.FirstName + ' ' + D.LastName
  , D.CRMContactId
  , D.FirstName + ' ' + D.LastName
  , CASE
        WHEN
    A.CompleteFG = 0
        THEN 'Incomplete'
        ELSE 'Complete'
    END AS TaskStatus
  , NULL
  , NULL
  , A.CRMContactId
  , NULL
  , A.JointCRMContactId
  , A.CompleteFG
  , T.AssignedToRoleId
  , T.RoleName
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , 'Diary'
  , A.IndigoClientId
  , C.StartTime
  , B.Name
  , NULL
  , NULL
  , NULL
  , c.EndTime
  , D.FirstName + ' ' + D.LastName
  , AO.ActivityOutcomeName
  , A.UpdatedByUserId
  , AC.CaseName
  , A.CreatedDate
FROM            CRM.dbo.TOrganiserActivity  A
LEFT JOIN #TaskTable T ON T.TaskId = A.TaskId
LEFT OUTER JOIN CRM.dbo.TActivityCategory   B
ON  A.ActivityCategoryId    = B.ActivityCategoryId
INNER JOIN      CRM.dbo.TAppointment        C
ON  A.AppointmentId         = C.AppointmentId
INNER JOIN      CRM..TAttendees             att
ON  att.AppointmentId       = C.AppointmentId
LEFT OUTER JOIN CRM.dbo.TCRMContact         D
ON  C.OrganizerCRMContactId = D.CRMContactId
LEFT JOIN       CRM..TActivityOutcome       AO
ON  AO.ActivityOutcomeId    = C.ActivityOutcomeId
LEFT JOIN CRM..TAdviceCase AC ON A.AdviceCaseId = AC.AdviceCaseId
WHERE
    A.JointCRMContactId = @PartyId
AND
    A.IndigoClientId = @TenantId
AND
(
@CompleteFG IS NULL
OR
    A.CompleteFG = CASE
                       WHEN
    @Range = 1
                       THEN 0
                       ELSE 1
                   END)
AND
(
@DateCompletedEnd IS NULL
OR
    C.EndTime <= @DateCompletedEnd
OR
@DateCompletedStart IS NULL
AND
C.EndTime IS NULL)
AND
(
@DateCompletedStart IS NULL
OR
    C.EndTime >= @DateCompletedStart);
--### Eof IO-15426

UPDATE #spNIOCustomRetrieveTaskDTOTable
SET
    ActivityType = ActivityType + ' (' + dbo.FnGetRecurrenceActivityType (AR.RFCCode) + ')'
FROM        #spNIOCustomRetrieveTaskDTOTable    A
INNER JOIN  dbo.TActivityRecurrence             AR
ON  AR.OrganiserActivityId = A.OrganiserActivityId;

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
  , A.CompleteFG
  , A.RoleId
  , A.RoleName
  , A.PolicyId
  , A.FeeId
  , A.RetainerId
  , A.OpportunityId
  , A.AdviceCaseId
  , A.ActivityType
  , A.IndigoClientId
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
INTO
    #spNIOCustomRetrieveTaskDTOTableJoined
FROM        #spNIOCustomRetrieveTaskDTOTable    A
INNER JOIN  #tmpTaskPlanTable                   B
ON
    A.Taskid = B.TaskId;

-- lets return the data set
SELECT *
FROM #spNIOCustomRetrieveTaskDTOTableJoined

UNION

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
  , A.CompleteFG
  , A.RoleId
  , A.RoleName
  , A.PolicyId
  , A.FeeId
  , A.RetainerId
  , A.OpportunityId
  , A.AdviceCaseId
  , A.ActivityType
  , A.IndigoClientId
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
  , A.AdviceCaseName
  , A.CreatedDate
FROM        #spNIOCustomRetrieveTaskDTOTable        A
LEFT JOIN   #spNIOCustomRetrieveTaskDTOTableJoined  X
ON
    A.OrganiserActivityId = x.OrganiserActivityId
WHERE x.OrganiserActivityId IS NULL
ORDER BY
    DueDate;