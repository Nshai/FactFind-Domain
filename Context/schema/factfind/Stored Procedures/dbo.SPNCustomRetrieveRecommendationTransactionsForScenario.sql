SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SPNCustomRetrieveRecommendationTransactionsForScenario] 
(
	 @FinancialPlanningScenarioIds VARCHAR(8000),
	 @ManualRecommendationIds VARCHAR(8000),
	 @QuoteRecommendationIds VARCHAR(8000),
	 @TenantId int
)
AS
BEGIN


--DECLARE  @FinancialPlanningScenarioIds VARCHAR(8000) = '40',
--@ManualRecommendationIds VARCHAR(8000)= '126, 127, 154, 155, 173, 174, 175, 176, 177, 178, 179, 186, 187, 188, 29, 30, 31, 32, 49, 50, 54, 58, 68, 78, 79, 80, 81, 83, 84, 85' ,
--@QuoteRecommendationIds VARCHAR(8000) = '102, 103, 124, 125, 65, 66, 67, 72, 73, 74, 75, 88',
--@TenantId int = 10155



IF(OBJECT_ID('tempdb..#ScenarioIds') IS NOT NULL)
DROP TABLE #ScenarioIds

SELECT DISTINCT Value AS Id INTO #ScenarioIds FROM policymanagement.dbo.FnSplit(@FinancialPlanningScenarioIds, ',')

IF(OBJECT_ID('tempdb..#ManualIds') IS NOT NULL)
DROP TABLE #ManualIds

SELECT DISTINCT Value AS Id INTO #ManualIds FROM policymanagement.dbo.FnSplit(@ManualRecommendationIds, ',')

IF(OBJECT_ID('tempdb..#QuoteIds') IS NOT NULL)
DROP TABLE #QuoteIds
SELECT DISTINCT Value AS Id INTO #QuoteIds FROM policymanagement.dbo.FnSplit(@QuoteRecommendationIds, ',')

IF(OBJECT_ID('tempdb..#PolicyOwner') IS NOT NULL)
DROP TABLE #PolicyOwner

DECLARE @PolicyBusiness TABLE (
 PolicyBusinessId int null,
 SequentialReference varchar(50) null,
 PolicyNumber varchar(50) null,
 Provider varchar(255) null,
 PolicyDetailId int null,
 Owner1 int null,
 Owner2 int null	
)

INSERT INTO @PolicyBusiness(PolicyBusinessId, SequentialReference, PolicyNumber, Provider, PolicyDetailId)
SELECT DISTINCT
	pb.PolicyBusinessId,																							
	pb.SequentialRef,																							
	pb.PolicyNumber,																								
	pvc.CorporateName,
	pd.PolicyDetailId	
FROM factfind..TActionPlan ap WITH(NOLOCK)
	JOIN #ScenarioIds s   ON s.Id = ap.ScenarioId
	JOIN policymanagement..TPolicyBusiness pb WITH(NOLOCK) ON pb.PolicyBusinessId = ap.PolicyBusinessId
    JOIN policymanagement..TPolicyDetail pd WITH(NOLOCK) ON pd.PolicyDetailId = pb.PolicyDetailId
	JOIN policymanagement..TPlanDescription ds WITH(NOLOCK) ON ds.PlanDescriptionId = pd.PlanDescriptionId 
	JOIN policymanagement..TRefProdProvider pv WITH(NOLOCK) ON pv.RefProdProviderId = ds.RefProdProviderId 
	JOIN Crm..TCRMContact pvc WITH(NOLOCK) ON pvc.CRMContactId = pv.CRMContactId
WHERE pb.IndigoClientId = @TenantId
UNION
SELECT DISTINCT
	pb.PolicyBusinessId,																							
	pb.SequentialRef,																							
	pb.PolicyNumber,																								
	pvc.CorporateName,
	pd.PolicyDetailId	
FROM factfind..TActionPlan ap WITH(NOLOCK)
	JOIN #ScenarioIds s   ON s.Id = ap.ScenarioId
	JOIN policymanagement..TPolicyBusiness pb WITH(NOLOCK) ON pb.PolicyBusinessId = ap.TopupParentPolicyBusinessId
    JOIN policymanagement..TPolicyDetail pd WITH(NOLOCK) ON pd.PolicyDetailId = pb.PolicyDetailId
	JOIN policymanagement..TPlanDescription ds WITH(NOLOCK) ON ds.PlanDescriptionId = pd.PlanDescriptionId 
	JOIN policymanagement..TRefProdProvider pv WITH(NOLOCK) ON pv.RefProdProviderId = ds.RefProdProviderId 
	JOIN Crm..TCRMContact pvc WITH(NOLOCK) ON pvc.CRMContactId = pv.CRMContactId
