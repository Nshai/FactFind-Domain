SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveFinancialPlanningSessionById]
	@FinancialPlanningSessionId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.FinancialPlanningSessionId AS [FinancialPlanningSession!1!FinancialPlanningSessionId], 
	T1.FinancialPlanningId	 AS [FinancialPlanningSession!1!FinancialPlanningId], 
	T1.FactFindId	 AS [FinancialPlanningSession!1!FactFindId], 
	T1.CRMContactId AS [FinancialPlanningSession!1!CRMContactId], 
	T1.Description AS [FinancialPlanningSession!1!Description], 
	CONVERT(varchar(24), T1.Date, 120) AS [FinancialPlanningSession!1!Date], 
	ISNULL(T1.RefFinancialPlanningSessionStatusId, '') AS [FinancialPlanningSession!1!RefFinancialPlanningSessionStatusId], 
	T1.UserId AS [FinancialPlanningSession!1!UserId], 
	ISNULL(T1.OpportunityId, '') AS [FinancialPlanningSession!1!OpportunityId], 
	ISNULL(T1.DocumentId, '') AS [FinancialPlanningSession!1!DocumentId], 
	T1.ConcurrencyId AS [FinancialPlanningSession!1!ConcurrencyId]
	FROM TFinancialPlanningSession T1
	
	WHERE T1.FinancialPlanningSessionId = @FinancialPlanningSessionId
	ORDER BY [FinancialPlanningSession!1!FinancialPlanningSessionId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
