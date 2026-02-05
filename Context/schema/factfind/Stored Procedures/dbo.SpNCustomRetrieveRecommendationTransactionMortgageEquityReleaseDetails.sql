SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveRecommendationTransactionMortgageEquityReleaseDetails]
	 @ManualTransactionIds VARCHAR(8000)
AS 
BEGIN

IF(OBJECT_ID('tempdb..#ManualTIds') IS NOT NULL) DROP TABLE #ManualTIds
SELECT DISTINCT Value AS Id INTO #ManualTIds FROM policymanagement.dbo.FnSplit(@ManualTransactionIds, ',')

	SELECT 
		CAST(mr.ManualRecommendationId AS VARCHAR(100))+'M'	as RecommendationId,
		CAST(ma.ManualRecommendationActionId AS VARCHAR(100))+'M' as TransactionId,
		fps.FinancialPlanningId	as FinancialPlanningId,
		ma.DetailsXml as DetailsXml,
		ISNULL(owner3.CorporateName, (cast(owner3.FirstName as NVARCHAR(255)) + ' '+ cast(owner3.LastName as NVARCHAR(255)))) as Owner3,
		ISNULL(owner4.CorporateName, (cast(owner4.FirstName as NVARCHAR(255)) + ' '+ cast(owner4.LastName as NVARCHAR(255)))) as Owner4,
		ert.EquityReleaseType as EquityReleaseType,
		factfind.dbo.FnCustomGetRecommendationMortgageEquityAddress(ISNULL(XEQC.value('SelectedAddress[1]', 'varchar(255)'), XMC.value('SelectedAddress[1]', 'varchar(255)'))) as SelectedAddress
	FROM factfind.dbo.TManualRecommendationAction ma WITH(NOLOCK)
	INNER JOIN #ManualTIds Ids ON ma.ManualRecommendationActionId = ids.Id
	INNER JOIN FactFind.dbo.TManualRecommendation mr WITH(NOLOCK) ON ma.ManualRecommendationId = mr.ManualRecommendationId	
	INNER JOIN FactFind.dbo.TFinancialPlanningSession fps WITH(NOLOCK) ON fps.FinancialPlanningSessionId = mr.FinancialPlanningSessionId 
	OUTER APPLY DetailsXml.nodes('/PlanDetails/EquityRelease') AS XEQT(XEQC) --table alias XEQT, single column aliassed as XEQC
	OUTER APPLY DetailsXml.nodes('/PlanDetails/Mortgage') AS XMT(XMC) --table alias XMT, single column aliassed as XMC
	LEFT JOIN CRM..TRefEquityReleaseType ert WITH(NOLOCK) ON ert.RefEquityReleaseTypeId = XEQT.XEQC.value('RefEquityReleaseTypeId[1]', 'int')
	LEFT JOIN CRM..TCRMContact owner3 WITH(NOLOCK) ON owner3.CRMContactId = ISNULL(XEQC.value('Owner3[1]', 'int'), XMC.value('Owner3[1]', 'int'))
	LEFT JOIN CRM..TCRMContact owner4 WITH(NOLOCK) ON owner4.CRMContactId = ISNULL(XEQC.value('Owner4[1]', 'int'), XMC.value('Owner4[1]', 'int'))

END