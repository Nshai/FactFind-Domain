SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNio_CustomRetrieveAdvisaCentaRecommendations]
	@ServiceCaseId int,
	@TenantId int,
	@RefRecommendationStatus varchar(50) = null
AS 

DECLARE @TempRecommendations TABLE (
	FinancialPlanningId int, FinancialPlanningSessionId int, FinancialPlanningScenarioId int, AdvisaCentaRecommendationStatusId int, RefTransactionTypeId int, ActionPlanId int,
	SolutionGroupId int, RecommendationSolutionStatusId int, PolicyBusinessId int null,	PolicyDetailId int null, ActionPlanProviderName varchar(255) null, TopupParentPolicyBusinessId int null,
	IsNewProposal bit null, PlanTypeThirdPartyDescription varchar(255) null, PlanTypeName varchar(255) null, ProdSubTypeName varchar(255) null,
	RecommendationStatus varchar(50) null, RecommendationStatusDate datetime null, RejectedReason varchar(255) null, DeferredReason varchar(150) null,
	Owner1FirstName varchar(50) null, Owner1LastName varchar(50) null, Owner2FirstName varchar(50) null,	Owner2LastName varchar(50) null,
	Owner1PartyId int null,	Owner2PartyId int null,	ActionPlanDnId int null, ActionFundId int null,	TopupParentPrimaryOwnerFirstName varchar(50) null,
	TopupParentPrimaryOwnerLastName varchar(50) null, ObjectiveName varchar(500) null, GoalCategory varchar(50) null, GoalType int null,
	FinancialPlanningCreatedDate datetime null, FinancialPlanningScenarioName varchar(255) null, QuoteId int null, QuoteReference varchar(50) null,
	QuoteStatusId int null, RecommendationSolutionStatusDate datetime null, RecommendationSolutionStatus varchar(50) null, RejectReasonNote ntext, DeferReasonNote ntext,
	RecommendationName nvarchar(100) null, StatusReasonId int null
)


DECLARE @PolicyBusinessDetails TABLE (
	PolicyBusinessId int, Owner1CrmContactId int, Owner1FirstName varchar(50) NULL,	Owner1LastName varchar(50) NULL,
	PolicyOwnerId int, PolicyNumber varchar(50) null, ProviderName varchar(255) null, PolicyBusinessSeqRef varchar(50) null,
	Owner2FirstName varchar(50) NULL, Owner2LastName varchar(50) NULL
)


DECLARE @TransactionDetailsTable TABLE (
	 ActionPlanId int, ActionPlanContributionId int null, ActionPlanWithdrawalId int null, ContributionAmount decimal(18,2) null,
	 WithdrawalAmount decimal(18,2) null, ContributionType varchar(50) null, WithdrawalType varchar(50) null, ContributionFrequency varchar(50) null,
	 WithdrawalFrequency varchar(50) null, IsWithdrawalIncreased bit null, IsContributionIncreased bit null, IsEncashment bit null
)

INSERT INTO @TransactionDetailsTable
SELECT * FROM dbo.FnCustomGetTransactionDetails(@ServiceCaseId)


INSERT INTO @TempRecommendations (
	FinancialPlanningId, FinancialPlanningSessionId, FinancialPlanningScenarioId, AdvisaCentaRecommendationStatusId, RefTransactionTypeId, ActionPlanId, 
	SolutionGroupId, RecommendationSolutionStatusId, PolicyBusinessId,ActionPlanProviderName, TopupParentPolicyBusinessId, IsNewProposal,
	Owner1PartyId, Owner2PartyId,PlanTypeThirdPartyDescription,PlanTypeName , ProdSubTypeName, RecommendationStatus,RecommendationStatusDate, RejectedReason,
	DeferredReason, ActionPlanDnId, ActionFundId, ObjectiveName, GoalCategory, GoalType, FinancialPlanningCreatedDate, FinancialPlanningScenarioName,
	QuoteId, QuoteReference, QuoteStatusId, RecommendationSolutionStatusDate, RecommendationSolutionStatus, RejectReasonNote, DeferReasonNote, RecommendationName,
	StatusReasonId
)

