SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateTask]
	@StampUser varchar(50),
	@IndigoClientId int,
	@AssignedByUserId bigint, 
	@AssignedToUserId bigint, 
	@Subject varchar(50), 
	@RefPriorityId bigint,
	@CRMContactId bigint, 
	@ActivityCategoryId bigint,
	@CurrentUserDateTime datetime,
	@Timezone varchar(100),
	@PolicyBusinessId bigint = null
AS
DECLARE @TaskId int, @OrganiserActivityId bigint, @Today datetime, @ActivityCategoryParentId bigint, @SecondaryClientId bigint;

---------------------------------------------------------------
-- Set secondary client for activity if plan is joint
---------------------------------------------------------------

SELECT TOP 1 @SecondaryClientId = po.CrmContactId
FROM policymanagement..TPolicyBusiness pb
         INNER JOIN policymanagement..TPolicyOwner po on pb.PolicyDetailId = po.PolicyDetailId
WHERE pb.PolicyBusinessId = @PolicyBusinessId and po.CRMContactId != @CRMContactId

---------------------------------------------------------------
-- Add Task
---------------------------------------------------------------
SET @Today = CONVERT(varchar(12), @CurrentUserDateTime, 106)
INSERT INTO CRM..TTask (
	StartDate, DueDate, PercentComplete, AssignedUserId, AssignedToUserId, [Subject], RefPriorityId,
	CRMContactId, RefTaskStatusId, IndigoClientId, Timezone)
VALUES (
	@Today, @CurrentUserDateTime, 0, @AssignedByUserId, @AssignedToUserId, @Subject, @RefPriorityId,
	@CRMContactId, 5, @IndigoClientId, @Timezone)
	
SET @TaskId = SCOPE_IDENTITY()		
EXEC CRM..SpNAuditTask @StampUser, @TaskId, 'C', @IndigoClientId

---------------------------------------------------------------
-- Add Activity
---------------------------------------------------------------
SELECT @ActivityCategoryParentId = ActivityCategoryParentId
FROM CRM..TActivityCategory
WHERE ActivityCategoryId = @ActivityCategoryId AND GroupId IS NULL

INSERT INTO CRM..TOrganiserActivity (
	ActivityCategoryParentId, ActivityCategoryId, TaskId, CompleteFG, 
	PolicyId, CRMContactId, JointCRMContactId, IndigoClientId)	
VALUES (
	@ActivityCategoryParentId, @ActivityCategoryId, @TaskId, 0, 
	@PolicyBusinessId, @CRMContactId, @SecondaryClientId, @IndigoClientId)	

SET @OrganiserActivityId = SCOPE_IDENTITY()		
EXEC CRM..SpNAuditOrganiserActivity @StampUser, @OrganiserActivityId, 'C'		
GO
