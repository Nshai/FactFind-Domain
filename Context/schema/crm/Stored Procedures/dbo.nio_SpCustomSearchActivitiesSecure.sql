SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO 

--drop PROCEDURE [dbo].[nio_SpCustomSearchActivitiesSecure]        
CREATE PROCEDURE [dbo].[nio_SpCustomSearchActivitiesSecure]        
 @IndigoClientId int,
 @RefPriorityId bigint = 0,        
 @Subject varchar(255) = '%',        
 @TaskRef varchar(255) = '%',        
 @AssignedToUserPartyId bigint = 0,        
 @AssignedByUserPartyId bigint = 0,        
 @AssignedToRoleId bigint = 0,        
 @RelatesToCRMContactId bigint = 0,        
 @RefTaskStatusId bigint = 0,        
 @AssignedToOption varchar(50) = '%',        
 @FromStartDate datetime = null,        
 @ToStartDate datetime  = null,        
 @StartDateWithin varchar(50) = null,        
 @FromDueDate datetime  = null,        
 @ToDueDate datetime  = null,
 @FromSentDateUtc datetime  = null,        
 @ToSentDateUtc datetime  = null,
 @CurrentUserDate datetime,				 
 @DueDateWithin varchar(50) = null,        
 @ActivityCategoryParentId bigint = null,    
 @ActivityCategoryId bigint = null,        
 @RefProdProviderId bigint = 0,    
 @ActivityType varchar(50) = null,        
 @_UserId bigint,                
 @_TopN int = 250,
 @ServicingAdviserId bigint = 0

AS         

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
     
DECLARE @AssignedToUserId bigint, @AssignedByUserId bigint, @CurrentUserPartyId bigint    
    
-- Here we check the 'Start Date Within' & 'Due Date Within' options and assign the From/To Start Date &    
-- From/To Due Date values accordingly. If these options are set, we ignore the individual date selections.    
IF (@StartDateWithin is not null)      
BEGIN    
     
    
 select @FromStartDate =    
 CASE @StartDateWithin    
  When 'LastWeek' THEN DATEADD(day, -7, @CurrentUserDate)    
  When 'LastMonth' THEN DATEADD(month, -1, @CurrentUserDate)    
  When 'LastQuarter' THEN DATEADD(month, -3, @CurrentUserDate)    
  When 'LastYear' THEN DATEADD(year, -1, @CurrentUserDate)    
  ELSE @CurrentUserDate    
 END    
    
 select @ToStartDate =    
 CASE @StartDateWithin    
  When 'NextWeek' THEN DATEADD(day, 7, @CurrentUserDate)    
  When 'NextMonth' THEN DATEADD(month, 1, @CurrentUserDate)    
  When 'NextQuarter' THEN DATEADD(month, 3, @CurrentUserDate)    
  When 'NextYear' THEN DATEADD(year, 1, @CurrentUserDate)   
  ELSE @CurrentUserDate    
 END    
END    

SET @FromStartDate = CAST(CAST(@FromStartDate as date) as datetime) --remove time part if any
SET @ToStartDate = CAST(CAST(@ToStartDate as date) as datetime) --remove time part if any
SET @ToStartDate = DATEADD(second,-1, DATEADD(day, 1, @ToStartDate)) --make time part = 23:59:59

	    
IF (@DueDateWithin is not null)      
BEGIN     
    
 select @FromDueDate =    
 CASE @DueDateWithin    
  When 'LastWeek' THEN DATEADD(day, -7, @CurrentUserDate)    
  When 'LastMonth' THEN DATEADD(month, -1, @CurrentUserDate)    
  When 'LastQuarter' THEN DATEADD(month, -3, @CurrentUserDate)    
  When 'LastYear' THEN DATEADD(year, -1, @CurrentUserDate)    
  ELSE @CurrentUserDate     
 END    
    
 select @ToDueDate =    
 CASE @DueDateWithin    
  When 'NextWeek' THEN DATEADD(day, 7, @CurrentUserDate)    
  When 'NextMonth' THEN DATEADD(month, 1, @CurrentUserDate)    
  When 'NextQuarter' THEN DATEADD(month, 3, @CurrentUserDate)    
  When 'NextYear' THEN DATEADD(year, 1, @CurrentUserDate)     
  ELSE @CurrentUserDate    
 END    

 select @FromSentDateUtc =    
 CASE @DueDateWithin    
  When 'LastWeek' THEN DATEADD(day, -7, GetDate())    
  When 'LastMonth' THEN DATEADD(month, -1, GetDate())    
  When 'LastQuarter' THEN DATEADD(month, -3, GetDate())    
  When 'LastYear' THEN DATEADD(year, -1, GetDate())    
  ELSE GetDate()     
 END    
    
 select @ToSentDateUtc =    
 CASE @DueDateWithin    
  When 'NextWeek' THEN DATEADD(day, 7, GetDate())    
  When 'NextMonth' THEN DATEADD(month, 1, GetDate())    
  When 'NextQuarter' THEN DATEADD(month, 3, GetDate())    
  When 'NextYear' THEN DATEADD(year, 1, GetDate())     
  ELSE GetDate()    
 END    
END  

SET @FromDueDate = CAST(CAST(@FromDueDate as date) as datetime) --remove time part if any
SET @ToDueDate = CAST(CAST(@ToDueDate as date) as datetime) --remove time part if any
SET @ToDueDate = DATEADD(second,-1, DATEADD(day, 1, @ToDueDate)) --make time part = 23:59:59
    
-- We need to negate the UserId for SuperUsers and SuperViewers to bypass the entity security    
IF EXISTS(SELECT 1 FROM Administration..TUser WHERE UserId = @_UserId AND (SuperUser = 1 OR SuperViewer = 1))    
 SELECT @_UserId = @_UserId * -1     
     
-- Get current user party Id (for securing emails)    
SELECT @CurrentUserPartyId = CRMContactId FROM Administration..TUser WHERE UserId = ABS(@_UserId)    
            