SELECT
	ap.FinancialPlanningId, fps.FinancialPlanningSessionId, fpsc.FinancialPlanningScenarioId, acrs.AdvisaCentaRecommendationStatusId, acrs.RefTransactionTypeId, ap.ActionPlanId,
	ap.SolutionGroupId, rss.RecommendationSolutionStatusId, ap.PolicyBusinessId, ap.ProviderName, ap.TopupParentPolicyBusinessId, ap.IsNewProposal, ap.Owner1, ap.Owner2,
	ap.PlanTypeThirdPartyDescription, rpt.PlanTypeName, pst.ProdSubTypeName, rrs.Identifier, acrs.StatusDate, rr.[Description], dr.DeferredReason,
	apn.ActionPlanDNId, acrs.ActionFundId, fpg.Objective, rgc.Name, fp.GoalType, fps.[Date], fpsc.ScenarioName,
	Q.QuoteId, Q.SequentialRef, Q.RefQuoteStatusId, rss.StatusChangeDate, rsss.[Status], acrs.RejectReasonNote, acrs.DeferReasonNote, rss.RecommendationName,ap.StatusReasonId
FROM 
	TFinancialPlanning fp 	
	JOIN TFinancialPlanningSession fps ON fp.FinancialPlanningId = fps.FinancialPlanningId
	JOIN TFinancialPlanningScenario fpsc ON fpsc.FinancialPlanningId = fps.FinancialPlanningId
	JOIN TFinancialPlanningGoal fpg ON fpg.FinancialPlanningSessionId = fps.FinancialPlanningSessionId
	JOIN TActionPlan ap ON ap.ScenarioId = fpsc.FinancialPlanningScenarioId
	JOIN TAdvisaCentaRecommendationStatus acrs ON acrs.ActionPlanId = ap.ActionPlanId
	LEFT JOIN TRecommendationSolutionStatus rss ON rss.FinancialPlanningSessionId = fps.FinancialPlanningSessionId	AND rss.SolutionGroup = ap.SolutionGroupId
	LEFT JOIN TRefRecommendationStatus rrs ON rrs.RefRecommendationStatusId = acrs.RefRecommendationStatusId
	LEFT JOIN TActionPlanDN apn ON apn.ActionPlanId = ap.ActionPlanId
	LEFT JOIN TRefRecommendationSolutionStatus rsss on rsss.RefRecommendationSolutionStatusId = rss.RefRecommendationSolutionStatusId
	LEFT JOIN policymanagement..TRefPlanType2ProdSubType rpt2  ON ap.RefPlan2ProdSubTypeId = rpt2.RefPlanType2ProdSubTypeId
	LEFT JOIN policymanagement..TRefPlanType rpt ON rpt2.RefPlanTypeId = rpt.RefPlanTypeId
	LEFT JOIN policymanagement..TProdSubType pst ON rpt2.ProdSubTypeId = pst.ProdSubTypeId
	LEFT JOIN TRefRejectedReason rr ON rr.RefRejectedReasonId = acrs.RefRejectedReasonId
	LEFT JOIN TRefDeferredReason dr ON dr.RefDeferredReasonId = acrs.RefDeferredReasonId
	LEFT JOIN policymanagement..TQuote Q ON Q.QuoteId = ap.QuoteId
	LEFT JOIN TRefGoalCategory rgc ON rgc.RefGoalCategoryId = fpg.RefGoalCategoryId
WHERE
	fps.ServiceCaseId = @ServiceCaseId AND rss.TenantId = @TenantId 
	AND (@RefRecommendationStatus IS NULL OR rrs.Identifier = @RefRecommendationStatus)
ORDER BY 
	fps.FinancialPlanningId Asc, ap.SolutionGroupId

INSERT INTO @PolicyBusinessDetails(
	PolicyOwnerId, PolicyBusinessId, Owner1CrmContactId, Owner1FirstName, Owner1LastName, 
	PolicyNumber, PolicyBusinessSeqRef, ProviderName, Owner2FirstName, Owner2LastName)
