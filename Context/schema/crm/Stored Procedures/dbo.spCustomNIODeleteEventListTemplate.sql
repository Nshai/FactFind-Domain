SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].spCustomNIODeleteEventListTemplate
@EventListTemplateId bigint,
@UserId  int,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX
BEGIN
-- lets deal with the activelroles first
	insert into tactivityroleaudit (EventListTemplateActivityId,RoleId,ConcurrencyId,ActivityRoleId,StampAction,StampDateTime,StampUser)
	select A.EventListTemplateActivityId,A.RoleId,A.ConcurrencyId,A.ActivityRoleId, 'D', getdate(),@StampUser
	from tactivityrole A
	inner join TEventListTemplateActivity B on B.EventListTemplateActivityId=A.EventListTemplateActivityId
	where B.EventListTemplateId=@EventListTemplateId

	delete A
	from tactivityrole A
	inner join TEventListTemplateActivity B on B.EventListTemplateActivityId=A.EventListTemplateActivityId
	where B.EventListTemplateId=@EventListTemplateId

-- now lets do the eventlistactivitytemplates

	INSERT INTO TEventListTemplateActivityAudit (
		EventListTemplateId, ActivityCategoryId, FixedDateFg, DeletableFg, Duration, ElapsedDays, 
		EditElapsedDaysFg, AssignedUserId, ConcurrencyId,EventListTemplateActivityId, 
		StampAction, StampDateTime,StampUser)
	SELECT T1.EventListTemplateId, T1.ActivityCategoryId, T1.FixedDateFg, T1.DeletableFg, T1.Duration, 
		T1.ElapsedDays, T1.EditElapsedDaysFg, T1.AssignedUserId, T1.ConcurrencyId,T1.EventListTemplateActivityId,
		'D',GetDate(),@StampUser
	FROM TEventListTemplateActivity T1
	WHERE T1.EventListTemplateId = @EventListTemplateId

	DELETE T1 FROM TEventListTemplateActivity T1
	WHERE T1.EventListTemplateId = @EventListTemplateId

	-- now lets do the main TEventListTemplate

	INSERT INTO TEventListTemplateAudit(EventListTemplateId,[Name],AllowAddTaskFg,IndigoClientId,
	ClientRelatedFg,PlanRelatedFg,LeadRelatedFg,AdviserRelatedFg,SchemeRelatedFg,ConcurrencyId,StampAction,StampDateTime,StampUser)
	
	Select EventListTemplateId,[Name],AllowAddTaskFg,IndigoClientId,
	ClientRelatedFg,PlanRelatedFg,LeadRelatedFg,AdviserRelatedFg,SchemeRelatedFg,ConcurrencyId,'D',GetDate(),@StampUser
	FROM TEventListTemplate where EventListTemplateId=@EventListTemplateId 

	Delete T1 FROM TEventListTemplate T1 where EventListTemplateId=@EventListTemplateId 

	SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)



GO
