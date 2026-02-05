SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetFinancialPlanningRecommendations]	
	@FinancialPlanningIdsCsv  VARCHAR(8000),
	@TenantId bigint
AS


--declare 	@FinancialPlanningIdsCsv  VARCHAR(8000) = '98, 99, 100, 101, 102' ,
--	@TenantId bigint = 10155

declare @FinancialPlanningIds TABLE( Id bigint NOT NULL)

insert into @FinancialPlanningIds
Select convert(bigint,Value) from policymanagement..FnSplit(@FinancialPlanningIdsCsv,',')

IF (OBJECT_ID('tempdb..#ManualActions') IS NOT NULL) 
DROP TABLE #ManualActions

SELECT DISTINCT
	mr.ManualRecommendationId,
	rs.RefPlanType2ProdSubTypeId,
	MAX(rs.ManualRecommendationActionId)	ManualRecommendationActionId
INTO #ManualActions
FROM   FactFind.dbo.[TManualRecommendation] mr WITH(NOLOCK)
 JOIN FactFind..TManualRecommendationAction rs WITH(NOLOCK) ON rs.ManualRecommendationId = mr.ManualRecommendationId
 JOIN FactFind.dbo.[TFinancialPlanningSession] fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId  
 JOIN @FinancialPlanningIds fpIds ON fpIds.Id = fps.FinancialPlanningId
WHERE rs.RefPlanType2ProdSubTypeId IS NOT NULL
GROUP BY mr.ManualRecommendationId,	rs.RefPlanType2ProdSubTypeId	
UNION ALL
SELECT DISTINCT
	mr.ManualRecommendationId,
	ds.RefPlanType2ProdSubTypeId,
	MAX(rs.ManualRecommendationActionId)	ManualRecommendationActionId
FROM   FactFind.dbo.[TManualRecommendation] mr WITH(NOLOCK)
 JOIN FactFind..TManualRecommendationAction rs WITH(NOLOCK) ON rs.ManualRecommendationId = mr.ManualRecommendationId
 JOIN policymanagement..TPolicyBusiness pb WITH(NOLOCK) ON pb.PolicyBusinessId = rs.PolicyBusinessId
 JOIN policymanagement..TPolicyDetail pd WITH(NOLOCK) ON pd.PolicyDetailId = pb.PolicyDetailId
 JOIN policymanagement..TPlanDescription ds WITH(NOLOCK) ON ds.PlanDescriptionId = pd.PlanDescriptionId
 JOIN FactFind.dbo.[TFinancialPlanningSession] fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId  
 JOIN @FinancialPlanningIds fpIds ON fpIds.Id = fps.FinancialPlanningId
WHERE rs.PolicyBusinessId IS NOT NULL
GROUP BY mr.ManualRecommendationId,	ds.RefPlanType2ProdSubTypeId	



SELECT CAST(fpsc.FinancialPlanningScenarioId AS VARCHAR(100))+'O'												as RecommendationId,
	   fp.FinancialPlanningId																					as FinancialPlanningId,      
       fps.FinancialPlanningSessionId																			as FinancialPlanningSessionId,
       fps.[Description]																						as FinancialPlanningSessionName,
       fpsc.ScenarioName																						as ScenarioName,    
       rsss.[Status]					 																		as RecommendationStatus,
	   ISNULL(rss.StatusChangeDate, fpsc.CreatedDate)															as StatusDate,
       fpsc.StartDate																							as StartDate,
       fpsc.TargetDate																							as TargetDate,	  
	   fpsc.CreatedDate																							as CreatedDate,
	   rss.RecommendationName																					as RecommendationName,
	   n.LatestNote																								as RecommendationNote
FROM   FactFind.dbo.[TFinancialPlanningScenario] fpsc
 JOIN FactFind.dbo.[TFinancialPlanning] fp ON fpsc.FinancialPlanningId = fp.FinancialPlanningId 
 JOIN FactFind.dbo.[TFinancialPlanningSession] fps ON fps.FinancialPlanningId = fp.FinancialPlanningId  
 LEFT JOIN FactFind.dbo.TActionPlan ap ON ap.ScenarioId = fpsc.FinancialPlanningScenarioId
 LEFT JOIN FactFind.dbo.TAdvisaCentaRecommendationStatus acrs ON acrs.ActionPlanId = ap.ActionPlanId
 LEFT JOIN FactFind.dbo.TRecommendationSolutionStatus rss ON rss.FinancialPlanningSessionId = fps.FinancialPlanningSessionId AND rss.SolutionGroup = ap.SolutionGroupId
 LEFT JOIN FactFind.dbo.TRefRecommendationStatus rrs ON rrs.RefRecommendationStatusId = acrs.RefRecommendationStatusId
 LEFT JOIN FactFind.dbo.TRefRecommendationSolutionStatus rsss on rsss.RefRecommendationSolutionStatusId = rss.RefRecommendationSolutionStatusId
 LEFT JOIN crm..TNote n ON n.EntityId = rss.RecommendationSolutionStatusId and n.EntityType = 'oldrecommendation'
WHERE fpsc.FinancialPlanningId in ( Select Id from @FinancialPlanningIds ) 

