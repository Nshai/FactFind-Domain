SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


	CREATE PROCEDURE [dbo].[SpNAuditManualRecommendationAction]
		@StampUser varchar (255),
		@ManualRecommendationActionId bigint,
		@StampAction char(1)
	AS
		INSERT INTO TManualRecommendationActionAudit 
		 (ManualRecommendationActionId, ManualRecommendationId, ActionType, PolicyBusinessId, StatusReasonId,DeferReasonId,
		  RefProdProviderId, RefPlanType2ProdSubTypeId, DetailsXml, RefRecommendationStatusId,DeferReasonNote,
		  ModificationDate, PremiumAmount, PremiumStartDate, PremiumFrequencyId, StampAction, StampDateTime, StampUser,
		  RejectReasonId, RejectReasonNote, RegularSelfContribution, RegularEmployerContribution, LumpSumContribution,
		  WithdrawalAmount, RegularSelfContributionFrequencyId,	RegularEmployerContributionFrequencyId,
		  RefWithdrawalTypeId,	RefWithdrawalFrequencyId, IsRegularSelfContributionIncreased, IsRegularEmployerContributionIncreased,
		  IsWithdrawalIncreased, IsOffPanel, PlanTypeThirdPartyDescription, TopupParentPolicyBusinessId, SellingAdviserPartyId)
		SELECT 
		  ManualRecommendationActionId, ManualRecommendationId, ActionType, PolicyBusinessId, StatusReasonId,DeferReasonId,
		  RefProdProviderId, RefPlanType2ProdSubTypeId, DetailsXml, RefRecommendationStatusId,DeferReasonNote,
		  ModificationDate, PremiumAmount, PremiumStartDate, PremiumFrequencyId, @StampAction, GetDate(), @StampUser,
		  RejectReasonId, RejectReasonNote, RegularSelfContribution, RegularEmployerContribution, LumpSumContribution,
		  WithdrawalAmount, RegularSelfContributionFrequencyId,	RegularEmployerContributionFrequencyId,
		  RefWithdrawalTypeId,	RefWithdrawalFrequencyId, IsRegularSelfContributionIncreased, IsRegularEmployerContributionIncreased,
		  IsWithdrawalIncreased, IsOffPanel, PlanTypeThirdPartyDescription, TopupParentPolicyBusinessId, SellingAdviserPartyId
		FROM TManualRecommendationAction
		WHERE ManualRecommendationActionId = @ManualRecommendationActionId

		IF @@ERROR != 0 GOTO errh
			RETURN (0)
		errh:
		RETURN (100)
			
GO