-- Convert the User Party Id's to User Ids.     
SELECT @AssignedToUserId = 0;    
 IF @AssignedToUserPartyId > 0    
 SELECT @AssignedToUserId = (SELECT UserId from Administration..TUser U where U.CRMContactId = @AssignedToUserPartyId)    
    
SELECT @AssignedByUserId = 0;    
IF @AssignedByUserPartyId > 0    
 SELECT @AssignedByUserId = (SELECT UserId from Administration..TUser U where U.CRMContactId = @AssignedByUserPartyId)         
    
If Object_Id('tempdb..#tmp_activities') Is Not Null        
 drop table #tmp_activities        
Create table #tmp_activities     
(TaskId int,EmailId bigint, AppointmentId bigint, OrganiserActivityId bigint,ActivityType varchar(50),IsDocumentExist bit,
	TenantId int, IsBillable bit,ServicingAdviserName varchar(200))
  
  
-- Limit rows returned?                
IF (@_TopN > 0) SET ROWCOUNT @_TopN
/*Important 03/16/2017
Using SET ROWCOUNT will not affect DELETE, INSERT, and UPDATE statements in a future release of SQL Server.
Avoid using SET ROWCOUNT with DELETE, INSERT, and UPDATE statements in new development work, and plan to modify applications that currently use it.
For a similar behavior, use the TOP syntax. For more information, see TOP (Transact-SQL).*/           
        
----------------------------------------------------------------------------------    
--Insert for Tasks    
----------------------------------------------------------------------------------    
if (@ActivityType is null OR @ActivityType = 'Task')    
BEGIN        
Insert Into #tmp_activities (TaskId,EmailId,AppointmentId,OrganiserActivityId,ActivityType,IsDocumentExist,TenantId,IsBillable,ServicingAdviserName)        
Select TOP (@_TopN) T1.TaskId,0,0, T2.OrganiserActivityId,    
'Task' ,    
0 As IsDocumentExist , T1.IndigoClientId, 0 AS IsBillable ,
   	CASE
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') = '' AND ISNULL(TCJoint.CurrentAdviserName ,'') = '' )
			THEN NULL
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') <> '' AND ISNULL(TCJoint.CurrentAdviserName ,'') = '' )
			THEN (TCClient.CurrentAdviserName)
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') <> '' AND ISNULL(TCJoint.CurrentAdviserName ,'') <> '' 
		AND TCClient.CurrentAdviserName = TCJoint.CurrentAdviserName)
			THEN (TCClient.CurrentAdviserName)					--test this case
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') <> '' AND ISNULL(TCJoint.CurrentAdviserName ,'') <> '' 
		AND TCClient.CurrentAdviserName <> TCJoint.CurrentAdviserName)
			THEN (TCClient.CurrentAdviserName +' & ' + TCJoint.CurrentAdviserName)
		ELSE
			NULL
	END AS [ServicingAdviserName]
From TTask T1         
 Inner Join TOrganiserActivity T2  On T1.TaskId = T2.TaskId and T2.IndigoClientId = T1.IndigoClientId AND T2.TaskId IS NOT NULL      
     
-- Client Name        
LEFT JOIN CRM..TCRMContact TCClient  On TCClient.CRMContactId = T2.CRMContactId AND TCClient.IndClientId = @IndigoClientId        
LEFT JOIN CRM..TCRMContact TCJoint  On TCJoint.CRMContactId = T2.JointCRMContactId AND TCJoint.IndClientId = @IndigoClientId        
        
--Plans        
LEFT JOIN Policymanagement..TPolicybusiness pb  On pb.PolicybusinessID = IsNull(T2.PolicyId,0)        
LEFT JOIN Policymanagement..TPolicyDetail pd On pb.PolicyDetailId = pd.PolicyDetailId        
LEFT JOIN Policymanagement..TPlanDescription pld on pd.PlanDescriptionid = pld.PlanDescriptionid         
        
-- Secure clause        
LEFT JOIN CRM..VwCRMContactKeyByCreatorId TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = TCClient._OwnerId        
LEFT JOIN CRM..VwCRMContactKeyByEntityId TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = TCClient.CRMContactId        
LEFT JOIN Administration..TUser u ON u.UserId = tckey.UserId    
    
left join CRM..TCRMContact TCAdviser on TCAdviser.CRMContactId = TCClient.CurrentAdviserCRMId        
left join CRM..TCRMContact TCAdviserJoint on TCAdviserJoint.CRMContactId = TCJoint.CurrentAdviserCRMId        
-- Attachment for task    
--LEFT JOIN [DocumentManagement].[dbo].[TDocument] TD ON TD.EntityId=T1.TaskId and TD.IndigoClientId = T1.IndigoClientId   
--LEFT JOIN [DocumentManagement].[dbo].[TDocVersion] DV ON DV.DocumentId=TD.DocumentId    
        
Where T1.IndigoClientId = @IndigoClientId        
AND ISNULL(TCClient.IsDeleted, 0) = 0
AND      
 (          
   (@_UserId < 0 OR (TCClient._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))        
  OR        
  (@_UserId < 0 AND TCClient.CRMContactId IS NULL)        
  OR        
  (@_UserId > 0 AND AssignedToUserId = @_UserId AND TCClient.CRMContactId IS NULL)        
 )        
      
And        
(        
 ( @AssignedToOption = '%' Or (@AssignedToOption = 'User' And AssignedToRoleId is null And AssignedToUserId is not Null) )        
 OR        
 ( @AssignedToOption = '%' Or (@AssignedToOption = 'Role' And AssignedToRoleId is not null And AssignedToUserId is Null) )        
)        
    
--new    
And    
      
 (      
  ( (@AssignedByUserId = 0) Or (@AssignedByUserId != 0 and AssignedUserId = @AssignedByUserId) )      
  And      
  (     
 ( (@AssignedToUserId = 0 And @AssignedToRoleId = 0) Or (@AssignedToUserId != 0 And @AssignedToRoleId = 0 and (AssignedToUserId = @AssignedToUserId and AssignedToRoleId is null) ) )    
 OR    
 ( (@AssignedToUserId = 0 And @AssignedToRoleId = 0) Or (@AssignedToUserId = 0 And @AssignedToRoleId != 0 and (AssignedToRoleId = @AssignedToRoleId and AssignedToUserId is null) ) )     
  )    
 )      
     
        
