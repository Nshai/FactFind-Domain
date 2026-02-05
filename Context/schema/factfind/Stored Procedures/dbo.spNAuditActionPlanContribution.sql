SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[spNAuditActionPlanContribution]

    @StampUser varchar (255),
	@ActionPlanContributionId bigint,
	@StampAction char(1)
AS

	INSERT INTO [TActionPlanContributionAudit]
           ([ActionPlanContributionId]
           ,[ActionPlanId]
           ,[ContributionAmount]
           ,[RefContributionTypeId]
           ,[RefContributorTypeId]
           ,[ContributionFrequency]
		   ,[IsIncreased]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])
     SELECT
            [ActionPlanContributionId]
           ,[ActionPlanId]
           ,[ContributionAmount]
           ,[RefContributionTypeId]
           ,[RefContributorTypeId]
           ,[ContributionFrequency]
		   ,[IsIncreased]
           ,@StampAction
           ,GetDate()
           ,@StampUser
      FROM TActionPlanContribution
      WHERE ActionPlanContributionId = @ActionPlanContributionId
	
GO
