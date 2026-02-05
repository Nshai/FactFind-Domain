--Drop Procedure dbo.SpNioCustomListExternalApplicationOrganiserActivity

Create Procedure dbo.SpNioCustomListExternalApplicationOrganiserActivity
	@TenantId bigint,
	@UserId bigint,
	@TopNRecords int,
	@NewItems bit,
	@UpdatedItems bit,	
	@TimeStamp datetime,
	@StampUserId bigint,
	@SessionId uniqueidentifier

	AS

If IsNull(@TenantId,0) = 0
Begin
	Raiserror('TenantId null', 16,1)
	Return
End

If IsNull(@UserId,0) = 0
Begin
	Raiserror('UserId null', 16,1)
	Return
End

If IsNull(@TopNRecords,0) = 0
Begin
	Raiserror('TopNRecords null', 16,1)
	Return
End

If IsNull(@TimeStamp,0) = 0 
Begin
	Set @TimeStamp = GETDATE()
End


if object_id('tempdb..#appointments') is not null drop table #appointments


SET ROWCOUNT @TopNRecords

SELECT 
ex.ExternalApplicationOrganiserActivityId,
ISNULL(ex.ExternalReference,'') As ExternalReference,
O.OrganiserActivityId,
A.AppointmentId,
A.CRMContactId As PartyId
INTO #appointments 
FROM TExternalApplicationOrganiserActivity ex
Join TOrganiserActivity O on ex.OrganiserActivityId = O.OrganiserActivityId
Join TAppointment A ON O.AppointmentId = A.AppointmentId
Left Join TAttendees at ON at.AppointmentId = A.AppointmentId
Left Join TCRMContact ac ON ac.CRMContactId = at.CRMContactId
Left Join administration..TUser au ON au.CRMContactId = ac.CRMContactId
WHERE 
ex.TenantId = @TenantId AND
ex.IsForNewSync = @NewItems AND
ex.IsForUpdateSync = @UpdatedItems AND
ex.IsDeleted = 0 
And (ex.SessionId is null or ex.SessionId <> @SessionId)
And IsNull(ex.RetryCount,0) > 0
And ISNULL(au.UserId, 0) = @UserId


SET ROWCOUNT 0


Alter table #appointments Add Attendees varchar(max) default('')

update a
set Attendees = Convert(varchar(max), (
	select ',' +  CASE WHEN ISNULL(u.Email, '') <> '' THEN u.Email ELSE  con.Value END
	from crm..TAttendees at
	left join administration..TUser u on u.CRMContactId = at.CRMContactId
	left join crm..TContact con on con.CRMContactId = at.CRMContactId and con.RefContactType='E-Mail' and con.DefaultFg = 1
	Where at.CRMContactId IS NOT Null AND (ISNULL(u.Email, '') <> '' OR ISNULL(con.Value, '') <> '')
	and at.AppointmentId = a.AppointmentId
	for xml path(''), type
))
From #appointments a


if object_id('tempdb..#ClientEmailAddresses') is not null 
	drop table #ClientEmailAddresses
Create Table #ClientEmailAddresses (mId bigint Identity(1,1), ContactId bigint, CRMContactId bigint)

Insert Into #ClientEmailAddresses
(ContactId, CRMContactId)
Select b.ContactId, b.CRMContactId
from #appointments a
inner Join TContact b on a.PartyId = b.CRMContactId
where RefContactType='E-Mail' and b.IndClientId = @TenantId
Order by DefaultFg desc, b.ContactId desc

delete from #ClientEmailAddresses Where mId not in (select Min(mId) from #ClientEmailAddresses Group by CRMContactId)

Alter table #appointments Add PartyEmailAddress varchar(100)

Update a
Set PartyEmailAddress = d.Value
From #appointments a
Join #ClientEmailAddresses c on a.PartyId = c.CRMContactId
join TContact d on c.ContactId = d.ContactId

