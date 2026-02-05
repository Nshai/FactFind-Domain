USE CRM
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date    Modifier        Issue       Description
----    ---------       -------     -------------
20230113 Nick Fairway   DEF-11080   Performance issue. Post SDA-430 release
20220624 Nick Fairway   COPS-10993  Performance issue. Inconsistent performance  - optimize for @CurrentUserDateTime for unknown and correct param types.
20211020 Nick Fairway   SDA-77      Performance improvement with reduced indices
20191024 Nick Fairway   IP-63813    Performance issue. Inconsistent performance  - looks like parameter sniffing so optimize for unknown.
*/
CREATE PROCEDURE dbo.SpCustomDashboardRetrieveclientKeyFacts
    @userId int, -- this parameter is not used!
    @cid    int,
    @CurrentUserDateTime datetime
AS
DECLARE     @cid_Local                  int         = @cid,
            @CurrentUserDateTime_Local  datetime    = @CurrentUserDateTime;-- OPTIMIZE FOR UNKNOWN (hidden trick of using local variables rather than expilicly using the option)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    -- concurrency here over accuracy as this is the dashboard.
SET NOCOUNT ON

DECLARE @FactFindStatus varchar(50), @FactFindDate datetime, @FactFindCompletedDate datetime,
    @LastAppointmentDate datetime, @LastAppointmentDesc varchar(255), @NextAppointmentDate datetime, @NextAppointmentDesc varchar(255),
    @LastActivityDate datetime, @LastActivityDesc varchar(255), @AdviserName varchar(255), @CampaignType varchar(255), @CampaignSource varchar(255),
    @ClientServiceStatus varchar(255), @CRMContactType tinyint, @Introducers varchar(MAX) = '', @CampaignDescription varchar(255),
    @ServAdminName varchar(255), @ParaplannerName varchar(255),@ClientServiceStatusDate datetime, @FactFindTimezone varchar(100),
    @LastAppointmentTimezone varchar(100), @NextAppointmentTimezone varchar(100), @LastActivityTimezone varchar(100),
    @TenantId int, @ClientSegment varchar(100)

--advisername & campaign data & service status & client segment.
SELECT
    @AdviserName                = c.CurrentAdviserName,
    @CampaignType               = isnull(ct.CampaignType,''),
    @CampaignSource             = isnull(tc.CampaignName,''),
    @CampaignDescription        = isnull(cd.Description,''),
    @ClientServiceStatus        = isnull(s.ServiceStatusName,''),
    @ClientServiceStatusDate    = c.ServiceStatusStartDate,
    @CRMContactType = CRMContactType,
    @TenantId = c.IndClientId,
    @ClientSegment = isnull(cs.ClientSegmentName,'')
FROM        dbo.TCRMContact         c
LEFT JOIN   dbo.TCampaignData       cd
ON  cd.CampaignDataId       = c.CampaignDataId
LEFT JOIN   dbo.TCampaign           tc
ON  tc.CampaignId           = cd.CampaignId
LEFT JOIN   dbo.TCampaignType       ct
ON  ct.CampaignTypeId       = tc.CampaignTypeId
LEFT JOIN   dbo.TRefServiceStatus   s
ON  s.IndigoClientId        = c.IndClientId
AND s.RefServiceStatusId    = c.RefServiceStatusId
LEFT JOIN TRefClientSegment cs ON cs.RefClientSegmentId = c.RefClientSegmentId
WHERE c.CRMContactId = @cid_Local

--Servicing Administrator and Paraplanner
SELECT     @ServAdminName      = isnull(csa.FirstName+' '+csa.LastName,'') ,
        @ParaplannerName    = isnull(csp.FirstName+' '+csp.LastName,'')
FROM        dbo.TCRMContact             c
LEFT JOIN   dbo.TCRMContactExt          cext
ON  cext.CRMContactId   =c.CRMContactId
LEFT JOIN   Administration..TUser       usa
ON  usa.UserId          =cext.ServicingAdminUserId
LEFT JOIN   dbo.TCRMContact             csa
ON  csa.CRMContactId    =usa.CRMContactId
LEFT JOIN   Administration..TUser   usp
ON  usp.UserId          =cext.ParaplannerUserId
LEFT JOIN   dbo.TCRMContact             csp
ON  csp.CRMContactId    =usp.CRMContactId
WHERE c.CRMContactId    = @cid_Local