WHERE pb.IndigoClientId = @TenantId
UNION
SELECT DISTINCT
	pb.PolicyBusinessId,																							
	pb.SequentialRef,																							
	pb.PolicyNumber,																								
	pvc.CorporateName,
	pd.PolicyDetailId							
FROM FactFind.dbo.TManualRecommendationAction ma WITH(NOLOCK) 
	JOIN #ManualIds m ON m.Id = ma.ManualRecommendationId 
	JOIN policymanagement..TPolicyBusiness pb WITH(NOLOCK) ON pb.PolicyBusinessId = ma.PolicyBusinessId
    JOIN policymanagement..TPolicyDetail pd WITH(NOLOCK) ON pd.PolicyDetailId = pb.PolicyDetailId
	JOIN policymanagement..TPlanDescription ds WITH(NOLOCK) ON ds.PlanDescriptionId = pd.PlanDescriptionId 
	JOIN policymanagement..TRefProdProvider pv WITH(NOLOCK) ON pv.RefProdProviderId = ds.RefProdProviderId 
	JOIN Crm..TCRMContact pvc WITH(NOLOCK) ON pvc.CRMContactId = pv.CRMContactId
WHERE pb.IndigoClientId = @TenantId
UNION
SELECT DISTINCT
	pb.PolicyBusinessId,																							
	pb.SequentialRef,																							
	pb.PolicyNumber,																								
	pvc.CorporateName,
	NULL									
FROM policymanagement.dbo.TQuoteItemRecommendationStatus ma WITH(NOLOCK) 
	JOIN #QuoteIds q ON q.Id = ma.QuoteItemRecommendationStatusId 
	JOIN policymanagement..TPolicyBusiness pb WITH(NOLOCK) ON pb.PolicyBusinessId = ma.PolicyBusinessId
    JOIN policymanagement..TPolicyDetail pd WITH(NOLOCK) ON pd.PolicyDetailId = pb.PolicyDetailId
	JOIN policymanagement..TPlanDescription ds WITH(NOLOCK) ON ds.PlanDescriptionId = pd.PlanDescriptionId 
	JOIN policymanagement..TRefProdProvider pv WITH(NOLOCK) ON pv.RefProdProviderId = ds.RefProdProviderId 
	JOIN Crm..TCRMContact pvc WITH(NOLOCK) ON pvc.CRMContactId = pv.CRMContactId
WHERE pb.IndigoClientId = @TenantId

SELECT DISTINCT po.PolicyOwnerId, po.PolicyDetailId PolicyDetailId, po.CRMContactId CRMContactId, ROW_NUMBER() OVER (PARTITION BY pb.PolicyBusinessId, po.PolicyDetailId ORDER BY po.PolicyOwnerId) Number 
INTO #PolicyOwner	
FROM @PolicyBusiness pb INNER JOIN policymanagement..TPolicyOwner po ON po.PolicyDetailId = pb.PolicyDetailId

UPDATE @PolicyBusiness
Set Owner1 = po.CRMContactId, Owner2 = po2.CRMContactId
FROM @PolicyBusiness pb INNER JOIN  #PolicyOwner po  ON po.PolicyDetailId = pb.PolicyDetailId AND po.Number = 1 
	 LEFT JOIN  #PolicyOwner po2  ON po2.PolicyDetailId = pb.PolicyDetailId AND po2.Number = 2 

IF(OBJECT_ID('tempdb..#Opportunites') IS NOT NULL)
DROP TABLE #Opportunites

SELECT
fps.ServiceCaseId,
os.OpportunityId,
fpo.CreatedDate																								as OpportunityDate,
fpot.OpportunityTypeName																					as OpportunityType
INTO #Opportunites
FROM factfind..TActionPlan ap WITH(NOLOCK)	
	JOIN #ScenarioIds s   ON ap.ScenarioId = s.Id 
	JOIN FactFind.dbo.[TFinancialPlanning] fp  WITH(NOLOCK) ON ap.FinancialPlanningId = fp.FinancialPlanningId 
	JOIN FactFind.dbo.[TFinancialPlanningSession] fps  WITH(NOLOCK) ON fps.FinancialPlanningId = fp.FinancialPlanningId  
	JOIN Crm.dbo.TServiceCaseToOpportunity os WITH(NOLOCK) ON os.AdviceCaseId = fps.ServiceCaseId
	JOIN Crm.dbo.TOpportunity fpo WITH(NOLOCK) ON fpo.OpportunityId = os.OpportunityId
	JOIN Crm.dbo.TOpportunityType fpot WITH(NOLOCK) ON fpot.OpportunityTypeId = fpo.OpportunityTypeId
