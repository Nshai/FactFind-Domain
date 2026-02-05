SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpGetColumnListActivitySearch]      
@IndigoClientId bigint = 0,      
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
@DueDateWithin varchar(50) = null,      
@ActivityCategoryParentId bigint = null, -- not used in search      
@ActivityCategoryId bigint = null,      
@RefProdProviderId bigint = 0,  
@ActivityType varchar(50) = null,   
@_UserId bigint = 0,              
@_TopN int = 250,
@ServicingAdviserId bigint = 0      
      
AS        
      
BEGIN   
      
---Select Defaults  
SELECT      
    0  As [OrganiserActivity_OrganiserActivityId],  
	0  AS [Task_TaskId],       
    '' AS [Task_DueDate],       
    '' AS [Task_Subject],                          
    0  AS [RefTaskStatus_RefTaskStatusId],       
    '' AS [RefTaskStatus_Name],      
    0  AS [RefPriority_RefPriorityId],       
    '' AS [RefPriority_PriorityName],                       
    '' AS [AssignedToUser_Identifier],           
    '' AS [AssignedUser_Identifier],        
    '' AS [AssignedToRole_Identifier],         
    0  AS [RelatedContact_CRMContactId],       
    '' AS [RelatedContact_AdvisorRef],       
    '' AS [RelatedContact_LastName],       
    '' AS [RelatedContact_FirstName],       
    '' AS [RelatedContact_CorporateName],       
    '' AS [RelatedContact_CRMContactType],       
    '' AS [RelatedContact_ExternalReference],           
    0  AS [EventList_EventListId],           
    0  AS [CRMAssignedToUser_CRMContactId],       

	0  AS [RelatedJointContact_CRMContactId],
	'' AS [RelatedJointContact_LastName],       
    '' AS [RelatedJointContact_FirstName],       
    '' AS [RelatedJointContact_CorporateName],       
    '' AS [RelatedContactWithJoint_FullName],       

    '' AS [CRMAssignedToUser_LastName],       
    '' AS [CRMAssignedToUser_FirstName],                 
    0  AS [RelatedAdviceCase_AdviceCaseId],          
    '' AS [AdviceCase_Description],  
    '' AS [ActivityType],  
    '' AS [Task_StartDate],  
    0  AS [Task_IsDocumentExist],  
    '' AS [Task_PlanTypeName],  
    '' AS [Task_PlanTypeId],  
    '' AS [ActivityCategory_Name],
    0 AS [Task_IsBillable],
	'' AS [Task_SellingAdviserName],
	'' AS [Task_ServicingAdviserName],
	'' AS [Task_PlanTypeProdSubTypeName],
	'' AS [Task_ProviderName],
	'' AS [Task_SolicitorName],
	'' AS [Task_Timezone],
	'' AS [Task_AssignedTo]
   
END      
RETURN (0)  
   
  
  
  
GO