-- Fact Find PDF Dates
SELECT TOP 1
     @FactFindStatus = dv.Status,
     @FactFindDate = dv.createddate
FROM    factfind..tfactfinddocument         ffd
JOIN    documentmanagement..tdocversion     dv
ON  dv.docVersionId     = ffd.DocVersionid
JOIN    documentmanagement..tdocument       d
ON  d.documentid        = dv.documentid
JOIN    documentmanagement..tdocumentowner  do on do.documentid = d.documentid
WHERE do.CRMContactId   = @cid_Local and dv.IndigoClientId = @TenantId and d.IndigoClientId = @TenantId
ORDER BY dv.createdDate DESC

-- Fact Find Completed Date
DECLARE @PrimaryCrmContactId bigint

SELECT @PrimaryCrmContactId = CRMContactId1 FROM factfind..TFactFind
WHERE (CRMContactId1 = @cid_Local or CRMContactId2 = @cid_Local)

SELECT @FactFindCompletedDate = CompletedDate
FROM FactFind..TDeclaration
WHERE CRMContactId = @PrimaryCrmContactId AND @CRMContactType = 1 -- Only for personal clients.

-- Get Fact Find completed date from the task if it has not been found.
IF @FactFindCompletedDate IS NULL
BEGIN
DECLARE @RefSystemEventId bigint, @RefSystemEvent varchar(255) = 'Date Fact Find Completed';
    SELECT @RefSystemEventId = RefSystemEventId
    FROM CRM..TRefSystemEvent
    WHERE Identifier = @RefSystemEvent

    SELECT TOP 1 @FactFindCompletedDate = DateCompleted, @FactFindTimezone = Timezone
    FROM
        CRM..TTask A
        JOIN CRM..TOrganiserActivity B On A.TaskId = B.TaskId
        JOIN CRM..TActivityCategory2RefSystemEvent C ON B.ActivityCategoryId = C.ActivityCategoryId
    WHERE A.IndigoClientId = @TenantId AND
        C.RefSystemEventId = @RefSystemEventId
        AND A.CRMContactId = @cid_Local
        AND B.CRMContactId = @cid_Local
        AND B.CompleteFg = 1
    ORDER BY A.TaskId DESC
END

SELECT
    oa.TaskId,
    oa.AppointmentId,
    oa.CompleteFG
INTO
    #TasksAndAppointments
FROM
    torganiseractivity oa
    JOIN tactivitycategory ac on ac.ActivityCategoryId = oa.ActivityCategoryId
    JOIN tactivitycategory2refsystemevent ac2rse on ac2rse.activitycategoryid = ac.activitycategoryid
WHERE
    (oa.crmcontactid = @cid_Local OR oa.IndigoClientId = @TenantId AND oa.JointCRMContactId = @cid_Local)
    AND ac2rse.refsystemeventid = 1
    AND (TaskId IS NOT NULL OR AppointmentId IS NOT NULL)

-- last appointment
SELECT TOP 1
    @LastAppointmentDesc = [Subject],
    @LastAppointmentDate = DueDate,
	@LastAppointmentTimezone = Timezone
FROM (
    -- Appts where client is primary and secondary
    SELECT
        T.[Subject],
        ISNULL(t.duedate, t.startdate) AS DueDate,
        Timezone
    FROM
        #TasksAndAppointments TA
        JOIN ttask t on t.taskid = TA.taskid
    WHERE T.IndigoClientId = @TenantId AND
        ((t.DueDate is null and startdate < @CurrentUserDateTime_Local) or (duedate < @CurrentUserDateTime_Local))

    UNION ALL
    SELECT
        A.[Subject],
        A.StartTime,
        Timezone
    FROM
        #TasksAndAppointments TA
        JOIN tappointment a on a.appointmentid = TA.AppointmentId
    WHERE
        a.StartTime < @CurrentUserDateTime_Local
) AS Appointments
ORDER BY DueDate DESC

-- Next appointment
SELECT TOP 1
    @NextAppointmentDesc = [Subject],
    @NextAppointmentDate = DueDate,
    @NextAppointmentTimezone = Timezone