And        
 ( @Subject = '%' Or (@Subject != '%' and T1.Subject like '%' + @Subject + '%') )        
      
        
And         
 ( 
     @RefTaskStatusId = 0 Or 
	(@RefTaskStatusId = 6 and IsNull(RefTaskStatusId,0) <> 2) OR -- all but completed
	(@RefTaskStatusId NOT IN (0,6)  and IsNull(RefTaskStatusId,0) = @RefTaskStatusId) 
 )          
        
And         
 ( @RefPriorityId = 0 Or (@RefPriorityId != 0 and IsNull(RefPriorityId,0) = @RefPriorityId) )        
        
And         
 --( @RelatesToCRMContactId = 0 Or (@RelatesToCRMContactId != 0 and T1.CRMContactId = @RelatesToCRMContactId) )        
( @RelatesToCRMContactId = 0 Or (@RelatesToCRMContactId != 0 and (T2.CRMContactId = @RelatesToCRMContactId or T2.JointCRMContactId = @RelatesToCRMContactId) ) ) 
        
And        
 ( @TaskRef = '%' Or (@TaskRef != '%' and T1.SequentialRef like '%' + @TaskRef) )        
        
And         
(         
 ( (@FromStartDate is null and @ToStartDate is null) Or ((@FromStartDate is not null and @ToStartDate is not null) and T1.StartDate between @FromStartDate and @ToStartDate) )         OR        
 ( ((@FromStartDate is not null and @ToStartDate is null) and T1.StartDate >= @FromStartDate) )        
 OR        
 ( ((@FromStartDate is null and @ToStartDate is not null) and T1.StartDate <= @ToStartDate) )        
)        
And         
(         
 ( (@FromDueDate is null and @ToDueDate is null) Or ((@FromDueDate is not null and @ToDueDate is not null) and DueDate between @FromDueDate and @ToDueDate) )        
 OR        
 ( ((@FromDueDate is not null and @ToDueDate is null) and DueDate >= @FromDueDate) )        
 OR        
 ( ((@FromDueDate is null and @ToDueDate is not null) and DueDate <= @ToDueDate) )        
)        
And        
 ( @ActivityCategoryParentId is null Or (@ActivityCategoryParentId is not null and T2.ActivityCategoryParentId = @ActivityCategoryParentId) )        
And        
 ( @ActivityCategoryId is null Or (@ActivityCategoryId is not null and T2.ActivityCategoryId = @ActivityCategoryId) )        
And        
 ( @RefProdProviderId = 0 Or (@RefProdProviderId > 0 and pld.RefProdProviderId = @RefProdProviderId) )        
And
 (@ServicingAdviserId = 0 Or ((@ServicingAdviserId>0 and TCAdviser.CRMContactId = @ServicingAdviserId) or (@ServicingAdviserId>0 and TCAdviserJoint.CRMContactId = @ServicingAdviserId)))        
      
OPTION (RECOMPILE)  


  --Update the IsDocument Flag if Task has any associated documents.    
UPDATE #tmp_activities    
 SET IsDocumentExist = 1    
 FROM (    
     SELECT A.TaskId    
  FROM #tmp_activities A    
  LEFT JOIN DocumentManagement..TDocument TD ON TD.EntityId=A.TaskId AND TD.EntityType=5    
  where A.TenantId = @IndigoClientId    
  and TD.IndigoClientId = @IndigoClientId    
  GROUP BY A.TaskId    
  Having COUNT(TD.EntityId) > 0 ) Doc     
INNER JOIN #tmp_activities B ON Doc.TaskId= B.TaskId  

--update the IsBillable flag if task is linked with any fees
UPDATE #tmp_activities
SET IsBillable = 1
FROM #tmp_activities A
INNER JOIN PolicyManagement..TFeetoTask FT ON A.TaskId = FT.TaskId AND FT.TenantId = @IndigoClientId
  
  
END      
    
  
    
--Emails    
----------------------------------------------------------------------------------    
if (@ActivityType is null OR @ActivityType = 'Email')     
-- If there are any task related fields in the search, then then ignore the Email section  
AND (IsNull(@RefPriorityId,0) = 0 AND IsNull(@RefProdProviderId,0) =0 AND IsNull(@TaskRef,'%') = '%'  AND @FromStartDate IS NULL AND @ToStartDate IS NULL AND IsNull(@AssignedToOption,'%') = '%' AND ISNULL( @AssignedToRoleId,0) = 0)  
BEGIN     
Insert Into #tmp_activities (TaskId,EmailId, AppointmentId, OrganiserActivityId,ActivityType,IsDocumentExist,IsBillable,ServicingAdviserName)    
Select Distinct TOP (@_TopN)    
        0,     
  T1.EmailId, 0,    
  T2.OrganiserActivityId,    
  'Email',    
  CASE    
   WHEN (TA.AttachmentId > 0) THEN 1    
   ELSE 0    
  END AS IsDocumentExist,
  0 AS IsBillable,                  
	CASE
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') = '' AND ISNULL(TCJoint.CurrentAdviserName ,'') = '' )
			THEN NULL
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') <> '' AND ISNULL(TCJoint.CurrentAdviserName ,'') = '' )
			THEN (TCClient.CurrentAdviserName)
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') <> '' AND ISNULL(TCJoint.CurrentAdviserName ,'') <> '' 
		AND TCClient.CurrentAdviserName = TCJoint.CurrentAdviserName)
			THEN (TCClient.CurrentAdviserName)					--test this case
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') <> '' AND ISNULL(TCJoint.CurrentAdviserName ,'') <> '' 
		AND TCClient.CurrentAdviserName <> TCJoint.CurrentAdviserName)
			THEN (TCClient.CurrentAdviserName +' & ' + TCJoint.CurrentAdviserName)
		ELSE
			NULL
	END AS [ServicingAdviserName]
