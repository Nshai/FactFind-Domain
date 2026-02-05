SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateActivityCategory]
	@StampUser varchar (255),
	@Name varchar(50) , 
	@ActivityCategoryParentId bigint = NULL, 
	@LifeCycleTransitionId bigint = NULL, 
	@IndigoClientId bigint, 
	@ClientRelatedFG bit = 0, 
	@PlanRelatedFG bit = 0, 
	@FeeRelatedFG bit = 0, 
	@RetainerRelatedFG bit = 0, 
	@OpportunityRelatedFG bit = 0, 
	@AdviserRelatedFg bit = 0, 
	@ActivityEvent varchar(50)  = NULL, 
	@RefSystemEventId bigint = NULL, 
	@TemplateTypeId varchar(50)  = NULL, 
	@TemplateId varchar(50)  = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @ActivityCategoryId bigint
			
	
	INSERT INTO TActivityCategory (
		Name, 
		ActivityCategoryParentId, 
		LifeCycleTransitionId, 
		IndigoClientId, 
		ClientRelatedFG, 
		PlanRelatedFG, 
		FeeRelatedFG, 
		RetainerRelatedFG, 
		OpportunityRelatedFG, 
		AdviserRelatedFg, 
		ActivityEvent, 
		RefSystemEventId, 
		TemplateTypeId, 
		TemplateId, 
		ConcurrencyId)
		
	VALUES(
		@Name, 
		@ActivityCategoryParentId, 
		@LifeCycleTransitionId, 
		@IndigoClientId, 
		@ClientRelatedFG, 
		@PlanRelatedFG, 
		@FeeRelatedFG, 
		@RetainerRelatedFG, 
		@OpportunityRelatedFG, 
		@AdviserRelatedFg, 
		@ActivityEvent, 
		@RefSystemEventId, 
		@TemplateTypeId, 
		@TemplateId,
		1)

	SELECT @ActivityCategoryId = SCOPE_IDENTITY()
	
	INSERT INTO TActivityCategoryAudit (
		Name, 
		ActivityCategoryParentId, 
		LifeCycleTransitionId, 
		IndigoClientId, 
		ClientRelatedFG, 
		PlanRelatedFG, 
		FeeRelatedFG, 
		RetainerRelatedFG, 
		OpportunityRelatedFG, 
		AdviserRelatedFg, 
		ActivityEvent, 
		RefSystemEventId, 
		TemplateTypeId, 
		TemplateId, 
		ConcurrencyId,
		ActivityCategoryId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		Name, 
		ActivityCategoryParentId, 
		LifeCycleTransitionId, 
		IndigoClientId, 
		ClientRelatedFG, 
		PlanRelatedFG, 
		FeeRelatedFG, 
		RetainerRelatedFG, 
		OpportunityRelatedFG, 
		AdviserRelatedFg, 
		ActivityEvent, 
		RefSystemEventId, 
		TemplateTypeId, 
		TemplateId, 
		ConcurrencyId,
		ActivityCategoryId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TActivityCategory
	WHERE ActivityCategoryId = @ActivityCategoryId
	EXEC SpRetrieveActivityCategoryById @ActivityCategoryId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
