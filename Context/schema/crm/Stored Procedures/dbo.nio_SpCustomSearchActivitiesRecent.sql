SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomSearchActivitiesRecent]  
(  
  @ListOfIds varchar(2000),  
  @IndigoClientId int,
  @_UserId bigint  
)    
AS  
    
BEGIN  
--Generic Code  
  
Declare @RecentIds Table ( RecentId int )  
  
INSERT @RecentIds ( RecentId ) 
SELECT trim(value) FROM STRING_SPLIT (@ListOfIds, N',')

--Temporary Table for Data  
Create table #tmp_recentactivities   
(TaskId int, EmailId bigint, OrganiserActivityId bigint, PolicyBusinessId BIGINT, Task_SolicitorName VARCHAR(255))
  
Insert Into #tmp_recentactivities (TaskId,EmailId,OrganiserActivityId, PolicyBusinessId)  
Select T2.TaskId,T3.EmailId, T1.OrganiserActivityId, T1.PolicyId  
From dbo.TOrganiserActivity T1 With(Nolock)  
Left Join dbo.TTask T2 With(Nolock) On T1.TaskId = T2.TaskId AND t2.IndigoClientId = @IndigoClientId
Left Join dbo.TEmail T3 With(Nolock) On T1.OrganiserActivityId = T3.OrganiserActivityId  
Where   
T1.IndigoClientId = @IndigoClientId
AND T1.OrganiserActivityId in (select RecentId from @RecentIds);

IF EXISTS (select 1 from [administration].[dbo].[TIndigoClientPreference] where IndigoClientId = @IndigoClientId and PreferenceName = 'ShowSolicitor' AND Value = 'true') 
BEGIN
	WITH SolName as (
	  SELECT T.PolicyBusinessId, Task_SolicitorName =
		STRING_AGG
			( ISNULL(PCON.CompanyName, '') , ' ') WITHIN GROUP (ORDER BY PCON.CompanyName ASC)
                
			FROM [policymanagement].[dbo].[TPolicyBusinessToProfessionalContact]   PBPC
			INNER JOIN [factfind].[dbo].[TProfessionalContact] AS PCON ON PCON.ProfessionalContactId = PBPC.ProfessionalContactId AND PCON.ContactType = 'Solicitor'
			INNER JOIN #tmp_recentactivities T ON T.PolicyBusinessId = PBPC.PolicyBusinessId
			GROUP BY T.PolicyBusinessId
			)
		
	UPDATE T
	SET Task_SolicitorName = s.Task_SolicitorName
	FROM SolName s
	INNER JOIN #tmp_recentactivities T ON T.PolicyBusinessId = s.PolicyBusinessId

