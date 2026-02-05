SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditRecommendationSolutionStatus]
	@StampUser varchar (255),
	@RecommendationSolutionStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TRecommendationSolutionStatusAudit 
( FinancialPlanningSessionId, SolutionGroup, RefRecommendationSolutionStatusId, ConcurrencyId, 
		StatusChangeDate, TenantId, 
	RecommendationSolutionStatusId,FinancialPlanningScenarioId, RecommendationName, StampAction, StampDateTime, StampUser) 
Select FinancialPlanningSessionId, SolutionGroup, RefRecommendationSolutionStatusId, ConcurrencyId, 
		StatusChangeDate, TenantId, 
	RecommendationSolutionStatusId,FinancialPlanningScenarioId, RecommendationName, @StampAction, GetDate(), @StampUser
FROM TRecommendationSolutionStatus
WHERE RecommendationSolutionStatusId = @RecommendationSolutionStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

commit
GO