WHERE fpo.IndigoClientId = @TenantId
UNION

SELECT
fps.ServiceCaseId,
os.OpportunityId,
fpo.CreatedDate																								as OpportunityDate,
fpot.OpportunityTypeName																					as OpportunityType
FROM  FactFind.dbo.[TManualRecommendation] mr WITH(NOLOCK) 
	JOIN #ManualIds s   ON mr.ManualRecommendationId = s.Id 
	JOIN FactFind.dbo.[TFinancialPlanningSession] fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId 	
	JOIN Crm.dbo.TServiceCaseToOpportunity os WITH(NOLOCK) ON os.AdviceCaseId = fps.ServiceCaseId
	JOIN Crm.dbo.TOpportunity fpo WITH(NOLOCK) ON fpo.OpportunityId = os.OpportunityId
	JOIN Crm.dbo.TOpportunityType fpot WITH(NOLOCK) ON fpot.OpportunityTypeId = fpo.OpportunityTypeId
WHERE fpo.IndigoClientId = @TenantId
UNION
SELECT
fps.ServiceCaseId,
os.OpportunityId,
fpo.CreatedDate																								as OpportunityDate,
fpot.OpportunityTypeName																					as OpportunityType
FROM  policymanagement.dbo.TQuoteItemRecommendationStatus ma WITH(NOLOCK) 
	JOIN #QuoteIds s   ON ma.QuoteItemRecommendationStatusId = s.Id 
	JOIN FactFind.dbo.[TFinancialPlanningSession] fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = ma.FinancialPlanningSessionId 
	JOIN Crm.dbo.TServiceCaseToOpportunity os WITH(NOLOCK) ON os.AdviceCaseId = fps.ServiceCaseId
	JOIN Crm.dbo.TOpportunity fpo WITH(NOLOCK) ON fpo.OpportunityId = os.OpportunityId
	JOIN Crm.dbo.TOpportunityType fpot WITH(NOLOCK) ON fpot.OpportunityTypeId = fpo.OpportunityTypeId
WHERE fpo.IndigoClientId = @TenantId
	

