SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateOrganiserActivity]
@StampUser varchar (255),
@AppointmentId bigint = NULL,
@ActivityCategoryParentId bigint = NULL,
@ActivityCategoryId bigint = NULL,
@TaskId int = NULL,
@CompleteFG bit = 0,
@PolicyId bigint = NULL,
@FeeId bigint = NULL,
@RetainerId bigint = NULL,
@OpportunityId bigint = NULL,
@EventListActivityId bigint = NULL,
@CRMContactId bigint = NULL,
@IndigoClientId bigint = NULL,
@AdviceCaseId bigint = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @OrganiserActivityId bigint

  INSERT INTO TOrganiserActivity (
    AppointmentId, 
    ActivityCategoryParentId, 
    ActivityCategoryId, 
    TaskId, 
    CompleteFG, 
    PolicyId, 
    FeeId, 
    RetainerId, 
    OpportunityId, 
    EventListActivityId, 
    CRMContactId, 
    IndigoClientId, 
    AdviceCaseId, 
    ConcurrencyId ) 
  VALUES (
    @AppointmentId, 
    @ActivityCategoryParentId, 
    @ActivityCategoryId, 
    @TaskId, 
    @CompleteFG, 
    @PolicyId, 
    @FeeId, 
    @RetainerId, 
    @OpportunityId, 
    @EventListActivityId, 
    @CRMContactId, 
    @IndigoClientId, 
    @AdviceCaseId, 
    1) 

  SELECT @OrganiserActivityId = SCOPE_IDENTITY()
  INSERT INTO TOrganiserActivityAudit (
    AppointmentId, 
    ActivityCategoryParentId, 
    ActivityCategoryId, 
    TaskId, 
    CompleteFG, 
    PolicyId, 
    FeeId, 
    RetainerId, 
    OpportunityId, 
    EventListActivityId, 
    CRMContactId, 
    IndigoClientId, 
    AdviceCaseId, 
    ConcurrencyId,
    OrganiserActivityId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.AppointmentId, 
    T1.ActivityCategoryParentId, 
    T1.ActivityCategoryId, 
    T1.TaskId, 
    T1.CompleteFG, 
    T1.PolicyId, 
    T1.FeeId, 
    T1.RetainerId, 
    T1.OpportunityId, 
    T1.EventListActivityId, 
    T1.CRMContactId, 
    T1.IndigoClientId, 
    T1.AdviceCaseId, 
    T1.ConcurrencyId,
    T1.OrganiserActivityId,
    'C',
    GetDate(),
    @StampUser

  FROM TOrganiserActivity T1
 WHERE T1.OrganiserActivityId=@OrganiserActivityId
  EXEC SpRetrieveOrganiserActivityById @OrganiserActivityId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
