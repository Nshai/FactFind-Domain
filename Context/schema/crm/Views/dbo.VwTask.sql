SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE View [dbo].[VwTask]
AS
SELECT  distinct
    T.TaskId AS Id,
    T.IndigoClientId AS TenantId,
    T.RefTaskStatusId AS StatusId,
    TS.Name AS [Status],
    T.Subject,
    AC.Description,
    T.AssignedUserId AS AssignedByUserId,
    U.Identifier AS AssignedByUserName,
    T.AssignedToUserId,
    UT.Identifier AS AssignedToUserName,
    T.AssignedToRoleId,
    R.Identifier AS AssignedToRoleName,
    T.BillingRatePerHour AS BillingAmount,
    T.DueDate,
    T.EstimatedTimeHrs,
    T.EstimatedTimeMins,
    T.SpentTimeHrs,
    T.SpentTimeMins,
    T.ActualTimeHrs,
    T.ActualTimeMins,
    T.EstimatedAmount,
    T.ActualAmount,
    T.IsAvailableToPFPClient AS ShowInPortal,
    T.PercentComplete,
    T.DateCompleted AS CompletedAt,
    T.PerformedUserId AS CompletedById,
    UP.Identifier AS CompletedByName,
    T.SequentialRef AS Reference,
    T.ShowinDiary,
    T.StartDate,
    T.Timezone,
    A.CreatedByUserId,
    CU.Identifier AS CreatedByUserName,
    A.UpdatedByUserId,
    UU.Identifier AS UpdatedByUserName,
    A.UpdatedOn AS UpdatedAt,
    A.CreatedDate AS CreatedAt,
    AC.Name AS [TypeName],
    AC.ActivityCategoryId AS [TypeId],
    AT.ActivityCategoryParentId AS CategoryId,
    AT.Name AS CategoryName,
    P.RefPriorityId AS PriorityId,
    P.PriorityName AS PriorityName,
    A.PolicyId AS RelatedPlanId,
    A.FeeId AS RelatedFeeId,
    A.OpportunityId AS RelatedOpportunityId,
    A.AdviceCaseId AS RelatedServiceCaseId,
    AR.RFCCode AS RfcRule,
    AR.StartDate AS RecurrenceStartsOn,
    AR.EndDate AS RecurrenceEndsOn,
    AR.ActivityRecurrenceId,
    AO.ActivityOutcomeId AS OutcomeId,
    AO.ActivityOutcomeName AS OutcomeName,
    T.Notes,
    T.Other,
    T.IsBasedOnCompletionDate,
    T.PrivateFg,
    T.MigrationRef,
    T.LastUpdated,
    T.WorkflowName AS Workflow,
    A.PropertiesJson AS Properties,
    A.EventListActivityId,
CASE 
    WHEN pf.TaskId IS NOT NULL AND pf.TaskId <> 0 THEN 1
    ELSE 0