SELECT DISTINCT 
	po.PolicyOwnerId, rec.PolicyBusinessId, po.CRMContactId, own.FirstName, own.LastName, pb.PolicyNumber, pb.SequentialRef, prov.CorporateName,
	own2.FirstName, own2.LastName
FROM 
	@TempRecommendations rec
	JOIN policymanagement..TPolicyBusiness pb ON ( pb.PolicyBusinessId = rec.PolicyBusinessId)
	JOIN policymanagement..TPolicyDetail pd ON pd.PolicyDetailId = pb.PolicyDetailId
	JOIN policymanagement..TPolicyOwner po ON po.PolicyDetailId = pd.PolicyDetailId
		AND po.PolicyOwnerId = (
			SELECT Min(PolicyOwnerId) FROM policymanagement..TPolicyOwner powner -- we are fetching only primary owner
			WHERE powner.PolicyDetailId = po.PolicyDetailId GROUP BY powner.PolicyDetailId)
	JOIN crm..TCRMContact own ON own.CRMContactId = po.CRMContactId

	LEFT JOIN policymanagement..TPolicyOwner po2 ON po2.PolicyDetailId = pd.PolicyDetailId
		AND po2.PolicyOwnerId = (
			SELECT Min(PolicyOwnerId) FROM policymanagement..TPolicyOwner powner -- we are fetching only secondary owner
			WHERE powner.PolicyDetailId = po2.PolicyDetailId 
			AND   powner.PolicyOwnerId != po.PolicyOwnerId  GROUP BY powner.PolicyDetailId)
	LEFT JOIN crm..TCRMContact own2 ON own2.CRMContactId = po2.CRMContactId

	JOIN policymanagement..TPlanDescription pdesc  ON pdesc.PlanDescriptionId = pd.PlanDescriptionId
	JOIN policymanagement..TRefProdProvider rp ON pdesc.RefProdProviderId = rp.RefProdProviderId
	JOIN crm..TCRMContact prov ON prov.CRMContactId = rp.CRMContactId
WHERE 
	pb.IndigoClientId = @TenantId

UNION
SELECT DISTINCT 
	po.PolicyOwnerId, rec.TopupParentPolicyBusinessId, po.CRMContactId, own.FirstName, own.LastName, pb.PolicyNumber, pb.SequentialRef, prov.CorporateName,
	own2.FirstName, own2.LastName

FROM 
	@TempRecommendations rec
	JOIN policymanagement..TPolicyBusiness pb ON pb.PolicyBusinessId = rec.TopupParentPolicyBusinessId
	JOIN policymanagement..TPolicyDetail pd ON pd.PolicyDetailId = pb.PolicyDetailId
	JOIN policymanagement..TPolicyOwner po ON po.PolicyDetailId = pd.PolicyDetailId
		AND po.PolicyOwnerId = (
			SELECT Min(PolicyOwnerId) FROM policymanagement..TPolicyOwner powner -- we are fetching only primary owner
			WHERE powner.PolicyDetailId = po.PolicyDetailId GROUP BY powner.PolicyDetailId)
	JOIN crm..TCRMContact own ON own.CRMContactId = po.CRMContactId

	LEFT JOIN policymanagement..TPolicyOwner po2 ON po2.PolicyDetailId = pd.PolicyDetailId
		AND po2.PolicyOwnerId = (
			SELECT Min(PolicyOwnerId) FROM policymanagement..TPolicyOwner powner -- we are fetching only secondary owner
			WHERE powner.PolicyDetailId = po2.PolicyDetailId 
			AND   powner.PolicyOwnerId != po.PolicyOwnerId  GROUP BY powner.PolicyDetailId)
	LEFT JOIN crm..TCRMContact own2 ON own2.CRMContactId = po2.CRMContactId

	JOIN policymanagement..TPlanDescription pdesc   ON pdesc.PlanDescriptionId = pd.PlanDescriptionId
	JOIN policymanagement..TRefProdProvider rp ON pdesc.RefProdProviderId = rp.RefProdProviderId
	JOIN crm..TCRMContact prov ON prov.CRMContactId = rp.CRMContactId