UNION 

SELECT CAST(mr.ManualRecommendationId AS VARCHAR(100))+'M'														as RecommendationId,	 
       fp.FinancialPlanningId																					as FinancialPlanningId,      
       mr.FinancialPlanningSessionId																			as FinancialPlanningSessionId,
       fps.[Description]																						as FinancialPlanningSessionName,
       ISNULL(c.CorporateName, c.FirstName+' '+ c.LastName)+ ', '+
	   CASE WHEN ISNULL(st.ProdSubTypeName, '') = ''
		THEN pt.PlanTypeName ELSE pt.PlanTypeName+ '('+ st.ProdSubTypeName+') '
	   +  CONVERT(VARCHAR(10),mr.CreationDate,103) 
	   END																							            as ScenarioName,    
	   rs.Status																								as RecommendationStatus,
	   mr.ModificationDate																						as StatusDate,
       null																										as StartDate,
       null																										as TargetDate,
	   mr.CreationDate																							as CreatedDate,
	   mr.RecommendationName																					as RecommendationName,
	   n.LatestNote																								as RecommendationNote
FROM   FactFind.dbo.[TManualRecommendation] mr
 JOIN FactFind..TRefRecommendationSolutionStatus rs ON rs.RefRecommendationSolutionStatusId = mr.RefRecommendationSolutionStatusId
 JOIN FactFind.dbo.[TFinancialPlanningSession] fps ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId  
 JOIN FactFind.dbo.[TFinancialPlanning] fp ON fps.FinancialPlanningId = fp.FinancialPlanningId 
 JOIN FactFind..TFactFind ff ON ff.FactFindId = fp.FactFindId
 JOIN Crm..TCRMContact c ON c.CRMContactId = ff.CRMContactId1
 Left JOIN #ManualActions ma  ON ma.ManualRecommendationId = mr.ManualRecommendationId
 JOIN policymanagement..TRefPlanType2ProdSubType rptps ON rptps.RefPlanType2ProdSubTypeId = ma.RefPlanType2ProdSubTypeId
 JOIN policymanagement..TRefPlanType pt ON pt.RefPlanTypeId = rptps.RefPlanTypeId
 LEFT JOIN policymanagement..TProdSubType st ON st.ProdSubTypeId = rptps.ProdSubTypeId
 LEFT JOIN crm..TNote n ON n.EntityId = mr.ManualRecommendationId and n.EntityType = 'newrecommendation'
WHERE fps.FinancialPlanningId in ( Select Id from @FinancialPlanningIds ) 

UNION 

SELECT CAST(qr.QuoteItemRecommendationStatusId AS VARCHAR(100))+'Q'												as RecommendationId,
       fp.FinancialPlanningId																					as FinancialPlanningId,      
       qr.FinancialPlanningSessionId																			as FinancialPlanningSessionId,
       fps.[Description]																						as FinancialPlanningSessionName,
       ISNULL(c.CorporateName, c.FirstName+' '+ c.LastName)+ ', '
				+ CASE WHEN pg.ProductGroupName IS NOT NULL AND pt.ProductTypeName IS NOT NULL
					THEN pg.ProductGroupName +' ('+ pt.ProductTypeName +') '
					ELSE ''
				  END
				+ CONVERT(VARCHAR(10),qr.CreationDate,103) 														as ScenarioName,    
	   rs.Status																								as RecommendationStatus,
	   qr.SolutionStatusDate																					as StatusDate,
       null																										as StartDate,
       null																										as TargetDate,
	   qr.CreationDate																							as CreatedDate,
	   qr.RecommendationName																					as RecommendationName,
	   n.LatestNote																								as RecommendationNote
FROM   policymanagement.dbo.TQuoteItemRecommendationStatus qr
 left JOIN FactFind..TRefRecommendationSolutionStatus rs ON rs.RefRecommendationSolutionStatusId = qr.RefSolutionStatusId
 JOIN FactFind.dbo.[TFinancialPlanningSession] fps ON fps.FinancialPlanningSessionId = qr.FinancialPlanningSessionId  
 JOIN FactFind.dbo.[TFinancialPlanning] fp ON fps.FinancialPlanningId = fp.FinancialPlanningId 
 LEFT JOIN policymanagement.dbo.TQuoteItem qi ON qi.QuoteItemId = qr.QuoteItemId
 LEFT JOIN policymanagement.dbo.TQuote q ON q.QuoteId = qi.QuoteId
 LEFT JOIN policymanagement.dbo.TRefProductType pt ON pt.RefProductTypeId = q.RefProductTypeId
 LEFT JOIN policymanagement.dbo.TRefProductGroup pg ON pg.RefProductGroupId = pt.RefProductGroupId
 JOIN FactFind..TFactFind ff ON ff.FactFindId = fp.FactFindId
 JOIN Crm..TCRMContact c ON c.CRMContactId = ff.CRMContactId1
 LEFT JOIN crm..TNote n ON n.EntityId = qr.QuoteItemRecommendationStatusId and n.EntityType = 'quoterecommendation'
WHERE fps.FinancialPlanningId in ( Select Id from @FinancialPlanningIds ) 