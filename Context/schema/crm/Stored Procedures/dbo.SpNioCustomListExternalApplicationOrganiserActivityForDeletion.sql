--Drop Procedure SpNioCustomListExternalApplicationOrganiserActivityForDeletion

Create Procedure SpNioCustomListExternalApplicationOrganiserActivityForDeletion
	@TenantId bigint, 
	@UserId bigint, 
	@TopNRecords bigint, 
	@StampUserId bigint, 
	@SessionId uniqueidentifier

As



if object_id('tempdb..#appointments') is not null drop table #appointments

SET ROWCOUNT @TopNRecords

SELECT ExternalApplicationOrganiserActivityId, InternalReference
INTO #appointments
FROM TExternalApplicationOrganiserActivity ex
Where 1=1
And ex.IsForDeleteSync = 1 and ex.IsDeleted = 1
And TenantId = @TenantId
And UserId = @UserId
And IsNull(RetryCount,0) > 0
And (ex.SessionId is null or ex.SessionId <> @SessionId)


SET ROWCOUNT 0


Insert Into TExternalApplicationOrganiserActivityAudit
( ExternalApplicationOrganiserActivityId, TenantId,UserId,OrganiserActivityId,AppointmentId,CreatedDateTime,LastUpdatedDateTime,
	LastSynchronisedDateTime,ExternalReference,IsForNewSync,IsForUpdateSync,IsForDeleteSync,IsDeleted,
	StampAction,StampDateTime,StampUser,InternalReference,SessionId)
Select ex.ExternalApplicationOrganiserActivityId, TenantId,UserId,OrganiserActivityId,AppointmentId,CreatedDateTime,LastUpdatedDateTime,
	LastSynchronisedDateTime,ExternalReference,IsForNewSync,IsForUpdateSync,IsForDeleteSync,IsDeleted,
	'U',getdate(),@StampUserId, ex.InternalReference,SessionId
From TExternalApplicationOrganiserActivity ex
Join #appointments app on ex.ExternalApplicationOrganiserActivityId = app.ExternalApplicationOrganiserActivityId

Update ex
Set SessionId = @SessionId, ex.IsForDeleteSync = 0
From TExternalApplicationOrganiserActivity ex
Join #appointments app on ex.ExternalApplicationOrganiserActivityId = app.ExternalApplicationOrganiserActivityId

select * 
From  #appointments