From TEmail T1         
Inner Join TOrganiserActivity T2  On T1.OrganiserActivityId = T2.OrganiserActivityId AND T2.IndigoClientId = @IndigoClientId  AND T2.AppointmentId is null and T2.TaskId is null 
Inner Join TEntityOrganiserActivity T3 On T2.OrganiserActivityId = T3.OrganiserActivityId    
    
-- Client Name    
LEFT JOIN CRM..TCRMContact TCClient  On TCClient.CRMContactId = T2.CRMContactId     AND TCClient.IndClientId = @IndigoClientId    
LEFT JOIN CRM..TCRMContact TCJoint  On TCJoint.CRMContactId = T2.JointCRMContactId AND TCJoint.IndClientId = @IndigoClientId        
           
-- Attachment for Email    
LEFT JOIN [CRM].[dbo].[TAttachment] TA ON TA.EmailId = T1.EmailId        
-- Secure clause        
--LEFT JOIN CRM..VwCRMContactKeyByCreatorId TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = TCClient._OwnerId        
--LEFT JOIN CRM..VwCRMContactKeyByEntityId TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = TCClient.CRMContactId        
--LEFT JOIN Administration..TUser u ON u.UserId = tckey.UserId    

left join CRM..TCRMContact TCAdviser on TCAdviser.CRMContactId = TCClient.CurrentAdviserCRMId        
left join CRM..TCRMContact TCAdviserJoint on TCAdviserJoint.CRMContactId = TCJoint.CurrentAdviserCRMId        
        