SELECT 		
		CAST(ap.ScenarioId AS VARCHAR(100))+'O'																		as RecommendationId,
		CAST(ap.ActionPlanId AS VARCHAR(100))+'O'																	as TransactionId,
		ap.FinancialPlanningId																						as FinancialPlanningId,
	
		ISNULL(crm1.CorporateName, crm1.Firstname + ' ' + crm1.Lastname)											AS Owner1,
		ISNULL(crm2.CorporateName, crm2.Firstname + ' ' + crm2.Lastname)											AS Owner2,
		
		ISNULL(apdn.RefPlan2ProdSubTypeId,ISNULL(ap.RefPlan2ProdSubTypeId, 0))										AS PlanTypeId,
		ap.PlanTypeThirdPartyDescription																			as ThirdPartyPlanType,	
		ISNULL(ap.IsExecuted, 0)																					as IsExecuted,
		
		CASE			
			WHEN ap.TopupParentPolicyBusinessId > 0 THEN 7 
			WHEN ( (ISNULL(ap.IsNewProposal, 0) = 0 AND ap.PolicyBusinessId > 0) AND (apc.ActionPlanContributionId IS NOT NULL AND apc.IsIncreased = 1)) THEN 6  
			WHEN ( (ISNULL(ap.IsNewProposal, 0) = 0 AND ap.PolicyBusinessId > 0) AND (apc.ActionPlanContributionId IS NOT NULL AND apc.IsIncreased = 0)) THEN 5  
			WHEN ( (ISNULL(ap.IsNewProposal, 0) = 0 AND ap.PolicyBusinessId > 0) AND (apw.ActionPlanWithdrawalId IS NOT NULL AND apw.WithdrawalType = 'Lump_Sum')) THEN 2  
			WHEN ( (ISNULL(ap.IsNewProposal, 0) = 0 AND ap.PolicyBusinessId > 0) AND (apw.ActionPlanWithdrawalId IS NOT NULL AND apw.IsIncreased = 1)) THEN 4 
			WHEN ( (ISNULL(ap.IsNewProposal, 0) = 0 AND ap.PolicyBusinessId > 0) AND (apw.ActionPlanWithdrawalId IS NOT NULL AND apw.IsIncreased = 0)) THEN 3 
			WHEN ( (ISNULL(ap.IsNewProposal, 0) = 0 AND ap.PolicyBusinessId > 0) AND (apf.ActionFundId IS NOT NULL)) THEN 1  			
			WHEN ( (ISNULL(ap.IsNewProposal, 0) = 1 OR ISNULL(ap.PolicyBusinessId, 0) = 0)) THEN 8  
			WHEN ISNULL(acrs.RefTransactionTypeId, 0) = 12 THEN 12
			ELSE 0
		END																											as TransactionType,
		CASE
			WHEN topup.PolicyBusinessId IS NOT NULL THEN topup.SequentialReference
			ELSE pb.SequentialReference
		END																											as SequentialReference,
		CASE
			WHEN topup.PolicyBusinessId IS NOT NULL THEN topup.PolicyNumber
			ELSE pb.PolicyNumber
		END																											as PolicyNumber,
		CASE 
			WHEN acrs.RefTransactionTypeId = 7 THEN topup.Provider
			ELSE ISNULL(ap.ProviderName, pb.Provider)
		END																											as Provider,
		rrs.Identifier																								as [Status],
		acrs.StatusDate																								as StatusDate,
		ISNULL(masr.Name, ISNULL(rr.[Description], dr.DeferredReason))												as StatusReason,
		ISNULL(acrs.RejectReasonNote, acrs.DeferReasonNote)															as StatusReasonNotes,
		op.OpportunityDate																							as OpportunityDate,
		op.OpportunityType																							as OpportunityType,
		null																										as Cover,
		NULL																										AS Term
		
	FROM factfind..TActionPlan ap WITH(NOLOCK)
	LEFT JOIN factfind..TActionPlanDN apdn WITH(NOLOCK) ON ap.ActionPlanId = apdn.ActionPlanId	
	JOIN #ScenarioIds s   ON ap.ScenarioId = s.Id 
	JOIN FactFind.dbo.[TFinancialPlanning] fp  WITH(NOLOCK) ON ap.FinancialPlanningId = fp.FinancialPlanningId 
	JOIN FactFind.dbo.[TFinancialPlanningSession] fps  WITH(NOLOCK) ON fps.FinancialPlanningId = fp.FinancialPlanningId  
	JOIN FactFind.dbo.[TFactFind] ff  WITH(NOLOCK) ON ff.FactFindId = fps.FactFindId  
	
	LEFT JOIN factfind..TActionPlanContribution apc WITH(NOLOCK) ON apc.ActionPlanId = apdn.ActionPlanId
	LEFT JOIN factfind..TActionPlanWithdrawal apw WITH(NOLOCK) ON apw.ActionPlanId = apdn.ActionPlanId
	OUTER APPLY
	(
		SELECT TOP 1
			[ActionFundId]
		FROM factfind..TActionFund WITH(NOLOCK)
		WHERE [ActionPlanId] = ap.ActionPlanId
	) apf
	LEFT JOIN @PolicyBusiness pb ON pb.PolicyBusinessId = ap.PolicyBusinessId
    LEFT JOIN @PolicyBusiness topup ON topup.PolicyBusinessId = ap.TopupParentPolicyBusinessId 
	LEFT JOIN crm..TCRMContact crm1 WITH(NOLOCK) ON crm1.crmcontactid = ISNULL(ISNULL(pb.Owner1, topup.Owner1), apdn.Owner1)
	LEFT JOIN crm..TCRMContact crm2 WITH(NOLOCK) ON crm2.crmcontactid = ISNULL(ISNULL(pb.Owner2 , topup.Owner2), apdn.Owner2) 

	LEFT JOIN #Opportunites op ON op.ServiceCaseId = fps.ServiceCaseId
	LEFT JOIN factfind.dbo.TAdvisaCentaRecommendationStatus acrs WITH(NOLOCK) ON acrs.ActionPlanId = ap.ActionPlanId
	LEFT JOIN factfind.dbo.TRefRecommendationStatus rrs WITH(NOLOCK) ON rrs.RefRecommendationStatusId = acrs.RefRecommendationStatusId
	LEFT JOIN policymanagement..TStatusReason masr WITH(NOLOCK) ON masr.StatusReasonId = ap.StatusReasonId
	LEFT JOIN factfind.dbo.TRefRejectedReason rr WITH(NOLOCK) ON rr.RefRejectedReasonId = acrs.RefRejectedReasonId
	LEFT JOIN factfind.dbo.TRefDeferredReason dr WITH(NOLOCK) ON dr.RefDeferredReasonId = acrs.RefDeferredReasonId
	Where ff.IndigoClientId = @TenantId
	
	UNION ALL

	SELECT	
		 CAST(ma.ManualRecommendationId AS VARCHAR(100))+'M'														as RecommendationId,
		 CAST(ma.ManualRecommendationActionId AS VARCHAR(100))+'M'													as TransactionId,
		 fps.FinancialPlanningId																					as FinancialPlanningId,
	
		CASE WHEN (ISNULL(crm1pb.CRMContactId, 0) = 0)
		THEN ISNULL(crm1fps.CorporateName, ISNULL(crm1fps.Firstname + ' ' + crm1fps.Lastname, ''))
		ELSE ISNULL(crm1pb.CorporateName, ISNULL(crm1pb.Firstname + ' ' + crm1pb.Lastname, ''))
		END																											as Owner1,
		
		CASE WHEN (ISNULL(crm2pb.CRMContactId, 0) = 0)
		THEN ISNULL(crm2fps.CorporateName, ISNULL(crm2fps.Firstname + ' ' + crm2fps.Lastname, ''))
		ELSE ISNULL(crm2pb.CorporateName, ISNULL(crm2pb.Firstname + ' ' + crm2pb.Lastname, ''))
		END																											as Owner2,
		
		ma.RefPlanType2ProdSubTypeId																				as PlanTypeId,
		null																										as ThirdPartyPlanType,	
		null																										as IsExecuted,
		
		ma.ActionType																								as TransactionType,
		pb.SequentialReference																						as SequentialReference,
		pb.PolicyNumber																								as PolicyNumber,
		ISNULL(pb.Provider, pvc2.CorporateName)																		as Provider,
		CASE WHEN ISNULL(ma.DeferReasonNote, ma.RejectReasonNote) IS NOT NULL
			THEN mast.Identifier + ' Other'
			ELSE mast.Identifier 					
		END																											as [Status],
		ma.ModificationDate																							as StatusDate,
		ISNULL(masr.Name, ISNULL(marr.Description, madr.DeferredReason)	)											as StatusReason,
		ISNULL(ma.DeferReasonNote, ma.RejectReasonNote)																as StatusReasonNotes,
		op.OpportunityDate																							as OpportunityDate,
		op.OpportunityType																							as OpportunityType,
		null																										as Cover,
		NULL																										AS Term	
	

	FROM FactFind.dbo.TManualRecommendationAction ma WITH(NOLOCK) 
	JOIN FactFind.dbo.[TManualRecommendation] mr WITH(NOLOCK) ON ma.ManualRecommendationId = mr.ManualRecommendationId
	JOIN #ManualIds mir ON mir.id = mr.ManualRecommendationId 
	JOIN FactFind.dbo.[TFinancialPlanningSession] fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId 
	JOIN FactFind.dbo.[TFactFind] ff  WITH(NOLOCK) ON ff.FactFindId = fps.FactFindId  	
	LEFT JOIN @PolicyBusiness pb ON pb.PolicyBusinessId = ma.PolicyBusinessId 
	JOIN #Opportunites op ON op.ServiceCaseId = fps.ServiceCaseId
	LEFT JOIN crm..TCrmContact crm1pb On crm1pb.CRMContactId = pb.Owner1
	LEFT JOIN crm..TCrmContact crm1fps On crm1fps.CRMContactId = fps.CRMContactId
	LEFT JOIN crm..TCrmContact crm2pb On crm2pb.CRMContactId = pb.Owner2
	LEFT JOIN crm..TCrmContact crm2fps On crm2fps.CRMContactId = fps.CRMContactId2

	JOIN Factfind..TRefRecommendationStatus mast WITH(NOLOCK) ON mast.RefRecommendationStatusId = ma.RefRecommendationStatusId
	LEFT JOIN policymanagement..TStatusReason masr WITH(NOLOCK) ON masr.StatusReasonId = ma.StatusReasonId	
	LEFT JOIN factfind..TRefRejectedReason marr WITH(NOLOCK) ON marr.RefRejectedReasonId = ma.RejectReasonId
	LEFT JOIN factfind..TRefDeferredReason madr WITH(NOLOCK) ON madr.RefDeferredReasonId = ma.DeferReasonId
	LEFT JOIN policymanagement..TRefProdProvider pv2 WITH(NOLOCK) ON pv2.RefProdProviderId = ma.RefProdProviderId 
	LEFT JOIN Crm..TCRMContact pvc2 WITH(NOLOCK) ON pvc2.CRMContactId = pv2.CRMContactId
	WHERE ff.IndigoClientId =@TenantId
	
	UNION ALL

	SELECT	
		 CAST(ma.QuoteItemRecommendationStatusId AS VARCHAR(100))+'Q'												as RecommendationId,		
		 CAST(ma.QuoteItemRecommendationStatusId AS VARCHAR(100))+'Q'												as TransactionId,
		 fps.FinancialPlanningId																					as FinancialPlanningId,
	
		ISNULL(crm1.CorporateName, ISNULL(crm1.Firstname + ' ' + crm1.Lastname, ''))								as Owner1,
		ISNULL(crm2.CorporateName, ISNULL(crm2.Firstname + ' ' + crm2.Lastname, ''))								as Owner2,
		
		qpt.RefPlanType2ProdSubTypeId																				as PlanTypeId,
		qi.ProductDescription																						as ThirdPartyPlanType,	
		null																										as IsExecuted,		
		8																											as TransactionType,
		pb.SequentialReference																						as SequentialReference,
		pb.PolicyNumber																								as PolicyNumber,
		pb.Provider																									as Provider,
		CASE WHEN ISNULL(ma.DeferReasonNote, ma.RejectReasonNote) IS NOT NULL
			THEN mast.Identifier + ' Other'
			ELSE mast.Identifier					
		END																											as [Status],
		ma.StatusDate																								as StatusDate,
		ISNULL(marr.Description, madr.DeferredReason)																as StatusReason,
		ISNULL(ma.DeferReasonNote, ma.RejectReasonNote)																as StatusReasonNotes,
		op.OpportunityDate																							as OpportunityDate,
		op.OpportunityType																							as OpportunityType,
		qt.CoverAmount																								as Cover,
		[dbo].[FnCustomGetTermQuoteValue](pt.TermType,pt.Value,q.SummaryXML)										as Term
	FROM policymanagement.dbo.TQuoteItemRecommendationStatus ma WITH(NOLOCK) 
	JOIN #QuoteIds qs   ON ma.QuoteItemRecommendationStatusId = qs.Id
	JOIN FactFind.dbo.[TFinancialPlanningSession] fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = ma.FinancialPlanningSessionId 
	JOIN FactFind.dbo.[TFactFind] ff  WITH(NOLOCK) ON ff.FactFindId = fps.FactFindId  	
	JOIN crm..TCrmContact crm1 On crm1.CRMContactId = fps.CRMContactId 
	LEFT JOIN policymanagement.dbo.[TQuoteItem] qi WITH(NOLOCK) ON qi.QuoteItemId = ma.QuoteItemId
	LEFT JOIN policymanagement.dbo.[TQuote] q WITH(NOLOCK) ON qi.QuoteId = q.QuoteId
	LEFT JOIN policymanagement.dbo.TQuoteTerm qt WITH(NOLOCK) ON qt.QuoteItemId = qi.QuoteItemId
	LEFT JOIN policymanagement.dbo.TRefProductType qpt WITH(NOLOCK) ON q.RefProductTypeId = qpt.RefProductTypeId	
	LEFT JOIN crm..TCrmContact crm2 On crm2.CRMContactId = fps.CRMContactId2 
	LEFT JOIN @PolicyBusiness pb ON pb.PolicyBusinessId = ma.PolicyBusinessId 
	JOIN #Opportunites op ON op.ServiceCaseId = fps.ServiceCaseId
	LEFT JOIN Factfind..TRefRecommendationStatus mast WITH(NOLOCK) ON mast.RefRecommendationStatusId = ma.RefRecommendationStatusId
	LEFT JOIN factfind..TRefRejectedReason marr WITH(NOLOCK) ON marr.RefRejectedReasonId = ma.RejectReasonId
	LEFT JOIN factfind..TRefDeferredReason madr WITH(NOLOCK) ON madr.RefDeferredReasonId = ma.DeferReasonId
	LEFT JOIN policymanagement.dbo.TTermQuote tq  WITH(NOLOCK) ON tq.QuoteId = q.QuoteId
	LEFT JOIN policymanagement.dbo.TProductTerm pt WITH (NOLOCK) ON pt.ProductTermId = tq.ProductTermId		
	WHERE ff.IndigoClientId =@TenantId

END
