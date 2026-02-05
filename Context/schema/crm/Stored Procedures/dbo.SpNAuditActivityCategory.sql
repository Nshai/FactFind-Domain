
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditActivityCategory]
	@StampUser varchar (255),
	@ActivityCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TActivityCategoryAudit 
( Name, ActivityCategoryParentId, LifeCycleTransitionId, IndigoClientId, 
		ClientRelatedFG, PlanRelatedFG, FeeRelatedFG, RetainerRelatedFG, 
		OpportunityRelatedFG, AdviserRelatedFg, ActivityEvent, RefSystemEventId, 
		TemplateTypeId, TemplateId, ConcurrencyId, 
	ActivityCategoryId, StampAction, StampDateTime, StampUser,IsArchived, GroupId, IsPropagated,TaskBillingRate,EstimatedTimeHrs,EstimatedTimeMins,
	DocumentDesignerTemplateId, Description, RefPriorityId,IsMandatoryTaskCheckList) 
Select Name, ActivityCategoryParentId, LifeCycleTransitionId, IndigoClientId, 
		ClientRelatedFG, PlanRelatedFG, FeeRelatedFG, RetainerRelatedFG, 
		OpportunityRelatedFG, AdviserRelatedFg, ActivityEvent, RefSystemEventId, 
		TemplateTypeId, TemplateId, ConcurrencyId, 
	ActivityCategoryId, @StampAction, GetDate(), @StampUser,IsArchived,GroupId, IsPropagated,TaskBillingRate,EstimatedTimeHrs,EstimatedTimeMins,
	DocumentDesignerTemplateId, Description, RefPriorityId,IsMandatoryTaskCheckList
FROM TActivityCategory
WHERE ActivityCategoryId = @ActivityCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)



GO