Where T2.CompleteFG = 1        
AND ISNULL(TCClient.IsDeleted, 0) = 0
 AND    
 ( @Subject = '%' Or (@Subject != '%' and T1.Subject like '%' + @Subject + '%') )        
 AND    
 (         
    ( (@FromSentDateUtc is null and @ToSentDateUtc is null) Or ((@FromSentDateUtc is not null and @ToSentDateUtc is not null) and T1.SentDate  between @FromDueDate and @ToDueDate) )        
  OR        
  ( ((@FromSentDateUtc is not null and @ToSentDateUtc is null) and T1.SentDate  >= @FromSentDateUtc) )        
  OR        
  ( ((@FromSentDateUtc is null and @ToSentDateUtc is not null) and T1.SentDate <= @ToSentDateUtc) )        
 )    
 AND (T1.OwnerPartyId = @AssignedToUserPartyId OR  @AssignedToUserPartyId = 0)    
 AND (T1.OwnerPartyId = @AssignedByUserPartyId OR  @AssignedByUserPartyId = 0)
 -- client filter
 AND (T3.EntityId = @RelatesToCRMContactId OR @RelatesToCRMContactId = 0)
 AND (@RefTaskStatusId = 2 OR  @RefTaskStatusId = 0) -- @RefTaskStatusId = 2 is Complete    
 AND        
  ( @ActivityCategoryId is null Or (@ActivityCategoryId is not null and T2.ActivityCategoryId = @ActivityCategoryId) )        
  AND    
  ( @ActivityCategoryParentId is null Or (@ActivityCategoryParentId is not null and T2.ActivityCategoryParentId = @ActivityCategoryParentId) )        
 -- Secure emails to specific user (super users/viewers can still see all records.    
 AND (      
  @_UserId < 0 OR T1.OwnerPartyId = @CurrentUserPartyId    
 )    
 AND
 (@ServicingAdviserId = 0 Or ((@ServicingAdviserId>0 and TCAdviser.CRMContactId = @ServicingAdviserId) or (@ServicingAdviserId>0 and TCAdviserJoint.CRMContactId = @ServicingAdviserId)))
 OPTION (RECOMPILE)          
END    
    
----------------------------------------------------------------------------------    
-- Orphan Emails    
----------------------------------------------------------------------------------    
if (@ActivityType is null OR @ActivityType = 'Orphan Email')    
-- If search criteria has 'Client' or 'Status', then ignore the Orphan Email section  
AND (ISNULL(@RelatesToCRMContactId,0) = 0) AND ISNULL(@RefTaskStatusId,0) = 0  
-- If there are any task related fields in the search, then then ignore the Orphan Email section  
AND (IsNull(@RefPriorityId,0) = 0 AND IsNull(@RefProdProviderId,0) =0 AND IsNull(@TaskRef,'%') = '%'  AND @FromStartDate IS NULL AND @ToStartDate IS NULL AND IsNull(@AssignedToOption,'%') = '%' AND ISNULL( @AssignedToRoleId,0) = 0)  
BEGIN     
 Insert Into #tmp_activities (TaskId,EmailId,AppointmentId, OrganiserActivityId,ActivityType,IsDocumentExist,IsBillable)        
   Select DISTINCT TOP (@_TopN) 0,     
   T1.EmailId, 0,    
   T2.OrganiserActivityId,       
   'Orphan Email',    
   CASE    
    WHEN (TA.AttachmentId > 0) THEN 1    
    ELSE 0    
   END AS IsDocumentExist,
   0 AS IsBillable    
 From TEmail T1     
 Inner Join TOrganiserActivity T2  On T1.OrganiserActivityId = T2.OrganiserActivityId AND T2.IndigoClientId = @IndigoClientId AND T2.AppointmentId is null and T2.TaskId is null
    --Email Attachment    
 LEFT JOIN CRM..TAttachment TA ON TA.EmailId = T1.EmailId    
 Where        
 --T2.IndigoClientId = @IndigoClientId  AND  
T2.CompleteFG = 0    
 And        
  ( @Subject = '%' Or (@Subject != '%' and T1.Subject like '%' + @Subject + '%') )         
 And         
 (         
     
( (@FromSentDateUtc is null and @ToSentDateUtc is null) Or ((@FromSentDateUtc is not null and @ToSentDateUtc is not null) and T1.SentDate  between @FromDueDate and @ToDueDate) )        
  OR        
  ( ((@FromSentDateUtc is not null and @ToSentDateUtc is null) and T1.SentDate >= @FromSentDateUtc) )        
  OR        
  ( ((@FromSentDateUtc is null and @ToSentDateUtc is not null) and T1.SentDate <= @ToSentDateUtc) )        
 )    
 And (T1.OwnerPartyId = @AssignedToUserPartyId OR  @AssignedToUserPartyId = 0)    
 And (T1.OwnerPartyId = @AssignedByUserPartyId OR  @AssignedByUserPartyId = 0)         
  -- Secure emails to specific user (super users/viewers can still see all records.    
 AND (      
  @_UserId < 0 OR T1.OwnerPartyId = @CurrentUserPartyId    
 )    
 OPTION (RECOMPILE)     
END            
    
----------------------------------------------------------------------------------        
-- Diary       
----------------------------------------------------------------------------------       
          
if (@ActivityType is null OR @ActivityType = 'Diary')    
-- If search criteria has 'Assigned To' or 'Assigned By', then ignore the Diary section  
AND (IsNull(@AssignedToUserPartyId,0) = 0) AND (IsNull(@AssignedByUserPartyId,0) = 0)  
-- If there are any task related fields in the search, then then ignore the Diary section  
AND (IsNull(@RefPriorityId,0) = 0 AND IsNull(@RefProdProviderId,0) =0 AND IsNull(@TaskRef,'%') = '%'  AND IsNull(@AssignedToOption,'%') = '%' AND ISNULL( @AssignedToRoleId,0) = 0)  
BEGIN            
Insert Into #tmp_activities (AppointmentId, TaskId, EmailId, OrganiserActivityId, ActivityType, IsDocumentExist,IsBillable,ServicingAdviserName)            
Select distinct TOP (@_TopN) T1.AppointmentId, 0,0,     
T2.OrganiserActivityId,      
'Diary',      
0 AS IsDocumentExist ,
0 AS IsBillable,
   	CASE
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') = '' AND ISNULL(TCJoint.CurrentAdviserName ,'') = '' )
			THEN NULL
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') <> '' AND ISNULL(TCJoint.CurrentAdviserName ,'') = '' )
			THEN (TCClient.CurrentAdviserName)
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') <> '' AND ISNULL(TCJoint.CurrentAdviserName ,'') <> '' 
		AND TCClient.CurrentAdviserName = TCJoint.CurrentAdviserName)
			THEN (TCClient.CurrentAdviserName)					--test this case
		WHEN (ISNULL(TCClient.CurrentAdviserName,'') <> '' AND ISNULL(TCJoint.CurrentAdviserName ,'') <> '' 
		AND TCClient.CurrentAdviserName <> TCJoint.CurrentAdviserName)
			THEN (TCClient.CurrentAdviserName +' & ' + TCJoint.CurrentAdviserName)
		ELSE
			NULL
	END AS [ServicingAdviserName]        
From TAppointment T1             
 Inner Join TOrganiserActivity T2  On T1.AppointmentId = T2.AppointmentId AND T2.IndigoClientId = @IndigoClientId AND T2.AppointmentId is not null and T2.TaskId is null           
        
-- Client Name            
LEFT JOIN CRM..TCRMContact TCClient  On TCClient.CRMContactId = T2.CRMContactId AND TCClient.IndClientId = @IndigoClientId            
LEFT JOIN CRM..TCRMContact TCJoint  On TCJoint.CRMContactId = T2.JointCRMContactId AND TCJoint.IndClientId = @IndigoClientId        
    
-- Attendees    
LEFT JOIN CRM..TAttendees TA  On TA.AppointmentId = T1.AppointmentId
    
LEFT JOIN Administration..TUser u ON u.CRMContactId = TA.CRMContactId     

--servicing adviser
left join CRM..TCRMContact TCAdviser on TCAdviser.CRMContactId = TCClient.CurrentAdviserCRMId        
left join CRM..TCRMContact TCAdviserJoint on TCAdviserJoint.CRMContactId = TCJoint.CurrentAdviserCRMId        
    
Where ( @Subject = '%' Or (@Subject != '%' and T1.Subject like '%' + @Subject + '%') )     
AND ISNULL(TCClient.IsDeleted, 0) = 0
    
And ((u.UserId = @_UserId or TCClient._OwnerId=@_UserId) or @_UserId < 0)    
  
AND T2.CompleteFG =   
CASE  
WHEN @RefTaskStatusId = 2 THEN 1  
ELSE 0  
END  
  
  
And    
 --( @RelatesToCRMContactId = 0 Or (@RelatesToCRMContactId != 0 and T1.CRMContactId = @RelatesToCRMContactId) )            
( @RelatesToCRMContactId = 0 Or (@RelatesToCRMContactId != 0 and (T2.CRMContactId = @RelatesToCRMContactId or T2.JointCRMContactId = @RelatesToCRMContactId) ) ) 
   
 And         
(         
 ( (@FromStartDate is null and @ToStartDate is null) Or ((@FromStartDate is not null and @ToStartDate is not null) and T1.StartTime between @FromStartDate and @ToStartDate) )        
 OR        
 ( ((@FromStartDate is not null and @ToStartDate is null) and T1.StartTime >= @FromStartDate) )        
 OR        
 ( ((@FromStartDate is null and @ToStartDate is not null) and T1.StartTime <= @ToStartDate) )        
)     
And             
(             
 ( (@FromDueDate is null and @ToDueDate is null) Or ((@FromDueDate is not null and @ToDueDate is not null) and EndTime between @FromDueDate and @ToDueDate) )            
 OR            
 ( ((@FromDueDate is not null and @ToDueDate is null) and EndTime >= @FromDueDate) )            
 OR            
 ( ((@FromDueDate is null and @ToDueDate is not null) and EndTime <= @ToDueDate) )            
)            
And            
 ( @ActivityCategoryParentId is null Or (@ActivityCategoryParentId is not null and T2.ActivityCategoryParentId = @ActivityCategoryParentId) )            
And            
 ( @ActivityCategoryId is null Or (@ActivityCategoryId is not null and T2.ActivityCategoryId = @ActivityCategoryId) )            
and
 (@ServicingAdviserId = 0 Or ((@ServicingAdviserId>0 and TCAdviser.CRMContactId = @ServicingAdviserId) or (@ServicingAdviserId>0 and TCAdviserJoint.CRMContactId = @ServicingAdviserId)))  

 AND TA.CRMContactId <> T1.CRMContactId
 OPTION (RECOMPILE)        
END     
    
-- reset rows returned?              
IF (@_TopN > 0) SET ROWCOUNT 0    
    
    
/* Create temporary table to retrieve plan related information as with the last retrieval we are facing perfomrance     
issue    
*/    
    
If Object_Id('tempdb..#tmpTaskPlanTable') Is Not Null        
 Drop Table #tmpTaskPlanTable    
    
Create Table #tmpTaskPlanTable(TaskId int,
							   PlanTypeName varchar(255),
							   PlanTypeId bigint,
							   SellingAdviserName varchar(255),
							   PlanTypeProdSubTypeName varchar(255),
							   ProviderName varchar(255),
							   SolicitorName varchar(255),
							   PolicyBusinessId INT)  

