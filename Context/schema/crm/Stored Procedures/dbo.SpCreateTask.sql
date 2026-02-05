SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateTask]
@StampUser varchar (255),
@StartDate datetime = NULL,
@DueDate datetime = NULL,
@PercentComplete int = 0,
@Notes varchar (8000) = NULL,
@AssignedUserId bigint = NULL,
@PerformedUserId bigint = NULL,
@AssignedToUserId bigint = NULL,
@AssignedToRoleId bigint = NULL,
@ReminderId bigint = NULL,
@Subject varchar (1000) = NULL,
@RefPriorityId bigint = NULL,
@Other varchar (8000) = NULL,
@PrivateFg tinyint = NULL,
@DateCompleted datetime = NULL,
@EstimatedTimeHrs int = NULL,
@EstimatedTimeMins int = NULL,
@ActualTimeHrs int = NULL,
@ActualTimeMins int = NULL,
@CRMContactId bigint = NULL,
@URL varchar (500) = NULL,
@RefTaskStatusId bigint = NULL,
@ActivityOutcomeId bigint = NULL,
@SequentialRef varchar (50) = NULL,
@IndigoClientId int,
@ReturnToRoleId bigint = NULL,
@Timezone varchar(100) = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @TaskId int

  IF @Timezone IS NULL
    SET @Timezone = (SELECT TOP 1 Timezone FROM Administration.dbo.TUser WHERE UserId = @AssignedUserId)

  INSERT INTO TTask (
    StartDate, 
    DueDate, 
    PercentComplete, 
    Notes, 
    AssignedUserId, 
    PerformedUserId, 
    AssignedToUserId, 
    AssignedToRoleId, 
    ReminderId, 
    Subject, 
    RefPriorityId, 
    Other, 
    PrivateFg, 
    DateCompleted, 
    EstimatedTimeHrs, 
    EstimatedTimeMins, 
    ActualTimeHrs, 
    ActualTimeMins, 
    CRMContactId, 
    URL, 
    RefTaskStatusId, 
    ActivityOutcomeId, 
    IndigoClientId, 
    ReturnToRoleId, 
    ConcurrencyId,
    Timezone ) 
  VALUES (
    @StartDate, 
    @DueDate, 
    @PercentComplete, 
    @Notes, 
    @AssignedUserId, 
    @PerformedUserId, 
    @AssignedToUserId, 
    @AssignedToRoleId, 
    @ReminderId, 
    @Subject, 
    @RefPriorityId, 
    @Other, 
    @PrivateFg, 
    @DateCompleted, 
    @EstimatedTimeHrs, 
    @EstimatedTimeMins, 
    @ActualTimeHrs, 
    @ActualTimeMins, 
    @CRMContactId, 
    @URL, 
    @RefTaskStatusId, 
    @ActivityOutcomeId, 
    @IndigoClientId, 
    @ReturnToRoleId, 
    1,
    @Timezone ) 

  SELECT @TaskId = SCOPE_IDENTITY()
  INSERT INTO TTaskAudit (
    StartDate, 
    DueDate,
	Timezone, 
    PercentComplete, 
    Notes, 
    AssignedUserId, 
    PerformedUserId, 
    AssignedToUserId, 
    AssignedToRoleId, 
    ReminderId, 
    Subject, 
    RefPriorityId, 
    Other, 
    PrivateFg, 
    DateCompleted, 
    EstimatedTimeHrs, 
    EstimatedTimeMins, 
    ActualTimeHrs, 
    ActualTimeMins, 
    CRMContactId, 
    URL, 
    RefTaskStatusId, 
    ActivityOutcomeId, 
    SequentialRef, 
    IndigoClientId, 
    ReturnToRoleId, 
    ConcurrencyId,
    TaskId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.StartDate, 
    T1.DueDate,
	T1.Timezone, 
    T1.PercentComplete, 
    T1.Notes, 
    T1.AssignedUserId, 
    T1.PerformedUserId, 
    T1.AssignedToUserId, 
    T1.AssignedToRoleId, 
    T1.ReminderId, 
    T1.Subject, 
    T1.RefPriorityId, 
    T1.Other, 
    T1.PrivateFg, 
    T1.DateCompleted, 
    T1.EstimatedTimeHrs, 
    T1.EstimatedTimeMins, 
    T1.ActualTimeHrs, 
    T1.ActualTimeMins, 
    T1.CRMContactId, 
    T1.URL, 
    T1.RefTaskStatusId, 
    T1.ActivityOutcomeId, 
    T1.SequentialRef, 
    T1.IndigoClientId, 
    T1.ReturnToRoleId, 
    T1.ConcurrencyId,
    T1.TaskId,
    'C',
    GetDate(),
    @StampUser

  FROM TTask T1
 WHERE T1.TaskId=@TaskId AND IndigoClientId = @IndigoClientId
  EXEC SpRetrieveTaskById @TaskId, @IndigoClientId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
