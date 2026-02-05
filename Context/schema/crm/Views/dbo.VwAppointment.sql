SET ANSI_NULLS ON
GO
CREATE View [dbo].[VwAppointment]
AS
SELECT T.AppointmentId AS Id,
                                                    A.IndigoClientId AS TenantId,
                                                    T.Subject,
                                                    T.Timezone,
                                                    A.CreatedByUserId,
                                                    CU.Identifier AS CreatedByUserName,
                                                    A.UpdatedByUserId,
                                                    UU.Identifier AS UpdatedByUserName,
                                                    A.UpdatedOn AS UpdatedAt,
                                                    A.CreatedDate AS CreatedAt,
	                                                A.CompleteFG As IsCompleted,
                                                    AC.Name AS [TypeName],
                                                    AC.ActivityCategoryId AS [TypeId],
                                                    AT.ActivityCategoryParentId AS CategoryId,
                                                    AT.Name AS CategoryName,
                                                    OU.UserId As OrganiserUserId,
                                                    OU.Identifier As OrganiserUserName,
                                                    AR.ActivityRecurrenceId as RecurrenceId,
                                                    AR.RFCCode AS RfcRule,
                                                    AR.StartDate AS RecurrenceStartsOn,
                                                    AR.EndDate AS RecurrenceEndsOn,
                                                    AO.ActivityOutcomeId AS OutcomeId,
                                                    AO.ActivityOutcomeName AS OutcomeName,
                                                    T.Notes,
	                                                T.StartTime As StartsAt,
	                                                T.EndTime As EndsAt,
                                                    T.AllDayEventFG as IsAllDay,
	                                                T.Location,
	                                                TCL.Name AS ClassificationName,
	                                                TCL.RefClassificationId AS ClassificationId,
	                                                TR.ReminderId,
	                                                TR.EmailNotificationFg As IsEmailNotification,
	                                                TR.ReminderDate AS ReminderOn,
	                                                TR.ReminderHours,
	                                                TR.ReminderMinutes,
                                                    A.PropertiesJson AS Properties,
                                                    T.ScratchFG AS ScratchFg,
                                                    T.ShowTimeAs As ShowTimeAs,
                                                    CASE
                                                        WHEN TL.LeadId IS NOT NULL AND TL.LeadId <> 0 THEN 'Lead'
                                                        WHEN TC.CRMContactId IS NOT NULL AND TC.CRMContactId  <> 0 THEN 'Client'
                                                    END AS RelatedToType,
                                                    CASE
                                                        WHEN TL.LeadId IS NOT NULL AND TL.LeadId <> 0 THEN TL.LeadId
                                                        WHEN TC.CRMContactId IS NOT NULL AND TC.CRMContactId  <> 0 THEN TC.CRMContactId
                                                    END AS RelatedToId,
                                                    CASE
                                                        WHEN TL.LeadId IS NOT NULL AND TL.LeadId <> 0 THEN ISNULL(TLC.FirstName,'') + ' ' + ISNULL(TLC.LastName,'') + ISNULL(TLC.CorporateName,'')
                                                        WHEN TC.CRMContactId IS NOT NULL AND TC.CRMContactId  <> 0 THEN ISNULL(TC.FirstName,'') + ' ' + ISNULL(TC.LastName,'')
                                                    END AS RelatedToName,
                                                    CASE 
                                                        WHEN TAJ.AccountId IS NOT NULL AND TAJ.AccountId <> 0 THEN 'Account'
                                                        WHEN TLJ.LeadId IS NOT NULL AND TLJ.LeadId <> 0 THEN 'Lead'
                                                        WHEN TCJ.CRMContactId IS NOT NULL AND TCJ.CRMContactId  <> 0 THEN 'Client'
                                                    END AS RelatedToJointType,
                                                    CASE 
                                                        WHEN TAJ.AccountId IS NOT NULL AND TAJ.AccountId <> 0 THEN TAJ.AccountId
                                                        WHEN TLJ.LeadId IS NOT NULL AND TLJ.LeadId <> 0 THEN TLJ.LeadId
                                                        WHEN TCJ.CRMContactId IS NOT NULL AND TCJ.CRMContactId  <> 0 THEN TCJ.CRMContactId
                                                    END AS RelatedToJointId,
                                                    CASE 
                                                        WHEN TAJ.AccountId IS NOT NULL AND TAJ.AccountId <> 0 THEN ISNULL(TAJC.FirstName,'') + ' ' + ISNULL(TAJC.LastName,'') + ISNULL(TAJC.CorporateName,'')
                                                        WHEN TLJ.LeadId IS NOT NULL AND TLJ.LeadId <> 0  THEN ISNULL(TLJC.FirstName,'') + ' ' + ISNULL(TLJC.LastName,'') + ISNULL(TLJC.CorporateName,'')
                                                        WHEN TCJ.CRMContactId IS NOT NULL AND TCJ.CRMContactId  <> 0  THEN ISNULL(TCJ.FirstName,'') + ' ' + ISNULL(TCJ.LastName,'') + ISNULL(TCJ.CorporateName,'')
                                                     END AS RelatedToJointName
													
