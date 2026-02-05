
SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SPNCustomRetrieveRecommendationTransactionContributions] 
(
	 @ActionPlanIds VARCHAR(8000),
	 @QuoteTransactionIds  VARCHAR(8000),
	 @ManualTransactionIds VARCHAR(8000)
)
AS
BEGIN

IF(OBJECT_ID('tempdb..#ScenarioTIds') IS NOT NULL) DROP TABLE #ScenarioTIds
SELECT DISTINCT Value AS Id INTO #ScenarioTIds FROM policymanagement.dbo.FnSplit(@ActionPlanIds, ',')

IF(OBJECT_ID('tempdb..#ManualTIds') IS NOT NULL) DROP TABLE #ManualTIds
SELECT DISTINCT Value AS Id INTO #ManualTIds FROM policymanagement.dbo.FnSplit(@ManualTransactionIds, ',')

IF(OBJECT_ID('tempdb..#QuoteTIds') IS NOT NULL) DROP TABLE #QuoteTIds
SELECT DISTINCT Value AS Id INTO #QuoteTIds FROM policymanagement.dbo.FnSplit(@QuoteTransactionIds, ',')

	SELECT 
		DISTINCT
		CAST(fps.FinancialPlanningScenarioId AS VARCHAR(100))+'O'													as RecommendationId,
		CAST(ap.ActionPlanId AS VARCHAR(100))+'O'																	as TransactionId,
		ap.FinancialPlanningId																						as FinancialPlanningId,
		CAST(apc.ActionPlanContributionId AS VARCHAR(100))+'O' 														as ContributionId,
		apc.ContributionAmount																						as ContributionAmount,
		apc.ContributionFrequency																					as ContributionFrequency,
		apc.RefContributionTypeId																				    as ContributionTypeId,
		ct.RefContributionTypeName																					as ContributionType,
		apc.RefContributorTypeId																					as ContributorTypeId	
	FROM factfind..TActionPlan ap
	JOIN factfind..TActionPlanContribution apc ON apc.ActionPlanId = ap.ActionPlanId	
	JOIN factfind..TFinancialPlanningScenario fps ON fps.FinancialPlanningId = ap.FinancialPlanningId
	JOIN policymanagement.dbo.TRefContributionType ct ON ct.RefContributionTypeId = apc.RefContributionTypeId
	JOIN #ScenarioTIds Ids   ON ap.ActionPlanId = Ids.Id
	WHERE ISNULL(apc.ContributionAmount, 0) > 0

	UNION

	SELECT	
		DISTINCT
		CAST(mr.ManualRecommendationId AS VARCHAR(100))+'M'															as RecommendationId,
		CAST(ma.ManualRecommendationActionId AS VARCHAR(100))+'M'													as TransactionId,
		fps.FinancialPlanningId																						as FinancialPlanningId,
		CAST(ma.ManualRecommendationActionId AS VARCHAR(100))+'M' 													as ContributionId,
		
		ISNULL(ma.PremiumAmount, pb.TotalRegularPremium)															as ContributionAmount,
		
		CASE WHEN ISNULL(freq.FrequencyName, '')!= ''	THEN freq.FrequencyName
			ELSE 
			(
				SELECT TOP 1 freq.FrequencyName 
				FROM PolicyManagement..TPolicyMoneyIn pmi 
					JOIN policymanagement.dbo.TRefFrequency freq WITH(NOLOCK) 
					ON freq.RefFrequencyId = pmi.RefFrequencyId
				WHERE PMI.PolicyBusinessId = pb.PolicyBusinessId AND PMI.CurrentFG = 1
					AND PMI.RefContributionTypeId = 1 AND PMI.RefContributorTypeId = 1 
					AND PMI.RefFrequencyId != 10
			)
		END																											as ContributionFrequency,
		
				
		CASE WHEN ma.PremiumFrequencyId is null and pb.TotalRegularPremium is not null THEN 1
		ELSE CASE WHEN ISNULL(ma.PremiumFrequencyId, 10) = 10 THEN 2 ELSE 1 END			
		END																											as ContributionTypeId, -- freq= single then LumpSUMP Or REGULAR
		
		
		CASE WHEN ma.PremiumFrequencyId is null and pb.TotalRegularPremium is not null THEN 'Regular'
		ELSE CASE WHEN ma.PremiumFrequencyId is not null and ma.PremiumFrequencyId = 10 THEN 'Lump Sum' ELSE 'Regular' END	
		 END																										as ContributionType,
		1 																											as ContributorTypeId -- SELF	

	FROM FactFind.dbo.TManualRecommendationAction ma WITH(NOLOCK) 
	JOIN #ManualTIds Ids   ON ma.ManualRecommendationActionId = ids.Id
	JOIN FactFind.dbo.[TManualRecommendation] mr WITH(NOLOCK) ON ma.ManualRecommendationId = mr.ManualRecommendationId	
	JOIN FactFind.dbo.[TFinancialPlanningSession] fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId 
	JOIN crm..TCrmContact crm1 On crm1.CRMContactId = fps.CRMContactId 
	LEFT JOIN crm..TCrmContact crm2 On crm2.CRMContactId = fps.CRMContactId2 
	LEFT JOIN policymanagement..TPolicyBusiness pb WITH(NOLOCK) ON pb.PolicyBusinessId = ma.PolicyBusinessId
	LEFT JOIN policymanagement.dbo.TRefFrequency freq WITH(NOLOCK) ON freq.RefFrequencyId = ma.PremiumFrequencyId
	WHERE ISNULL(ma.PremiumAmount, ISNULL(pb.TotalRegularPremium, 0)) > 0

	UNION

	SELECT 
		DISTINCT
		CAST(qr.QuoteItemRecommendationStatusId AS VARCHAR(100))+'Q'												as RecommendationId,
		CAST(qr.QuoteItemRecommendationStatusId AS VARCHAR(100))+'Q'												as TransactionId,
		fp.FinancialPlanningId																						as FinancialPlanningId,
		CAST(qr.QuoteItemRecommendationStatusId AS VARCHAR(100))+'Q' 												as ContributionId,
		ISNULL(qt.PremiumAmount, ISNULL(qp.Premium, qw.Premium))													as ContributionAmount,
		qt.PremiumFrequency																							as ContributionFrequency,
		CASE WHEN ISNULL(qt.PremiumFrequency, 'Single') ='Single' THEN 2 ELSE 1 END									as ContributionTypeId, -- LumpSUMP Or REGULAR
		qt.PremiumType																								as ContributionType,
		1 																											as ContributorTypeId -- SELF																								
	FROM   policymanagement.dbo.TQuoteItemRecommendationStatus qr
	 JOIN #QuoteTIds Ids   ON qr.QuoteItemRecommendationStatusId = Ids.Id
	 JOIN FactFind.dbo.[TFinancialPlanningSession] fps ON fps.FinancialPlanningSessionId = qr.FinancialPlanningSessionId  
	 JOIN FactFind.dbo.[TFinancialPlanning] fp ON fps.FinancialPlanningId = fp.FinancialPlanningId 
	 JOIN policymanagement.dbo.TQuoteItem qi ON qi.QuoteItemId = qr.QuoteItemId
	 LEFT JOIN policymanagement.dbo.TQuoteTerm qt ON qt.QuoteItemId = qi.QuoteItemId
	 LEFT JOIN policymanagement.dbo.TQuotePHI qp ON qp.QuoteItemId = qi.QuoteItemId
	 LEFT JOIN policymanagement.dbo.TQuoteWOL qw ON qw.QuoteItemId = qi.QuoteItemId
	WHERE ISNULL(qt.PremiumAmount, ISNULL(qp.Premium, ISNULL(qw.Premium, 0))) > 0

	UNION

			  --Contibutions that are not included in the previous select for 'M' type
	select DISTINCT
		CAST(contributions.ManualRecommendationId AS VARCHAR(100))+'M'															as RecommendationId,
		CAST(contributions.ManualRecommendationActionId AS VARCHAR(100))+'M'													as TransactionId,
		contributions.FinancialPlanningId																						as FinancialPlanningId,
		CAST(contributions.ManualRecommendationActionId AS VARCHAR(100))+'M' 													as ContributionId,
		contributions.ContributionAmount																						as ContributionAmount,
		contributions.FrequencyName																								as ContributionFrequency,
		contributions.ContributionTypeId																						as ContributionTypeId,
		contributions.ContributionType																						    as ContributionType,
		contributions.ContributorTypeId																							as ContributorTypeId

	FROM (
		  SELECT mr.ManualRecommendationId, ma.ManualRecommendationActionId, fps.FinancialPlanningId,
		  ma.RegularEmployerContribution as ContributionAmount, freq.FrequencyName, 1 as ContributionTypeId /*Regular*/, 'Regular' as ContributionType, 2 as ContributorTypeId /*Employer*/
		  FROM [factfind].[dbo].[TManualRecommendationAction] ma
		    JOIN #ManualTIds Ids   ON ma.ManualRecommendationActionId = ids.Id
		  	JOIN FactFind.dbo.[TManualRecommendation] mr WITH(NOLOCK) ON ma.ManualRecommendationId = mr.ManualRecommendationId	
			JOIN FactFind.dbo.[TFinancialPlanningSession] fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId 
			LEFT JOIN policymanagement.dbo.TRefFrequency freq WITH(NOLOCK) ON freq.RefFrequencyId = ma.RegularEmployerContributionFrequencyId
		  where ma.RegularEmployerContribution is not null

		  UNION

		  SELECT  mr.ManualRecommendationId,ma.ManualRecommendationActionId, fps.FinancialPlanningId,
		   ma.RegularSelfContribution as ContributionAmount, freq.FrequencyName, 1 as ContributionTypeId /*Regular*/, 'Regular' as ContributionType, 1 as ContributorTypeId /*Self*/
		  FROM [factfind].[dbo].[TManualRecommendationAction] ma
		    JOIN #ManualTIds Ids   ON ma.ManualRecommendationActionId = ids.Id
		  	JOIN FactFind.dbo.[TManualRecommendation] mr WITH(NOLOCK) ON ma.ManualRecommendationId = mr.ManualRecommendationId	
			JOIN FactFind.dbo.[TFinancialPlanningSession] fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId 
			LEFT JOIN policymanagement.dbo.TRefFrequency freq WITH(NOLOCK) ON freq.RefFrequencyId = ma.RegularSelfContributionFrequencyId
		  where ma.RegularSelfContribution is not null

		  UNION

		  SELECT  mr.ManualRecommendationId, ma.ManualRecommendationActionId, fps.FinancialPlanningId,
		   ma.LumpSumContribution as ContributionAmount, 'Single', 2 as ContributionTypeId /*Lump Sum*/, 'Lump Sum' as ContributionType, 1 as ContributorTypeId /*Self*/
		  FROM [factfind].[dbo].[TManualRecommendationAction] ma
		    JOIN #ManualTIds Ids   ON ma.ManualRecommendationActionId = ids.Id
		  	JOIN FactFind.dbo.[TManualRecommendation] mr WITH(NOLOCK) ON ma.ManualRecommendationId = mr.ManualRecommendationId	
		    JOIN FactFind.dbo.[TFinancialPlanningSession] fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId 
		  where ma.LumpSumContribution is not null

  ) contributions
END