Insert Into dbo.TExternalApplicationOrganiserActivityAudit
(ExternalApplicationOrganiserActivityId,TenantId,UserId,OrganiserActivityId,AppointmentId,CreatedDateTime,LastUpdatedDateTime,
	LastSynchronisedDateTime,ExternalReference,IsForNewSync,IsForUpdateSync,IsForDeleteSync,IsDeleted,
	StampAction,StampDateTime,StampUser,InternalReference,SessionId)
Select a.ExternalApplicationOrganiserActivityId,TenantId,UserId,a.OrganiserActivityId,a.AppointmentId,CreatedDateTime,LastUpdatedDateTime,
	LastSynchronisedDateTime,a.ExternalReference,IsForNewSync,IsForUpdateSync,IsForDeleteSync,IsDeleted,
	'U',getdate(), @StampUserId, InternalReference, SessionId
From TExternalApplicationOrganiserActivity a
Join #appointments b on a.ExternalApplicationOrganiserActivityId = b.ExternalApplicationOrganiserActivityId


If @NewItems = 1
Begin
	Update a
	set SessionId = @SessionId, RetryCount = IsNull(RetryCount,0) - 1
	From TExternalApplicationOrganiserActivity a
	Join #appointments b on a.ExternalApplicationOrganiserActivityId = b.ExternalApplicationOrganiserActivityId
End
Else If @UpdatedItems = 1
Begin
	Update a
	set SessionId = @SessionId, IsForUpdateSync = 0
	From TExternalApplicationOrganiserActivity a
	Join #appointments b on a.ExternalApplicationOrganiserActivityId = b.ExternalApplicationOrganiserActivityId
End

SELECT
ex.ExternalApplicationOrganiserActivityId As ExternalDataId,
A.CRMContactId As PartyId,
O.JointCRMContactId As JointPartyId,
ISNULL(ex.ExternalReference,'') As ExternalReference,
A.[Guid] As InternalReference,
A.AllDayEventFG As IsAllDayEvent,
A.StartTime,
A.EndTime,
A.Location,
A.[Subject],
A.Notes,
ou.UserId OrganiserUserId,
CASE
	WHEN oup.CRMContactId IS NOT NULL 
	THEN oup.FirstName + ' ' + oup.LastName  
	ELSE cup.FirstName + ' ' + cup.LastName  
END		AS Organiser,
CASE
	WHEN ou.CRMContactId IS NOT NULL 
	THEN ou.Email
	ELSE cu.Email
END		AS OrganiserEmail,
CASE
	WHEN R.ReminderId IS NOT NULL 
	THEN 1 ELSE 0
END		AS HasReminder,
R.ReminderMinutes As ReminderInMinutes,
O.IsRecurrence,
CASE
	WHEN ORR.ActivityRecurrenceId IS NOT NULL 
	THEN 1 ELSE 0
END		AS HasActivityRecurrence,
ORR.RFCCode,
ORR.StartDate As PatternStartDate,
ORR.EndDate As PatternEndDate,
app.Attendees,
app.PartyEmailAddress
FROM crm..TExternalApplicationOrganiserActivity ex
Join #appointments app on app.AppointmentId = ex.AppointmentId
Join crm..TOrganiserActivity O on ex.OrganiserActivityId = O.OrganiserActivityId
Join crm..TAppointment A ON O.AppointmentId = A.AppointmentId
left Join crm..TCRMContact oup on oup.CRMContactId = A.OrganizerCRMContactId
left Join administration..TUser ou on ou.CRMContactId = oup.CRMContactId
Join administration..TUser cu on cu.UserId = A.CreatedByUserId
Join crm..TCRMContact cup on cup.CRMContactId = cu.CRMContactId

Left Join crm..TReminder R on R.ReminderId = A.ReminderId
Left Join crm..TActivityRecurrence AR on AR.OrganiserActivityId = O.OrganiserActivityId 
Left Join
(
	SELECT
	Max(ActivityRecurrenceId)  As ActivityRecurrenceId,
	OrganiserActivityId
    FROM
    crm..TActivityRecurrence ar
	GROUP BY
    OrganiserActivityId
) 
rec on rec.OrganiserActivityId = O.OrganiserActivityId
left Join crm..TActivityRecurrence ORR on ORR.ActivityRecurrenceId = rec.ActivityRecurrenceId