FROM CRM.dbo.TAppointment T
                                                INNER JOIN
                                                    CRM.dbo.TOrganiserActivity A ON A.AppointmentId = T.AppointmentId
                                                INNER JOIN
                                                    CRM.dbo.TActivityCategory AC ON AC.ActivityCategoryParentId = A.ActivityCategoryParentId
                                                    AND AC.ActivityCategoryId = A.ActivityCategoryId AND AC.IndigoClientId = A.IndigoClientId
                                                INNER JOIN
                                                    CRM.dbo.TActivityCategoryParent AT ON AT.ActivityCategoryParentId = A.ActivityCategoryParentId
                                                    AND AT.IndigoClientId = A.IndigoClientId
                                                LEFT OUTER JOIN
                                                    CRM.dbo.TActivityRecurrence AR ON AR.OrganiserActivityId = A.OrganiserActivityId
                                                LEFT OUTER JOIN
                                                    CRM.dbo.TActivityOutcome AO ON AO.ActivityOutcomeId = T.ActivityOutcomeId
	                                                AND AO.IndigoClientId = A.IndigoClientId
                                                LEFT OUTER JOIN
                                                    Administration.dbo.TUser CU ON CU.UserId = A.CreatedByUserId
	                                                AND CU.IndigoClientId = A.IndigoClientId
                                                LEFT OUTER JOIN
                                                    Administration.dbo.TUser UU ON UU.UserId = A.UpdatedByUserId
	                                                AND UU.IndigoClientId = A.IndigoClientId
                                                LEFT OUTER JOIN
                                                    Administration.dbo.TUser OU ON OU.CRMContactId = T.OrganizerCRMContactId
	                                                AND CU.IndigoClientId = A.IndigoClientId
                                                LEFT OUTER JOIN
                                                    CRM.dbo.TLead TL ON TL.CRMContactId = A.CRMContactId
	                                                AND TL.IndigoClientId = A.IndigoClientId
                                                LEFT OUTER JOIN
                                                    CRM.dbo.TCRMContact TLC ON TLC.CRMContactId = TL.CRMContactId
                                                    AND TLC.IndClientId = TL.IndigoClientId
                                                    AND TLC.[RefCRMContactStatusId]=2
                                                LEFT OUTER JOIN
                                                        CRM.dbo.TAccount TAJ ON TAJ.CRMContactId = A.JointCRMContactId AND TAJ.IndigoClientId = A.IndigoClientId
                                                LEFT OUTER JOIN 
                                                    CRM.dbo.TCRMContact TAJC ON TAJC.CRMContactId = TAJ.CRMContactId AND TAJC.IndClientId = TAJ.IndigoClientId
                                                LEFT OUTER JOIN
                                                    CRM.dbo.TLead TLJ ON TLJ.CRMContactId = A.JointCRMContactId
	                                                AND TLJ.IndigoClientId = A.IndigoClientId
                                                LEFT OUTER JOIN
                                                    CRM.dbo.TCRMContact TLJC ON TLJC.CRMContactId = TLJ.CRMContactId
	                                                AND TLJC.IndClientId = TLJ.IndigoClientId
	                                                AND TLJC.[RefCRMContactStatusId]=2
                                                LEFT OUTER JOIN
                                                    CRM.dbo.TCRMContact TC ON TC.CRMContactId = A.CRMContactId
	                                                AND TC.IndClientId = A.IndigoClientId AND TC.RefCRMContactStatusId=1
                                                LEFT OUTER JOIN
                                                    CRM.dbo.TCRMContact TCJ ON TCJ.CRMContactId = A.JointCRMContactId
	                                                AND TCJ.IndClientId = A.IndigoClientId AND TCJ.RefCRMContactStatusId=1
                                                LEFT OUTER JOIN
                                                    CRM.dbo.TRefClassification TCl ON Tcl.RefClassificationId = T.RefClassificationId
                                                LEFT OUTER JOIN
                                                    CRM.dbo.TReminder TR ON TR.ReminderId = T.ReminderId
	                                                and TR.IndClientId = A.IndigoClientId