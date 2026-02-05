CREATE TABLE [dbo].[TAdvisaCentaRecommendationStatus]
(
[AdvisaCentaRecommendationStatusId] [int] NOT NULL IDENTITY(1, 1),
[ActionPlanId] [int] NULL,
[ActionPlanContributionId] [int] NULL,
[ActionPlanWithdrawalId] [int] NULL,
[RefRecommendationStatusId] [int] NULL,
[ConcurrencyId] [int] NULL,
[RefDeferredReasonId] [int] NULL,
[StatusDate] [datetime] NULL,
[AdviserId] [int] NULL,
[RefRejectedReasonId] [int] NULL,
[RejectReasonNote]	[ntext]	NULL, 
[DeferReasonNote]	[ntext]	NULL, 
[ActionFundId] [int] NULL,
[TenantId] [int] NULL,
[RefTransactionTypeId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAdvisaCentaRecommendationStatus] ADD CONSTRAINT [PK_TAdvisaCentaRecommendationStatus] PRIMARY KEY CLUSTERED  ([AdvisaCentaRecommendationStatusId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdvisaCentaRecommendationStatus_TenantId] 
ON [dbo].[TAdvisaCentaRecommendationStatus] ([TenantId]) 
INCLUDE ([ActionPlanId], [RefRecommendationStatusId], [StatusDate], [RefTransactionTypeId])
WITH (FILLFACTOR=90)
GO