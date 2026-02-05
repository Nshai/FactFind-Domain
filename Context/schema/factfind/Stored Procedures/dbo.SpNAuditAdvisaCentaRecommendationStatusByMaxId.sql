SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditAdvisaCentaRecommendationStatusByMaxId]
	@StampUser varchar (255),
	@MaxId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdvisaCentaRecommendationStatusAudit 
( ActionPlanId, ActionPlanContributionId, ActionPlanWithdrawalId, RefRecommendationStatusId, 
		ConcurrencyId, RefDeferredReasonId, StatusDate, AdviserId, DeferReasonNote,		
	AdvisaCentaRecommendationStatusId, StampAction, StampDateTime, StampUser, RefRejectedReasonId, RejectReasonNote) 
Select ActionPlanId, ActionPlanContributionId, ActionPlanWithdrawalId, RefRecommendationStatusId, 
		ConcurrencyId, RefDeferredReasonId, StatusDate, AdviserId, DeferReasonNote,
		
	AdvisaCentaRecommendationStatusId, @StampAction, GetDate(), @StampUser, RefRejectedReasonId , RejectReasonNote
FROM TAdvisaCentaRecommendationStatus
WHERE AdvisaCentaRecommendationStatusId > @MaxId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
