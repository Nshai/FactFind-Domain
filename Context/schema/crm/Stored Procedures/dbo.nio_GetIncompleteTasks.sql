set ansi_nulls on
go

set quoted_identifier on
go

-- =============================================
-- Author:		Yury Zakharov
-- Create date: 2024-11-08
-- Description:	Gets non-completed tasks for specific party.
-- =============================================
create procedure [dbo].[nio_GetIncompleteTasks] 
	@partyId int = 0
as
begin
	set nocount on;
	;with TasksCte as (
    select 
        t.TaskId as [Id]
        ,t.Subject as [Subject]
        ,t.SequentialRef as [Reference]
        ,t.DueDate as [DueAt]
        ,case
	        when TA.AccountId is not null and TA.AccountId <> 0  then TA.AccountId
	        when AD.PractitionerId is not null and AD.PractitionerId <> 0 then AD.PractitionerId
	        when TL.LeadId is not null and TL.LeadId <> 0 then TL.LeadId
	        when TC.CRMContactId is not null and TC.CRMContactId  <> 0 then TC.CRMContactId
        end as [RelatedToId]
        ,case
	        when TAJ.AccountId is not null and TAJ.AccountId <> 0 then TAJ.AccountId
	        when ADJ.PractitionerId is not null and ADJ.PractitionerId <> 0  then ADJ.PractitionerId
	        when TLJ.LeadId is not null and TLJ.LeadId <> 0 then TLJ.LeadId
	        when TCJ.CRMContactId is not null and TCJ.CRMContactId  <> 0 then TCJ.CRMContactId
        end as [RelatedToJointId]
    from crm.dbo.TTask as t
    inner join policymanagement.dbo.TFeeToTask as ftt on t.TaskId = ftt.TaskId
    left join crm.dbo.TOrganiserActivity as A on A.TaskId = T.TaskId and A.IndigoClientId = T.IndigoClientId
    left join crm.dbo.TAccount as TA on TA.CRMContactId = A.CRMContactId and TA.IndigoClientId = T.IndigoClientId
    left join crm.dbo.TPractitioner AD on AD.CRMContactId = A.CRMContactId and AD.IndClientId = T.IndigoClientId
    left join crm.dbo.TCRMContact as TC on TC.CRMContactId = A.CRMContactId and TC.IndClientId = A.IndigoClientId
    left join crm.dbo.TLead as TL on TL.CRMContactId = A.CRMContactId and TL.IndigoClientId = T.IndigoClientId
    left join crm.dbo.TAccount as TAJ on TAJ.CRMContactId = A.JointCRMContactId and TAJ.IndigoClientId = T.IndigoClientId
    left join crm.dbo.TPractitioner as ADJ on ADJ.CRMContactId = A.JointCRMContactId and ADJ.IndClientId = T.IndigoClientId
    left join crm.dbo.TLead as TLJ on TLJ.CRMContactId = A.JointCRMContactId and TLJ.IndigoClientId = T.IndigoClientId
    left join crm.dbo.TCRMContact TCJ on TCJ.CRMContactId = A.JointCRMContactId and TCJ.IndClientId = A.IndigoClientId
    where t.RefTaskStatusId <> 2)
    select 
        [Id]
        ,[Subject]
        ,[Reference]
        ,[DueAt]
    from TasksCte
	where [RelatedToId] = @partyId or [RelatedToJointId] = @partyId
    order by [Id];
end;
go
