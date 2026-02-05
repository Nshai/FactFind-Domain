SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ACTIVITIES

CREATE PROCEDURE [dbo].[spCustomConfigureActivities] @CategoryParent varchar(50), @Category varchar(50), @ActivityOutcome varchar(50), @ActivityEvent varchar(50),
@IsClient bit, @IsPlan bit, @IsOpportunity bit, @IsAdviser bit,@IndigoClientId bigint
AS

-- we need to check for existing data
DECLARE @ActivityCategoryParentId bigint
DECLARE @ActivityCategoryId bigint
DECLARE @ActivityOutcomeId bigint
DECLARE @Activitycategory2activityoutcomeId bigint



SELECT @ActivityCategoryParentId=ActivityCategoryParentId FROM TActivityCategoryParent where name = @CategoryParent and IndigoClientId=@IndigoClientId

-- activity category parent
IF ISNULL(@ACtivityCategoryParentId,0)=0
BEGIN

	INSERT INTO TActivityCategoryParent (Name, indigoClientId)
	VALUES (@CategoryParent,@IndigoClientId)

	SELECT @ActivityCategoryParentId=SCOPE_IDENTITY()
END

-- activity category

SELECT @ActivityCategoryId = ActivityCategoryId FROM TActivityCategory where name = @Category and IndigoClientId=@IndigoClientId and ActivityEvent=@ActivityEvent and ActivityCategoryparentId=@ActivityCategoryParentId

-- activity category parent
IF ISNULL(@ActivityCategoryId,0)=0
BEGIN

	INSERT INTO TActivityCategory (Name,ActivityCategoryParentId, indigoClientId,clientrelatedfg,planrelatedfg, opportunityrelatedfg,AdviserRelatedFg, ActivityEvent)
	VALUES (@Category,  @ActivityCategoryParentId, @IndigoClientId,@IsClient,@IsPlan,@IsOpportunity,@IsAdviser, @ActivityEvent)

	SELECT @ActivityCategoryId = SCOPE_IDENTITY()
END


if (@ActivityOutcome!='')
BEGIN
	-- activity outcome
	
	SELECT @ActivityOutcomeId = a.ActivityOutcomeId FROM crm..TActivityOutcome a
	where ActivityoutcomeName = @ActivityOutcome and IndigoClientId=@IndigoClientId AND a.GroupId IS NULL
	
	IF ISNULL(@ActivityOutcomeId,0)=0
	BEGIN
	
		INSERT INTO TActivityOutcome (ActivityOutcomeName, IndigoClientId, archivefg)
		VALUES (@ActivityOutcome,@Indigoclientid,0)
	
		SELECT @ActivityOutcomeId = SCOPE_IDENTITY()
	END
	
	-- activity outcome2category
	
	SELECT @Activitycategory2activityoutcomeId = Activitycategory2activityoutcomeId FROM 
		TActivitycategory2activityoutcome where ActivityoutcomeID= @ActivityOutcomeId and ActivityCategoryID=@ActivityCategoryId
	
	
	IF ISNULL(@Activitycategory2activityoutcomeId,0)=0
	BEGIN
	
		INSERT INTO TActivityCategory2ActivityOutcome (ActivityOutcomeId, ActivityCategoryId)
		VALUES (@ActivityOutcomeId, @ActivityCategoryId)
	
	END
END


GO