END

  
--Query to Retrieve Details  
SELECT DISTINCT     
    T2.OrganiserActivityId AS [OrganiserActivity_OrganiserActivityId],   
    IsNull(T1.TaskId,0) AS [Task_TaskId],           
 CASE   
 WHEN (T.TaskId IS NOT NULL) THEN T1.DueDate 
 ELSE E.SentDate    
 END AS [Task_DueDate],  
  
    ISNULL(T1.Subject, '') + ISNULL(E.Subject,'') AS [Task_Subject],                  
    T3.RefTaskStatusId AS [RefTaskStatus_RefTaskStatusId],           
    CASE   
  WHEN (T.TaskId IS NOT NULL) THEN T3.Name  
  WHEN (T.TaskId IS NULL AND T16.EntityOrganiserActivityId > 0) THEN 'Complete'  
  ELSE 'Incomplete'  
    END AS [RefTaskStatus_Name],            
  
    T4.RefPriorityId AS [RefPriority_RefPriorityId],       
    T4.PriorityName AS [RefPriority_PriorityName],  
    T5.Identifier AS [AssignedToUser_Identifier],   
    T6.Identifier AS [AssignedUser_Identifier],        
    T7.Identifier AS [AssignedToRole_Identifier],   
    T8.CRMContactId AS [RelatedContact_CRMContactId],       
    ISNULL(T8.AdvisorRef, '') AS [RelatedContact_AdvisorRef],       
    ISNULL(T8.LastName, '') AS [RelatedContact_LastName],       
    ISNULL(T8.FirstName, '') AS [RelatedContact_FirstName],       
    ISNULL(T8.CorporateName, '') AS [RelatedContact_CorporateName],       
    T8.CRMContactType AS [RelatedContact_CRMContactType],       
    ISNULL(T8.ExternalReference, '') AS [RelatedContact_ExternalReference],           
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
		ELSE ''
    END AS [RelatedContactWithJoint_FullName],
   
      
    CASE   
  WHEN (T.TaskId IS NOT NULL) THEN ISNULL(T13.LastName, '')  
        ELSE ISNULL(T15.LastName, '')  
    END AS [CRMAssignedToUser_LastName],  
  
    CASE   
  WHEN (T.TaskId IS NOT NULL) THEN ISNULL(T13.FirstName, '')          
  ELSE ISNULL(T15.FirstName, '')  
    END AS [CRMAssignedToUser_FirstName],  
  
    ISNULL(T14.AdviceCaseId,0) AS [RelatedAdviceCase_AdviceCaseId],          
    CASE   
  WHEN (T14.CaseRef IS NULL AND T14.CaseName IS NULL) THEN ''  
  ELSE ISNULL(T14.CaseRef,'') + ':' + ISNULL(T14.CaseName,'')  
    END AS [AdviceCase_Description],  
  
    CASE   
  WHEN (T.TaskId IS NOT NULL) THEN 'Task'  
  WHEN (T.TaskId IS NULL AND T16.EntityOrganiserActivityId > 0) THEN 'Email'    
  ELSE 'Orphan Email'  
    END AS [ActivityType],  
    T1.StartDate AS [Task_StartDate],  
    CASE  
   WHEN (T.TaskId IS NOT NULL) THEN  
   CASE   
    WHEN ((DV.DocVersionId > 0) AND (TD.EntityType=5)) THEN 1 -- 5 is for task entity  
    ELSE 0  
   END  
   WHEN (T.TaskId IS NULL AND T16.EntityOrganiserActivityId <> 0) THEN  
   CASE  
    WHEN (TA.AttachmentId > 0) THEN 1  
    ELSE 0  
   END  
 END AS [Task_IsDocumentExist],  
 PT.PlanTypeName + '(' + PC.CorporateName + ')' AS [Task_PlanTypeName],  
 PB.PolicyBusinessId AS [Task_PlanTypeId],
 T9.Name AS [ActivityCategory_Name],
 CASE WHEN T.TaskId IS NOT NULL THEN (CASE WHEN FT.TaskId IS NOT NULL THEN 1 ELSE 0 END) ELSE 0 END AS [Task_IsBillable],
 CASE  WHEN PractC.PersonId IS NOT NULL THEN PractC.FirstName + ' ' + PractC.LastName
		ELSE PractC.CorporateName
 END AS SellingAdviserName,
 NULL AS [Task_ServicingAdviserName],
 CASE WHEN PSub.ProdSubTypeName IS NULL THEN PT.PlanTypeName
	  ELSE PT.PlanTypeName + ' (' + PSub.ProdSubTypeName + ')' END AS [Task_PlanTypeProdSubTypeName],
 PC.CorporateName AS [Task_ProviderName],
 T.Task_SolicitorName,
 T1.Timezone AS Task_Timezone,
