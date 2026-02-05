SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.[SpCustomRelinkAddressStoreFromManualRecommendation] @StampUser VARCHAR (255), 
                                             @IndigoClientId BIGINT,
											 @PreviousAddressStoreId BIGINT, 
											 @NewAddressStoreId BIGINT, 
											 @CRMContactId	 BIGINT
AS 

SET NOCOUNT ON
	DECLARE @ClientManualRecommendations TABLE 
	(
	ManualRecommendationActionId int,
	DetailsXml xml
	)
	DECLARE @ManualRecommendations TABLE 
	(
	ManualRecommendationActionId int,
	DetailsXml xml
	)
	BEGIN 
		SET @NewAddressStoreId = COALESCE(@NewAddressStoreId, 0);

		INSERT INTO @ClientManualRecommendations
		SELECT m.ManualRecommendationActionId, m.DetailsXml
		FROM factfind..TManualRecommendationAction m
		JOIN factfind..TManualRecommendation r ON m.ManualRecommendationId = r.ManualRecommendationId
		JOIN factfind..TFinancialPlanningSession f ON r.FinancialPlanningSessionId = f.FinancialPlanningSessionId
		WHERE 
			f.CRMContactId = @CRMContactId AND r.IndigoClientId = @IndigoClientId

		INSERT INTO @ManualRecommendations
		SELECT ManualRecommendationActionId, DetailsXml 
		FROM @ClientManualRecommendations
		OUTER APPLY DetailsXml.nodes('/PlanDetails/*') as XEQT(XEQC)
		WHERE XEQC.value('SelectedAddress[1]','int') = @PreviousAddressStoreId

		IF(@NewAddressStoreId != 0)
		UPDATE @ManualRecommendations
		SET DetailsXml.modify('
		replace value of (//SelectedAddress[1]/text())[1]
		with sql:variable("@NewAddressStoreId")')
		ELSE
		UPDATE @ManualRecommendations
		SET DetailsXml.modify('delete //SelectedAddress[1]')

		UPDATE m
		SET DetailsXml = r.DetailsXml
		OUTPUT
			deleted.ManualRecommendationActionId,
			deleted.ManualRecommendationId,
			deleted.ActionType,
			deleted.PolicyBusinessId,
			deleted.StatusReasonId,
			deleted.RefProdProviderId,
			deleted.RefPlanType2ProdSubTypeId,
			deleted.DetailsXml,
			deleted.RefRecommendationStatusId,
			deleted.ModificationDate,
			'U',
			GETDATE(),
			@StampUser,
			deleted.premiumAmount,
			deleted.PremiumStartDate,
			deleted.PremiumFrequencyId,
			deleted.DeferReasonId,
			deleted.DeferReasonNote,
			deleted.RejectReasonId,
			deleted.RejectReasonNote,
			deleted.RegularSelfContribution,
			deleted.RegularEmployerContribution,
			deleted.LumpSumContribution,
			deleted.WithdrawalAmount,
			deleted.RegularSelfContributionFrequencyId,
			deleted.RegularEmployerContributionFrequencyId,
			deleted.RefWithdrawalTypeId,
			deleted.RefWithdrawalFrequencyId,
			deleted.IsRegularSelfContributionIncreased,
			deleted.IsRegularEmployerContributionIncreased,
			deleted.IsWithdrawalIncreased,
			deleted.PlanTypeThirdPartyDescription,
			deleted.TopupParentPolicyBusinessId,
			deleted.SellingAdviserPartyId,
			deleted.IsOffPanel
		INTO TManualRecommendationActionAudit
		(
			ManualRecommendationActionId
			,ManualRecommendationId
			,ActionType
			,PolicyBusinessId
			,StatusReasonId
			,RefProdProviderId
			,RefPlanType2ProdSubTypeId
			,DetailsXml
			,RefRecommendationStatusId
			,ModificationDate
			,StampAction
			,StampDateTime
			,StampUser
			,PremiumAmount
			,PremiumStartDate
			,PremiumFrequencyId
			,DeferReasonId
			,DeferReasonNote
			,RejectReasonId
			,RejectReasonNote
			,RegularSelfContribution
			,RegularEmployerContribution
			,LumpSumContribution
			,WithdrawalAmount
			,RegularSelfContributionFrequencyId
			,RegularEmployerContributionFrequencyId
			,RefWithdrawalTypeId
			,RefWithdrawalFrequencyId
			,IsRegularSelfContributionIncreased
			,IsRegularEmployerContributionIncreased
			,IsWithdrawalIncreased
			,PlanTypeThirdPartyDescription
			,TopupParentPolicyBusinessId
			,SellingAdviserPartyId
			,IsOffPanel
		)
		FROM factfind..TManualRecommendationAction m
		JOIN @ManualRecommendations r ON r.ManualRecommendationActionId = m.ManualRecommendationActionId
END