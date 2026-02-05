SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateLifeCycleTasks]
	@StampUser varchar(50),
	@IndigoClientId bigint,
	@LifeCycleId bigint,
	@StatusId bigint,
	@SellingAdviserId bigint,
	@ClientId bigint,
	@PolicyBusinessId bigint,
	@CurrentUserDateTime datetime,
	@Timezone varchar(100)
AS
-------------------------------------------------------------
-- Declarations
-------------------------------------------------------------
DECLARE @RefPriorityId bigint, @ActivityCategoryId bigint, @Name varchar(50), @IsClientRelated bit, 
	@IsPlanRelated bit, @AssignedToUserId bigint
	
-------------------------------------------------------------	
-- Get priority.
-------------------------------------------------------------	
SELECT @RefPriorityId = RefPriorityId FROM CRM..TRefPriority WHERE IndClientId = @IndigoClientId And PriorityName = 'Medium'

-------------------------------------------------------------	
-- Get Practitioner User
-------------------------------------------------------------	
SELECT @AssignedToUserId = UserId
FROM CRM..TPractitioner A
	JOIN Administration..TUser U ON U.CRMContactId = A.CRMContactId
WHERE A.PractitionerId = @SellingAdviserId	

-------------------------------------------------------------
-- Get list of tasks for this life cycle.
-------------------------------------------------------------
DECLARE TASK_CURSOR CURSOR FAST_FORWARD FOR
SELECT
	ac.ActivityCategoryId, ac.Name, ac.ClientRelatedFg, ac.PlanRelatedFg
FROM	
	PolicyManagement..TLifeCycleStep lcs
	JOIN CRM..TActivityCategory2LifeCycleStep ac2lcs ON ac2lcs.LifeCycleStepId = lcs.LifeCycleStepId
	JOIN CRM..TActivityCategory ac ON ac.ActivityCategoryId = ac2lcs.ActivityCategoryId
WHERE 
	lcs.LifeCycleId = @LifeCycleId AND lcs.StatusId = @StatusId

-------------------------------------------------------------
-- Iterate over task list
-------------------------------------------------------------
OPEN TASK_CURSOR
FETCH NEXT FROM TASK_CURSOR INTO @ActivityCategoryId, @Name, @IsClientRelated, @IsPlanRelated

WHILE @@FETCH_STATUS = 0 BEGIN
	-- Add Task for the Client?
	IF @IsClientRelated = 1 AND NOT EXISTS (
		SELECT 1 FROM CRM..TOrganiserActivity
			WHERE CRMContactId = @ClientId AND ActivityCategoryId = @ActivityCategoryId)
		EXEC SpNCustomCreateTask @StampUser, @IndigoClientId, @StampUser, @AssignedToUserId, @Name, 
			@RefPriorityId, @ClientId, @ActivityCategoryId, @CurrentUserDateTime, @Timezone

	-- Add Task for the Plan?
	IF @IsPlanRelated = 1
		EXEC SpNCustomCreateTask @StampUser, @IndigoClientId, @StampUser, @AssignedToUserId, @Name, 
			@RefPriorityId, @ClientId, @ActivityCategoryId, @CurrentUserDateTime, @Timezone, @PolicyBusinessId

	FETCH NEXT FROM TASK_CURSOR INTO @ActivityCategoryId, @Name, @IsClientRelated, @IsPlanRelated
END

CLOSE TASK_CURSOR
DEALLOCATE TASK_CURSOR
GO
