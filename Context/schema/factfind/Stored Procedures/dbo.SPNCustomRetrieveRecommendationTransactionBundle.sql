
SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SPNCustomRetrieveRecommendationTransactionBundle] 
(
	@QuoteTransactionIds  VARCHAR(8000)
)
AS
BEGIN

--DECLARE @QuoteTransactionIds  VARCHAR(8000) ='1,2'

IF(OBJECT_ID('tempdb..#quotePlans') IS NOT NULL)
DROP TABLE #quotePlans

SELECT 	DISTINCT		
		qrs.QuoteResultId																						as QuoteResultId,
		CAST(''	AS VARCHAR(MAX))																				as SequentialRefs
INTO #quotePlans
FROM   policymanagement.dbo.TQuoteItemRecommendationStatus qrs
 JOIN policymanagement.dbo.FnSplit(@QuoteTransactionIds, ',') parslist   ON qrs.QuoteItemRecommendationStatusId = parslist.Value  
 JOIN policymanagement.dbo.TQuoteResult qr ON qr.QuoteResultId = qrs.QuoteResultId
 WHERE ISNULL(qrs.QuoteResultId, 0) > 0

UPDATE a
SET SequentialRefs = ISNULL(CONVERT(VARCHAR(MAX), (
	SELECT ',' +  ISNULL(CAST(pb.PolicyBusinessId AS VARCHAR(MAX))+'_'+ ISNULL(pb.SequentialRef, ''), '')
	FROM policymanagement.dbo.TQuoteResult qr 
	JOIN policymanagement.dbo.TPolicyBusinessExt pbe ON pbe.QuoteResultId = qr.QuoteResultId
	JOIN policymanagement.dbo.TPolicyBusiness pb ON pb.PolicyBusinessId = pbe.PolicyBusinessId
	WHERE qr.QuoteResultId = a.QuoteResultId
	FOR XML PATH(''), TYPE)),'')
FROM #quotePlans a

SELECT 	
		CAST(qrs.QuoteItemRecommendationStatusId AS VARCHAR(100))+'Q'												as RecommendationId,
		CAST(qrs.QuoteItemRecommendationStatusId AS VARCHAR(100))+'Q'												as TransactionId,
		fp.FinancialPlanningId																						as FinancialPlanningId,
		qrs.QuoteResultId																							as BundleId,
		qr.QuoteResultInternal																						as QuoteResultInternal,
		ISNULL(qc1.CorporateName, qc1.FirstName+' '+qc1.LastName)													as Owner1,
		ISNULL(qc2.CorporateName, qc2.FirstName+' '+qc2.LastName)													as Owner2,
		qr.ExpiryDate																								as ExpiryDate,
		qp.SequentialRefs																							as PlanIOBs
FROM   policymanagement.dbo.TQuoteItemRecommendationStatus qrs
 JOIN policymanagement.dbo.FnSplit(@QuoteTransactionIds, ',') parslist   ON qrs.QuoteItemRecommendationStatusId = parslist.Value 
 JOIN FactFind.dbo.[TFinancialPlanningSession] fps ON fps.FinancialPlanningSessionId = qrs.FinancialPlanningSessionId  
 JOIN FactFind.dbo.[TFinancialPlanning] fp ON fps.FinancialPlanningId = fp.FinancialPlanningId 
 JOIN policymanagement.dbo.TQuoteResult qr ON qr.QuoteResultId = qrs.QuoteResultId
 JOIN policymanagement.dbo.TQuote q ON q.QuoteId = qr.QuoteId
 LEFT JOIN crm.dbo.TCrmContact qc1 ON qc1.CRMContactId = q.CRMContactId1
 LEFT JOIN crm.dbo.TCrmContact qc2 ON qc1.CRMContactId = q.CRMContactId2
 LEFT JOIN #quotePlans qp ON qp.QuoteResultId = qr.QuoteResultId
WHERE ISNULL(qrs.QuoteResultId, 0) > 0
END