----------------------------------------------------------------------------------
-- By a performance reason to create an index for Temp table
----------------------------------------------------------------------------------
CREATE CLUSTERED INDEX IDX_MI_Activities ON #tmp_activities(TaskId,OrganiserActivityId)
----------------------------------------------------------------------------------   
    
if (@ActivityType is null OR @ActivityType = 'Task')    
BEGIN        
    
Insert into #tmpTaskPlanTable(TaskId, PlanTypeName,PlanTypeId, SellingAdviserName,PlanTypeProdSubTypeName,ProviderName,SolicitorName,PolicyBusinessId)
SELECT DISTINCT TOP (@_TopN) A.TaskId, 
	  PT.PlanTypeName + '(' + PC.CorporateName + ')' AS PlanTypeName,    
      PB.PolicyBusinessId As PlanTypeId,
	  CASE  WHEN PractC.PersonId IS NOT NULL THEN PractC.FirstName + ' ' + PractC.LastName
			ELSE PractC.CorporateName
	  END AS SellingAdviserName,
	  CASE WHEN PSub.ProdSubTypeName IS NULL THEN PT.PlanTypeName 
		   ELSE PT.PlanTypeName + ' (' + PSub.ProdSubTypeName + ')' END AS PlanTypeProdSubTypeName,
	  PC.CorporateName,
	  '' AS SolicitorName,/*To avoid performance issue, will update SolicitorName later*/
	  PB.PolicyBusinessId   
FROM #tmp_activities A    
INNER JOIN CRM..TOrganiserActivity H on H.TaskId = A.TaskId and H.IndigoClientId = @IndigoClientId   
LEFT JOIN PolicyManagement..TPolicyBusiness PB on PB.PolicyBusinessId= H.PolicyId    
LEFT JOIN PolicyManagement..TPolicyDetail PD on PD.PolicyDetailId=PB.PolicyDetailId    
LEFT JOIN PolicyManagement..TPlanDescription PS on PS.PlanDescriptionId=PD.PlanDescriptionId    
LEFT JOIN PolicyManagement..TRefPlanType2ProdSubType RP on RP.RefPlanType2ProdSubTypeId=PS.RefPlanType2ProdSubTypeId    
LEFT JOIN PolicyManagement..TRefPlantype PT on PT.RefPlanTypeId=RP.RefPlanTypeId    
LEFT JOIN PolicyManagement..TRefProdProvider PP ON PP.RefProdProviderId=PS.RefProdProviderId    
LEFT JOIN CRM..TCRMContact PC ON PC.CRMContactId=PP.CRMContactId
LEFT JOIN CRM..TPractitioner Pract On Pract.PractitionerId = PB.PractitionerId AND Pract.IndClientId = @IndigoClientId
LEFT JOIN CRM..TCRMContact PractC ON PractC.CRMContactId = Pract.CRMContactId AND PractC.IndClientId = @IndigoClientId
LEFT JOIN [policymanagement].[dbo].[TProdSubType] AS PSub ON PSub.ProdSubTypeId = RP.ProdSubTypeId
Where     
PB.IndigoClientId = H.IndigoClientId     
And        
 ( @RefProdProviderId = 0 Or (@RefProdProviderId > 0 and PS.RefProdProviderId = @RefProdProviderId) )      
END    
 
----------------------------------------------------------------------------------
-- By a performance reason to create an index for Temp table
----------------------------------------------------------------------------------
CREATE CLUSTERED INDEX IDX_MI_TaskPlanTable ON #tmpTaskPlanTable(TaskId, PolicyBusinessId) 

----------------------------------------------------------------------------------
-- Fill a SolicitorName
----------------------------------------------------------------------------------
IF EXISTS (select 1 from [administration].[dbo].[TIndigoClientPreference] where IndigoClientId = @IndigoClientId and PreferenceName = 'ShowSolicitor' AND Value = 'true') 
BEGIN
UPDATE #tmpTaskPlanTable
SET SolicitorName =  STUFF 
	    (
			(SELECT DISTINCT  ' ' + ISNULL(PCON.CompanyName, '') 
			FROM [policymanagement].[dbo].[TPolicyBusinessToProfessionalContact] AS PBPC
            INNER JOIN [factfind].[dbo].[TProfessionalContact] AS PCON ON PCON.ProfessionalContactId = PBPC.ProfessionalContactId AND PCON.ContactType = 'Solicitor' 
            WHERE PBPC.PolicyBusinessId = #tmpTaskPlanTable.PolicyBusinessId 
			FOR XML PATH (''),TYPE ).value( '(./text())[1]','VARCHAR(MAX)' ),1,1,'' 

		)     
END    
----------------------------------------------------------------------------------        
-- Select Additional Details              
----------------------------------------------------------------------------------    
-- Limit rows returned?                
IF (@_TopN > 0) SET ROWCOUNT @_TopN       
    