FROM (
    -- Appts where client is primary and secondary
    SELECT
        T.[Subject],
        ISNULL(t.duedate, t.startdate) AS DueDate,
        Timezone
    FROM
            #TasksAndAppointments   TA
    JOIN    dbo.ttask               t ON t.taskid = TA.taskid
    WHERE T.IndigoClientId = @TenantId AND
        ((t.DueDate IS NULL AND startdate > @CurrentUserDateTime_Local) OR (duedate > @CurrentUserDateTime_Local))
        AND ISNULL(t.RefTaskStatusId,0) <> 2

    UNION ALL
    SELECT
        A.[Subject],
        A.StartTime,
        Timezone
    FROM
            #TasksAndAppointments   TA
    JOIN    dbo.tappointment        a
    ON  a.appointmentid = TA.appointmentid
    WHERE
        a.StartTime > @CurrentUserDateTime_Local
    AND TA.CompleteFG = 0

) AS Appointments
ORDER BY DueDate ASC

-- last activity
SELECT TOP 1 @LastActivityDate = t.DateCompleted, @LastActivityTimezone = Timezone
FROM    dbo.TTask               t
JOIN    dbo.torganiseractivity  oa
ON  oa.taskId = t.TaskId
WHERE oa.IndigoClientId = @TenantId AND oa.CompleteFg = 1
AND (oa.CRMContactId = @cid_Local OR oa.JointCRMContactId = @cid_Local)
ORDER BY t.DateCompleted desc

 -- last activity desc    
SELECT TOP(1) @LastActivityDesc = [Subject]
FROM    dbo.TTask               t
JOIN    dbo.torganiseractivity  oa
ON  oa.taskId = t.TaskId
WHERE  oa.IndigoClientId = @TenantId AND (oa.CRMContactId = @cid_Local OR oa.JointCRMContactId = @cid_Local)
AND     oa.CompleteFG=1
ORDER BY t.DateCompleted DESC

 --Introducers
DECLARE @Delimiter  VARCHAR (5) = ', '

SELECT @Introducers = @Introducers +
CASE TCRM.CRMContactType
    WHEN 1 THEN ISNULL(TCRM.FirstName,'') + ' ' + ISNULL(TCRM.LastName,'')
    ELSE        ISNULL(TCRM.CorporateName,'')
END + @Delimiter
FROM        Commissions.dbo.TSplitTemplate  TST
INNER JOIN  crm..TIntroducer                TI
ON  TST.PaymentEntityCRMId  = TI.CRMContactId
INNER JOIN  crm..TCRMContact                TCRM
ON TCRM.CRMContactId        = TI.CRMContactId
WHERE ClientCRMContactId    = @cid_Local
ORDER BY
    CASE TCRM.CRMContactType WHEN 1 THEN TCRM.FirstName ELSE TCRM.CorporateName END,
    CASE TCRM.CRMContactType WHEN 1 THEN TCRM.LastName  ELSE ' ' END

SELECT @Introducers = SUBSTRING(RTRIM(LTRIM(@Introducers)), 0, LEN(@Introducers))

SELECT
    isnull(@FactFindStatus,'')                          AS FactFindStatus,
    @FactFindDate                                       AS FactFindDate,   
    @FactFindCompletedDate                              AS FactFindCompletedDate,
    @LastAppointmentDate                                AS LastAppointmentDate,
    isnull(@LastAppointmentDesc,'')                     AS LastAppointmentDesc,
    @NextAppointmentDate                                AS NextAppointmentDate,
    isnull(@NextAppointmentDesc,'')                     AS NextAppointmentDesc,
    isnull(@AdviserName,'')                             AS AdviserName,
    isnull(@CampaignType,'')                            AS CampaignType,
    isnull(@CampaignSource,'')                          AS CampaignSource,
    isnull(@CampaignDescription,'')                     AS CampaignDescription,
    @LastActivityDate                                   AS LastActivityDate,   
    @LastActivityDesc                                   AS LastActivityDesc,  
    @ClientServiceStatus                                AS ClientServiceStatus,
    @Introducers                                        AS Introducers,
    isnull(@ServAdminName,'')                           AS ServicingAdminName,
    isnull(@ParaplannerName,'')                         AS ParaplannerName,
    @ClientServiceStatusDate                            AS ClientServiceStatusDate,
    @cid_Local                                          AS CrmContactId,
    @FactFindTimezone                                   AS FactFindTimezone,
    @LastAppointmentTimezone                            AS LastAppointmentTimezone,
    @NextAppointmentTimezone                            AS NextAppointmentTimezone,
    @LastActivityTimezone                               AS LastActivityTimezone,
    @ClientSegment                                      AS ClientSegment
GO

