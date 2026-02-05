SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpNAuditAdvisaCentaRecommendationStatus]

	@StampUser varchar (255),

	@AdvisaCentaRecommendationStatusId bigint,

	@StampAction char(1)

AS



INSERT INTO TAdvisaCentaRecommendationStatusAudit 

( ActionPlanId, ActionPlanContributionId, ActionPlanWithdrawalId, RefRecommendationStatusId, 

		ConcurrencyId, RefDeferredReasonId, RejectReasonNote, DeferReasonNote, StatusDate, AdviserId, TenantId, ActionFundId ,

		

	AdvisaCentaRecommendationStatusId, StampAction, StampDateTime, StampUser, RefTransactionTypeId, RefRejectedReasonId) 

Select ActionPlanId, ActionPlanContributionId, ActionPlanWithdrawalId, RefRecommendationStatusId, 

		ConcurrencyId, RefDeferredReasonId, RejectReasonNote, DeferReasonNote, StatusDate, AdviserId, TenantId, ActionFundId,

		

	AdvisaCentaRecommendationStatusId, @StampAction, GetDate(), @StampUser, RefTransactionTypeId, RefRejectedReasonId

FROM TAdvisaCentaRecommendationStatus

WHERE AdvisaCentaRecommendationStatusId = @AdvisaCentaRecommendationStatusId



IF @@ERROR != 0 GOTO errh



RETURN (0)



errh:

RETURN (100)


GO