SELECT            
    T2.OrganiserActivityId AS [OrganiserActivity_OrganiserActivityId],         
 CASE      
   WHEN (T.ActivityType = 'Task' ) THEN IsNull(T1.TaskId,0)      
   WHEN (T.ActivityType = 'Diary' ) THEN IsNull(T16.AppointmentId,0)       
 ELSE 0      
 END AS [Task_TaskId],               
 CASE         
   WHEN (T.ActivityType = 'Task' ) THEN ISNULL(T1.DueDate,'')     
   WHEN (T.ActivityType = 'Diary' ) THEN ISNULL(T16.EndTime,'')      
   WHEN (T.ActivityType = 'Email' ) OR (T.ActivityType = 'Orphan Email')         
    THEN ISNULL(E.SentDate,'')        
  ELSE  ''        
    END AS [Task_DueDate],        
  CASE      
  WHEN (T.ActivityType = 'Email' ) OR (T.ActivityType = 'Orphan Email') OR (T.ActivityType = 'Task') THEN ISNULL(T1.Subject, '') + ISNULL(E.Subject,'')                       
  WHEN (T.ActivityType = 'Diary' ) THEN ISNULL(T16.Subject, '')      
  END AS [Task_Subject],        
                       
  T3.RefTaskStatusId AS [RefTaskStatus_RefTaskStatusId],             
            
    CASE         
  WHEN (T.ActivityType = 'Task' ) THEN T3.Name        
        WHEN (T.ActivityType = 'Email' ) THEN 'Complete'        
        WHEN (T.ActivityType = 'Orphan Email' ) THEN 'Incomplete'        
        WHEN (T.ActivityType = 'Diary' ) THEN       
   CASE       
    WHEN (T2.CompleteFG = 1 ) THEN 'Complete' ELSE 'Incomplete'      
   END      
  ELSE  ''        
    END AS [RefTaskStatus_Name],                  
        
    T4.RefPriorityId AS [RefPriority_RefPriorityId],             
    T4.PriorityName AS [RefPriority_PriorityName],        
          
  --  CASE       
  --WHEN (T.ActivityType = 'Diary' ) THEN ISNULL(T17.Name, '')      
  --  ELSE T5.Identifier END AS [AssignedToUser_Identifier],       
    T5.Identifier AS [AssignedToUser_Identifier],         
    T6.Identifier AS [AssignedUser_Identifier],              
    T7.Identifier AS [AssignedToRole_Identifier],
    CASE
        WHEN (T.ActivityType = 'Email' ) THEN EC.CRMContactId
        ELSE T8.CRMContactId
    END AS [RelatedContact_CRMContactId], 
    CASE
        WHEN (T.ActivityType = 'Email' ) THEN ISNULL(EC.AdvisorRef, '')
        ELSE ISNULL(T8.AdvisorRef, '')
    END AS [RelatedContact_AdvisorRef],
    CASE
        WHEN (T.ActivityType = 'Email' ) THEN ISNULL(EC.LastName, '')
        ELSE ISNULL(T8.LastName, '')
    END AS [RelatedContact_LastName],
    CASE
        WHEN (T.ActivityType = 'Email' ) THEN ISNULL(EC.FirstName, '')
        ELSE ISNULL(T8.FirstName, '')
    END AS [RelatedContact_FirstName],
    CASE
        WHEN (T.ActivityType = 'Email' ) THEN ISNULL(EC.CorporateName, '')
        ELSE ISNULL(T8.CorporateName, '')
    END AS [RelatedContact_CorporateName],
    CASE
        WHEN (T.ActivityType = 'Email' ) THEN EC.CRMContactType
        ELSE T8.CRMContactType
    END AS [RelatedContact_CRMContactType],
    CASE
        WHEN (T.ActivityType = 'Email' ) THEN ISNULL(EC.ExternalReference, '')
        ELSE ISNULL(T8.ExternalReference, '')
    END AS [RelatedContact_ExternalReference],
    T11.EventListId AS [EventList_EventListId],
    T13.CRMContactId AS [CRMAssignedToUser_CRMContactId],

	--Joint client
	T8_Joint.CRMContactId AS [RelatedJointContact_CRMContactId],             
	ISNULL(T8_Joint.LastName, '') AS [RelatedJointContact_LastName],             
    ISNULL(T8_Joint.FirstName, '') AS [RelatedJointContact_FirstName],             
    ISNULL(T8_Joint.CorporateName, '') AS [RelatedJointContact_CorporateName],                   
    
    CASE 
		WHEN ( ISNULL(T8.CRMContactId, '') <> '' AND ISNULL(T8_Joint.CRMContactId, '') = '' ) 
			THEN ISNULL(T8.FirstName, '') + ' ' + ISNULL(T8.LastName, '') + ' ' + ISNULL(T8.CorporateName, '') 
		WHEN ( ISNULL(T8.CRMContactId, '') <> '' AND ISNULL(T8_Joint.CRMContactId, '') <> '' ) 
			THEN 
				ISNULL(T8.FirstName, '') + ' ' + ISNULL(T8.LastName, '') + ' ' + ISNULL(T8.CorporateName, '') 
				+ '& ' +
				ISNULL(T8_Joint.FirstName, '') + ' ' + ISNULL(T8_Joint.LastName, '') + ' ' + ISNULL(T8_Joint.CorporateName, '') 
        WHEN ( ISNULL(EC.CRMContactId, '') <> '')
            THEN ISNULL(EC.FirstName, '') + ' ' + ISNULL(EC.LastName, '') + ' ' + ISNULL(EC.CorporateName, '')
		ELSE ''
    END AS [RelatedContactWithJoint_FullName],
            
    CASE         
  WHEN (T.ActivityType = 'Task' ) THEN ISNULL(T13.LastName, '')        
        WHEN (T.ActivityType = 'Email' ) OR (T.ActivityType = 'Orphan Email') THEN ISNULL(T15.LastName, '')        
        WHEN (T.ActivityType = 'Diary' ) THEN ISNULL(T18.LastName, '')       
  ELSE  ''        
    END AS [CRMAssignedToUser_LastName],        
        
    CASE         
  WHEN (T.ActivityType = 'Task' ) THEN ISNULL(T13.FirstName, '')        
        WHEN (T.ActivityType = 'Email' ) OR (T.ActivityType = 'Orphan Email') THEN ISNULL(T15.FirstName, '')       
        WHEN (T.ActivityType = 'Diary' ) THEN ISNULL(T18.FirstName, '')        
  ELSE  ''        
    END AS [CRMAssignedToUser_FirstName],        
        
    ISNULL(T14.AdviceCaseId,'') AS [RelatedAdviceCase_AdviceCaseId],                
    CASE         
  WHEN (T14.CaseRef IS NULL AND T14.CaseName IS NULL) THEN ''        
  ELSE ISNULL(T14.CaseRef,'') + ':' + ISNULL(T14.CaseName,'')        
     END AS [AdviceCase_Description],                
 T.ActivityType + CASE     
  WHEN T2.IsRecurrence =1 THEN ' ('+   [dbo].[FnGetRecurrenceActivityType](AR.RFCCode) +')'    
 ELSE ''    
 END AS [ActivityType],     
 CASE  
