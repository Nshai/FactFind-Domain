SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomNIODeleteTask]
	@TaskId int,
	@UserId bigint,
	@TenantId int
AS

-- lets do the organiser first
SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

Declare @StampDateTime datetime = GetDate()

BEGIN

	DELETE T1
		OUTPUT DELETED.[AppointmentId], DELETED.[ActivityCategoryParentId], DELETED.[ActivityCategoryId], DELETED.[TaskId], DELETED.[CompleteFG],
			DELETED.[PolicyId], DELETED.[FeeId], DELETED.[RetainerId], DELETED.[OpportunityId], DELETED.[EventListActivityId], DELETED.[CRMContactId],
			DELETED.[JointCRMContactId], DELETED.[IndigoClientId], DELETED.[AdviceCaseId], DELETED.[ConcurrencyId], DELETED.[OrganiserActivityId],
			'D', @StampDateTime, @UserId, DELETED.[IsRecurrence], DELETED.[RecurrenceSeriesId], DELETED.[MigrationRef], DELETED.[CreatedDate],
			DELETED.[CreatedByUserId], DELETED.[UpdatedOn], DELETED.[UpdatedByUserId]
		INTO [dbo].[TOrganiserActivityAudit]
			([AppointmentId], [ActivityCategoryParentId], [ActivityCategoryId], [TaskId], [CompleteFG],
			[PolicyId], [FeeId], [RetainerId], [OpportunityId], [EventListActivityId], [CRMContactId],
			[JointCRMContactId], [IndigoClientId], [AdviceCaseId], [ConcurrencyId], [OrganiserActivityId],
			[StampAction], [StampDateTime], [StampUser], [IsRecurrence], [RecurrenceSeriesId], [MigrationRef], [CreatedDate],
			[CreatedByUserId], [UpdatedOn], [UpdatedByUserId])
	FROM TOrganiserActivity T1
	WHERE T1.TaskId = @TaskId

	IF @@ERROR != 0 GOTO errh
	
	-- delete TTaskNote - can have more then one note
	DELETE T1
		OUTPUT DELETED.[CreatedBy], DELETED.[CreatedDate], DELETED.[LastEdited], DELETED.[Notes], DELETED.[TaskId],
			DELETED.[ConcurrencyId], DELETED.[TaskNoteId], 'D', @StampDateTime, @UserId, DELETED.[EditedBy],
			DELETED.[IsAvailableToPfpClient], DELETED.[MigrationRef]
		INTO [dbo].[TTaskNoteAudit]
			([CreatedBy], [CreatedDate], [LastEdited], [Notes], [TaskId],
			[ConcurrencyId], [TaskNoteId], [StampAction], [StampDateTime], [StampUser], [EditedBy],
			[IsAvailableToPfpClient], [MigrationRef])
	FROM TTaskNote T1
	WHERE T1.TaskId = @TaskId

	IF @@ERROR != 0 GOTO errh

	-- delete TTaskExtended
	DELETE T1
		OUTPUT DELETED.[TaskId], DELETED.[MigrationRef], DELETED.[IndigoClientId], DELETED.[ConcurrencyId],
			DELETED.[taskExtendedId],'D', @StampDateTime, @UserId
		INTO [dbo].[TTaskExtendedAudit]
			([TaskId], [MigrationRef], [IndigoClientId], [ConcurrencyId],
			[taskExtendedId], [StampAction], [StampDateTime], [StampUser])
	FROM TTaskExtended T1
	WHERE T1.TaskId = @TaskId

	IF @@ERROR != 0 GOTO errh

	DELETE T1
		OUTPUT DELETED.[StartDate], DELETED.[DueDate], DELETED.[PercentComplete], DELETED.[Notes], DELETED.[AssignedUserId],
			DELETED.[PerformedUserId], DELETED.[AssignedToUserId], DELETED.[AssignedToRoleId], DELETED.[ReminderId], DELETED.[Subject],
			DELETED.[RefPriorityId], DELETED.[Other], DELETED.[PrivateFg], DELETED.[DateCompleted], DELETED.[EstimatedTimeHrs],
			DELETED.[EstimatedTimeMins], DELETED.[ActualTimeHrs], DELETED.[ActualTimeMins], DELETED.[CRMContactId], DELETED.[URL],
			DELETED.[RefTaskStatusId], DELETED.[ActivityOutcomeId], DELETED.[SequentialRef], DELETED.[IndigoClientId], DELETED.[ReturnToRoleId],
			DELETED.[ConcurrencyId], DELETED.[EstimatedAmount], DELETED.[ActualAmount], DELETED.[TaskId], DELETED.[ShowinDiary], DELETED.[Guid],
			DELETED.[IsAvailableToPFPClient], 'D', @StampDateTime, @UserId, DELETED.[MigrationRef], DELETED.[IsBasedOnCompletionDate],
			DELETED.[OriginalDueDate], DELETED.[BillingRatePerHour], DELETED.[SpentTimeHrs], DELETED.[SpentTimeMins], DELETED.[Timezone]
		INTO [dbo].[TTaskAudit]
			([StartDate], [DueDate], [PercentComplete], [Notes], [AssignedUserId],
			[PerformedUserId], [AssignedToUserId], [AssignedToRoleId], [ReminderId], [Subject],
			[RefPriorityId], [Other], [PrivateFg], [DateCompleted], [EstimatedTimeHrs],
			[EstimatedTimeMins], [ActualTimeHrs], [ActualTimeMins], [CRMContactId], [URL],
			[RefTaskStatusId], [ActivityOutcomeId], [SequentialRef], [IndigoClientId], [ReturnToRoleId],
			[ConcurrencyId], [EstimatedAmount], [ActualAmount], [TaskId], [ShowinDiary], [Guid],
			[IsAvailableToPFPClient], [StampAction], [StampDateTime], [StampUser], [MigrationRef], [IsBasedOnCompletionDate],
			[OriginalDueDate], [BillingRatePerHour], [SpentTimeHrs], [SpentTimeMins], [Timezone])
	FROM TTask T1
	WHERE T1.TaskId = @TaskId AND T1.IndigoClientId = @TenantId

	IF @@ERROR != 0 GOTO errh
	IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