IIF(T13.CRMContactId IS NOT NULL, T13.FirstName+' '+T13.LastName, T7.Identifier) AS [Task_AssignedTo] 
 FROM       
 #tmp_recentactivities T      
 Inner Join TOrganiserActivity T2 ON T2.OrganiserActivityId = T.OrganiserActivityId  
 Left Join TTask T1 ON T.TaskId = T1.TaskId and t1.IndigoClientId = @IndigoClientId
 Left Join TEmail E ON T.EmailId = E.EmailId  
 left Join TRefTaskStatus T3 ON T3.RefTaskStatusId = T1.RefTaskStatusId  
 left Join TRefPriority T4 ON T4.RefPriorityId = T1.RefPriorityId  
 left Join [Administration].[dbo].TUser T5 ON T5.UserId = T1.AssignedToUserId  
 left Join [Administration].[dbo].TUser T6 ON T6.UserId = T1.AssignedUserId  
 left Join [Administration].[dbo].TRole T7 ON T7.RoleId = T1.AssignedToRoleId  
 left Join [CRM].[dbo].TCRMContact T8 ON T8.CRMContactId = T2.CRMContactId  
 left Join [CRM].[dbo].TCRMContact T8_Joint ON T8_Joint.CRMContactId = T2.JointCRMContactId --Joint Client
 left Join [CRM].[dbo].TActivityCategory T9 ON T9.ActivityCategoryId = T2.ActivityCategoryId  
 left Join [CRM].[dbo].TEventListActivity T10 ON T10.EventListActivityId = T2.EventListActivityId  
 left Join [CRM].[dbo].TEventList T11 ON T11.EventListId = T10.EventListId  
 left Join [CRM].[dbo].TCRMContact T12 ON T12.CRMContactId = T6.CRMContactId  
 left Join [CRM].[dbo].TCRMContact T13 ON T13.CRMContactId = T5.CRMContactId  
 left Join [CRM].[dbo].TAdviceCase T14 ON T14.AdviceCaseId = T2.AdviceCaseId  
 left Join [CRM].[dbo].TCRMContact T15 ON T15.CRMContactId = E.OwnerPartyId  
 left join [CRM].[dbo].TEntityOrganiserActivity T16   
          ON T16.OrganiserActivityId = E.OrganiserActivityId  
 LEFT JOIN [PolicyManagement].[dbo].[TPolicyBusiness] PB on PB.PolicyBusinessId=T2.PolicyId  
 LEFT JOIN [PolicyManagement].[dbo].[TPolicyDetail] PD on PD.PolicyDetailId=PB.PolicyDetailId  
 LEFT JOIN [PolicyManagement].[dbo].[TPlanDescription] PS on PS.PlanDescriptionId=PD.PlanDescriptionId  
 LEFT JOIN [PolicyManagement].[dbo].[TRefPlanType2ProdSubType] RP on RP.RefPlanType2ProdSubTypeId=PS.RefPlanType2ProdSubTypeId  
 LEFT JOIN [PolicyManagement].[dbo].[TRefPlantype] PT on PT.RefPlanTypeId=RP.RefPlanTypeId  
 LEFT JOIN [DocumentManagement].[dbo].[TDocument] TD ON TD.EntityId=T1.TaskId  
 LEFT JOIN [DocumentManagement].[dbo].[TDocVersion] DV ON DV.DocumentId=TD.DocumentId  
 LEFT JOIN [PolicyManagement].[dbo].[TRefProdProvider] PP ON PP.RefProdProviderId=PS.RefProdProviderId  
 LEFT JOIN [CRM].[dbo].[TCRMContact] PC ON PC.CRMContactId=PP.CRMContactId  
 LEFT JOIN [CRM].[dbo].[TAttachment] TA ON TA.EmailId = E.EmailId 
 LEFT JOIN PolicyManagement..TFeetoTask FT ON  T.TaskId = FT.TaskId  AND FT.TenantId  = @IndigoClientId
 LEFT JOIN CRM..TPractitioner Pract On Pract.PractitionerId = PB.PractitionerId AND Pract.IndClientId = @IndigoClientId
 LEFT JOIN CRM..TCRMContact PractC ON PractC.CRMContactId = Pract.CRMContactId AND PractC.IndClientId = @IndigoClientId
 LEFT JOIN [policymanagement].[dbo].[TProdSubType] AS PSub ON PSub.ProdSubTypeId = RP.ProdSubTypeId
END      
RETURN (0)   
GO