WHEN (T.ActivityType = 'Diary' ) THEN ISNULL(CONVERT(varchar(17), T16.StartTime, 113),'')      
 ELSE  
    T1.StartDate END AS [Task_StartDate],        
 T.IsDocumentExist AS [Task_IsDocumentExist],        
 TP.PlanTypeName AS [Task_PlanTypeName],        
 TP.PlanTypeId As [Task_PlanTypeId],        
 T9.Name AS [ActivityCategory_Name],
 T.IsBillable AS [Task_IsBillable],
 TP.SellingAdviserName AS [Task_SellingAdviserName],
 ServicingAdviserName AS [Task_ServicingAdviserName],
 TP.PlanTypeProdSubTypeName AS [Task_PlanTypeProdSubTypeName],
 TP.ProviderName AS [Task_ProviderName],
 TP.SolicitorName AS [Task_SolicitorName],
 CASE         
   WHEN (T.ActivityType = 'Task' ) THEN T1.Timezone     
   WHEN (T.ActivityType = 'Diary' ) THEN T16.Timezone     
  ELSE NULL        
    END AS [Task_Timezone],                  
  CASE         
   WHEN (T.ActivityType = 'Task' ) THEN IIF(T13.CRMContactId IS NOT NULL, T13.FirstName+' '+T13.LastName, T7.Identifier)  
   WHEN (T.ActivityType = 'Diary' ) THEN T18.FirstName+' '+T18.LastName
   WHEN (T.ActivityType = 'Email' ) OR (T.ActivityType = 'Orphan Email') THEN T15.FirstName+' '+T15.LastName
  ELSE NULL        
    END AS  [Task_AssignedTo]
 FROM             
 #tmp_activities T            
 Inner Join TOrganiserActivity T2 ON T2.OrganiserActivityId = T.OrganiserActivityId and T2.IndigoClientId = @IndigoClientId
 Left Join TTask T1 ON T.TaskId = T1.TaskId and T1.IndigoClientId = @IndigoClientId
 Left Join TEmail E ON T.EmailId = E.EmailId        
 Left Join TAppointment T16 ON T.AppointmentId = T16.AppointmentId       
 left Join TRefTaskStatus T3 ON T3.RefTaskStatusId = T1.RefTaskStatusId        
 left Join TRefPriority T4 ON T4.RefPriorityId = T1.RefPriorityId        
 left Join [Administration].[dbo].TUser T5 ON T5.UserId = T1.AssignedToUserId        
 left Join [Administration].[dbo].TUser T6 ON T6.UserId = T1.AssignedUserId        
 left Join [Administration].[dbo].TRole T7 ON T7.RoleId = T1.AssignedToRoleId        
 left Join [CRM].[dbo].TCRMContact T8 ON T8.CRMContactId = T2.CRMContactId AND T8.IndClientId = @IndigoClientId        
 left Join [CRM].[dbo].TCRMContact T8_Joint ON T8_Joint.CRMContactId = T2.JointCRMContactId AND T2.IndigoClientId = @IndigoClientId--Joint Client
 left Join [CRM].[dbo].TActivityCategory T9 ON T9.ActivityCategoryId = T2.ActivityCategoryId        
 left Join [CRM].[dbo].TEventListActivity T10 ON T10.EventListActivityId = T2.EventListActivityId        
 left Join [CRM].[dbo].TEventList T11 ON T11.EventListId = T10.EventListId        
 left Join [CRM].[dbo].TCRMContact T12 ON T12.CRMContactId = T6.CRMContactId        
 left Join [CRM].[dbo].TCRMContact T13 ON T13.CRMContactId = T5.CRMContactId        
 left Join [CRM].[dbo].TAdviceCase T14 ON T14.AdviceCaseId = T2.AdviceCaseId        
 left Join [CRM].[dbo].TCRMContact T15 ON T15.CRMContactId = E.OwnerPartyId      
 left Join [CRM].[dbo].TCRMContact T18 ON T18.CRMContactId = T16.OrganizerCRMContactId       
 LEFT JOIN #tmpTaskPlanTable TP ON TP.TaskId=T.TaskId        
 LEFT JOIN TActivityRecurrence AR ON AR.OrganiserActivityId= T.OrganiserActivityId
 LEFT JOIN [CRM].[dbo].TEntityOrganiserActivity EOA ON T2.[OrganiserActivityId] = EOA.[OrganiserActivityId]
 LEFT JOIN [CRM].[dbo].TCRMContact EC ON EC.CRMContactId = EOA.EntityId AND EC.IndClientId = @IndigoClientId
 --Order By T.OrganiserActivityId Desc        
    
  -- reset rows returned?              
IF (@_TopN > 0) SET ROWCOUNT 0    

RETURN (0) 
GO