WHERE 
	pb.IndigoClientId = @TenantId
ORDER BY 
	po.PolicyOwnerId

SELECT
	rec.FinancialPlanningId, rec.FinancialPlanningSessionId, rec.FinancialPlanningScenarioId, rec.AdvisaCentaRecommendationStatusId,
	rec.ActionPlanId, rec.SolutionGroupId, rec.Owner1PartyId AS Owner1, rec.Owner2PartyId AS Owner2,
	rec.PolicyBusinessId, rec.TopupParentPolicyBusinessId, rec.ActionPlanProviderName, rec.RecommendationStatusDate AS StatusDate, 
	rec.PlanTypeThirdPartyDescription, rec.PlanTypeName, rec.ProdSubTypeName, rec.RecommendationStatus, rec.RejectedReason,
	rec.DeferredReason, rec.ActionPlanDnId, rec.QuoteId, rec.QuoteReference, rec.QuoteStatusId, rec.ObjectiveName, rec.GoalCategory,
	rec.RecommendationSolutionStatusDate, rec.RecommendationSolutionStatus, rec.GoalType, rec.FinancialPlanningCreatedDate,
	rec.FinancialPlanningScenarioName, tdt.WithdrawalType, tdt.IsEncashment, tdt.ContributionAmount AS ContributionAmount,
	tdt.WithdrawalAmount AS WithdrawalAmount, tdt.ContributionType AS ContributionType, tdt.WithdrawalType AS WithdrawalType,
	tdt.ContributionFrequency, tdt.WithdrawalFrequency, topup.Owner1CrmContactId as TopupParentOwner1CRMContactId, topup.Owner1FirstName +' '+ topup.Owner1LastName  AS TopupParentPrimaryOwnerName,
	topup.Owner2FirstName +' '+ topup.Owner2LastName  AS TopupParentSecondaryOwnerName, 
	policy.PolicyBusinessSeqRef, policy.PolicyNumber, policy.ProviderName, policy.Owner1FirstName + ' ' + policy.Owner1LastName as PolicyOwner1Name,
	refTransaction.TransactionType as 'TransactionType',
	owner1.FirstName as 'Owner1FirstName', owner1.LastName as 'Owner1LastName',
	owner2.FirstName as 'Owner2FirstName', owner2.LastName as 'Owner2LastName', policy.Owner1CrmContactId as PolicyOwnerPartyId,
	rec.RejectReasonNote, rec.DeferReasonNote,
	topup.PolicyBusinessSeqRef AS TopupParentPolicyBusinessSeqRef,
	topup.PolicyNumber AS TopupParentPolicyNumber,
	topup.ProviderName AS TopupParentProviderName,
	policy.Owner2FirstName + ' ' + policy.Owner2LastName as PolicyOwner2Name,
	rec.RecommendationName,
	statusReason.StatusReasonId,
	statusReason.Name as StatusReasonName

FROM
	@TempRecommendations rec
	LEFT JOIN @TransactionDetailsTable tdt	ON tdt.ActionPlanId = rec.ActionPlanId
	LEFT JOIN @PolicyBusinessDetails topup ON topup.PolicyBusinessId = rec.TopupParentPolicyBusinessId
	LEFT JOIN @PolicyBusinessDetails policy ON policy.PolicyBusinessId = rec.PolicyBusinessId
	LEFT JOIN crm..TCRMContact owner1 ON owner1.CRMContactId = rec.Owner1PartyId
	LEFT JOIN crm..TCRMContact owner2 ON owner2.CRMContactId = rec.Owner2PartyId
	LEFT JOIN factfind..TRefTransactionType refTransaction ON refTransaction.RefTransactionTypeId = rec.RefTransactionTypeId 
	LEFT JOIN policymanagement..TStatusReason statusReason ON statusReason.StatusReasonId = rec.StatusReasonId