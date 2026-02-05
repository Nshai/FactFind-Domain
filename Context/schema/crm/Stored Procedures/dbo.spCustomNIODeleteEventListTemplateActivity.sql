SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomNIODeleteEventListTemplateActivity]
@EventListTemplateActivityId bigint,
@UserId  int,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN

  --lets deal with the role deletes

  DELETE FROM TActivityRole Where EventListTemplateActivityId=@EventListTemplateActivityId

  INSERT INTO TEventListTemplateActivityAudit (
    EventListTemplateId, 
    ActivityCategoryId, 
    FixedDateFg, 
    DeletableFg, 
    Duration, 
    ElapsedDays, 
    EditElapsedDaysFg, 
    AssignedUserId, 
    ConcurrencyId,
    EventListTemplateActivityId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.EventListTemplateId, 
    T1.ActivityCategoryId, 
    T1.FixedDateFg, 
    T1.DeletableFg, 
    T1.Duration, 
    T1.ElapsedDays, 
    T1.EditElapsedDaysFg, 
    T1.AssignedUserId, 
    T1.ConcurrencyId,
    T1.EventListTemplateActivityId,
    'D',
    GetDate(),
    @StampUser

  FROM TEventListTemplateActivity T1
  WHERE T1.EventListTemplateActivityId = @EventListTemplateActivityId
  
DELETE T1 FROM TEventListTemplateActivity T1
WHERE T1.EventListTemplateActivityId = @EventListTemplateActivityId


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)


GO
