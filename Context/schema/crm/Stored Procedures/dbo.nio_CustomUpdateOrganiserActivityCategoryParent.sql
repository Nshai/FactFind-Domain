SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_CustomUpdateOrganiserActivityCategoryParent]
(
		@ActivityCategoryId bigint,
		@NewActivityCategoryParentId bigint,   
		@OldActivityCategoryParentId bigint		
)
AS      
      
BEGIN      
      
--1. Adding the Audit Insert.
INSERT INTO [CRM].[dbo].[TOrganiserActivityAudit]
           ([AppointmentId]
           ,[ActivityCategoryParentId]
           ,[ActivityCategoryId]
           ,[TaskId]
           ,[CompleteFG]
           ,[PolicyId]
           ,[FeeId]
           ,[RetainerId]
           ,[OpportunityId]
           ,[EventListActivityId]
           ,[CRMContactId]
           ,[IndigoClientId]
           ,[AdviceCaseId]
           ,[ConcurrencyId]
           ,[OrganiserActivityId]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])
	SELECT AppointmentId,
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
           'U',
           GetDate(),
           '0'
     FROM TOrganiserActivity T
	 WHERE ActivityCategoryId = @ActivityCategoryId
	 AND ActivityCategoryParentId = @OldActivityCategoryParentId

--2. Changing the Query to update only those organiser activities 
--which belong to this category.
UPDATE CRM..TOrganiserActivity 
SET ActivityCategoryParentId = @NewActivityCategoryParentId  
WHERE ActivityCategoryId = @ActivityCategoryId
AND ActivityCategoryParentId = @OldActivityCategoryParentId

SELECT 1

END
GO