END AS IsBillable,

    CASE 
        WHEN A.AdviceCaseId IS NOT NULL AND A.AdviceCaseId <> 0 THEN A.AdviceCaseId
        WHEN A.OpportunityId IS NOT NULL AND A.OpportunityId <> 0 THEN A.OpportunityId
        WHEN A.PolicyId IS NOT NULL AND A.PolicyId <> 0 THEN A.PolicyId
        WHEN A.FeeId IS NOT NULL AND A.FeeId <> 0 THEN A.FeeId
    END AS LinkedEntityId,

	    CASE 
        WHEN A.AdviceCaseId IS NOT NULL AND A.AdviceCaseId <> 0 THEN 'ServiceCase'
        WHEN A.OpportunityId IS NOT NULL AND A.OpportunityId <> 0 THEN 'Opportunity'
        WHEN A.PolicyId IS NOT NULL AND A.PolicyId <> 0 THEN 'Plan'
        WHEN A.FeeId IS NOT NULL AND A.FeeId <> 0 THEN 'Fee'
    END AS LinkedEntityType,

    CASE 
        WHEN TA.AccountId IS NOT NULL AND TA.AccountId <> 0 THEN 'Account'
        WHEN AD.PractitionerId IS NOT NULL AND AD.PractitionerId <> 0 THEN 'Adviser'
        WHEN TL.LeadId IS NOT NULL AND TL.LeadId <> 0 THEN 'Lead'
        WHEN TC.CRMContactId IS NOT NULL AND TC.CRMContactId  <> 0 THEN 'Client'
    END AS RelatedToType,
    CASE 
        WHEN TA.AccountId IS NOT NULL AND TA.AccountId <> 0  THEN TA.AccountId
        WHEN AD.PractitionerId IS NOT NULL AND AD.PractitionerId <> 0 THEN AD.PractitionerId
        WHEN TL.LeadId IS NOT NULL AND TL.LeadId <> 0 THEN TL.LeadId
        WHEN TC.CRMContactId IS NOT NULL AND TC.CRMContactId  <> 0 THEN TC.CRMContactId
    END AS RelatedToId,
    CASE 
        WHEN TA.AccountId IS NOT NULL AND TA.AccountId <> 0 THEN ISNULL(TAC.FirstName,'') + ' ' + ISNULL(TAC.LastName,'') + ISNULL(TAC.CorporateName,'')
        WHEN AD.PractitionerId IS NOT NULL AND AD.PractitionerId <> 0 THEN ISNULL(ADC.FirstName,'') + ' ' + ISNULL(ADC.LastName,'')
        WHEN TL.LeadId IS NOT NULL AND TL.LeadId <> 0 THEN ISNULL(TLC.FirstName,'') + ' ' + ISNULL(TLC.LastName,'') + ISNULL(TLC.CorporateName,'')
        WHEN TC.CRMContactId IS NOT NULL AND TC.CRMContactId  <> 0 THEN ISNULL(TC.FirstName,'') + ' ' + ISNULL(TC.LastName,'')
    END AS RelatedToName,
    CASE 
        WHEN TAJ.AccountId IS NOT NULL AND TAJ.AccountId <> 0 THEN 'Account'
        WHEN ADJ.PractitionerId IS NOT NULL AND ADJ.PractitionerId <> 0 THEN 'Adviser'
        WHEN TLJ.LeadId IS NOT NULL AND TLJ.LeadId <> 0 THEN 'Lead'
        WHEN TCJ.CRMContactId IS NOT NULL AND TCJ.CRMContactId  <> 0 THEN 'Client'
    END AS RelatedToJointType,
    CASE 
        WHEN TAJ.AccountId IS NOT NULL AND TAJ.AccountId <> 0 THEN TAJ.AccountId
        WHEN ADJ.PractitionerId IS NOT NULL AND ADJ.PractitionerId <> 0  THEN ADJ.PractitionerId
        WHEN TLJ.LeadId IS NOT NULL AND TLJ.LeadId <> 0 THEN TLJ.LeadId
        WHEN TCJ.CRMContactId IS NOT NULL AND TCJ.CRMContactId  <> 0 THEN TCJ.CRMContactId
    END AS RelatedToJointId,
    CASE 
        WHEN TAJ.AccountId IS NOT NULL AND TAJ.AccountId <> 0 THEN ISNULL(TAJC.FirstName,'') + ' ' + ISNULL(TAJC.LastName,'') + ISNULL(TAJC.CorporateName,'')
        WHEN ADJ.PractitionerId IS NOT NULL AND ADJ.PractitionerId <> 0  THEN ISNULL(ADJC.FirstName,'') + ' ' + ISNULL(ADJC.LastName,'')
        WHEN TLJ.LeadId IS NOT NULL AND TLJ.LeadId <> 0  THEN ISNULL(TLJC.FirstName,'') + ' ' + ISNULL(TLJC.LastName,'') + ISNULL(TLJC.CorporateName,'')
        WHEN TCJ.CRMContactId IS NOT NULL AND TCJ.CRMContactId  <> 0  THEN ISNULL(TCJ.FirstName,'') + ' ' + ISNULL(TCJ.LastName,'') + ISNULL(TCJ.CorporateName,'')
    END AS RelatedToJointName


FROM
    CRM.dbo.TTask T
INNER JOIN 
    CRM.dbo.TOrganiserActivity A ON A.TaskId = T.TaskId AND A.IndigoClientId = T.IndigoClientId
INNER JOIN 
    CRM.dbo.TActivityCategory AC ON AC.ActivityCategoryParentId = A.ActivityCategoryParentId 
    AND AC.ActivityCategoryId = A.ActivityCategoryId AND AC.IndigoClientId = A.IndigoClientId
INNER JOIN 
    CRM.dbo.TActivityCategoryParent AT ON AT.ActivityCategoryParentId = A.ActivityCategoryParentId 
    AND AT.IndigoClientId = A.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TRefTaskStatus TS ON TS.RefTaskStatusId = T.RefTaskStatusId
LEFT OUTER JOIN 
    CRM.dbo.TRefPriority P ON P.RefPriorityId = T.RefPriorityId AND P.IndClientId = T.IndigoClientId
LEFT OUTER JOIN 
    Administration.dbo.TUser U WITH (NOLOCK) ON U.UserId = T.AssignedUserId AND U.IndigoClientId = T.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TActivityRecurrence AR ON AR.OrganiserActivityId = A.OrganiserActivityId
LEFT OUTER JOIN 
    CRM.dbo.TActivityOutcome AO ON AO.ActivityOutcomeId = T.ActivityOutcomeId AND AO.IndigoClientId = T.IndigoClientId
LEFT OUTER JOIN 
    Administration.dbo.TUser UT WITH (NOLOCK) ON UT.UserId = T.AssignedToUserId AND UT.IndigoClientId = T.IndigoClientId
LEFT OUTER JOIN 
    Administration.dbo.TUser UP WITH (NOLOCK) ON UP.UserId = T.PerformedUserId AND UP.IndigoClientId = T.IndigoClientId
LEFT OUTER JOIN 
    Administration.dbo.TUser CU WITH (NOLOCK) ON CU.UserId = A.CreatedByUserId AND CU.IndigoClientId = A.IndigoClientId
LEFT OUTER JOIN 
    Administration.dbo.TUser UU WITH (NOLOCK) ON UU.UserId = A.UpdatedByUserId AND UU.IndigoClientId = A.IndigoClientId
LEFT OUTER JOIN 
    Administration.dbo.TRole R WITH (NOLOCK) ON R.RoleId = T.AssignedToRoleId AND R.IndigoClientId = T.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TCRMContact TC ON TC.CRMContactId = A.CRMContactId AND TC.IndClientId = A.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TCRMContact TCJ ON TCJ.CRMContactId = A.JointCRMContactId AND TCJ.IndClientId = A.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TAccount TA ON TA.CRMContactId = A.CRMContactId AND TA.IndigoClientId = T.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TCRMContact TAC ON TAC.CRMContactId = TA.CRMContactId AND TAC.IndClientId = TA.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TPractitioner AD ON AD.CRMContactId = A.CRMContactId AND AD.IndClientId = T.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TCRMContact ADC ON ADC.CRMContactId = AD.CRMContactId AND ADC.IndClientId = AD.IndClientId
LEFT OUTER JOIN 
    CRM.dbo.TLead TL ON TL.CRMContactId = A.CRMContactId AND TL.IndigoClientId = T.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TCRMContact TLC ON TLC.CRMContactId = TL.CRMContactId AND TLC.IndClientId = TL.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TAccount TAJ ON TAJ.CRMContactId = A.JointCRMContactId AND TAJ.IndigoClientId = T.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TCRMContact TAJC ON TAJC.CRMContactId = TAJ.CRMContactId AND TAJC.IndClientId = TAJ.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TPractitioner ADJ ON ADJ.CRMContactId = A.JointCRMContactId AND ADJ.IndClientId = T.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TCRMContact ADJC ON ADJC.CRMContactId = ADJ.CRMContactId AND ADJC.IndClientId = ADJ.IndClientId
LEFT OUTER JOIN 
    CRM.dbo.TLead TLJ ON TLJ.CRMContactId = A.JointCRMContactId AND TLJ.IndigoClientId = T.IndigoClientId
LEFT OUTER JOIN 
    CRM.dbo.TCRMContact TLJC ON TLJC.CRMContactId = TLJ.CRMContactId AND TLJC.IndClientId = TLJ.IndigoClientId
LEFT OUTER JOIN  policymanagement..TFeeToTask Pf WITH (NOLOCK) ON pf.TaskId =T.TaskId