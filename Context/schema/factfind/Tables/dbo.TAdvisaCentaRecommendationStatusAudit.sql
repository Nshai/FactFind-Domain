CREATE TABLE [dbo].[TAdvisaCentaRecommendationStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdvisaCentaRecommendationStatusId] [int] NULL,
[ActionPlanId] [int] NULL,
[ActionPlanContributionId] [int] NULL,
[ActionPlanWithdrawalId] [int] NULL,
[RefRecommendationStatusId] [int] NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdvisaCentaRecommendationStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefDeferredReasonId] [int] NULL,
[RefRejectedReasonId] [int] NULL,
[RejectReasonNote]	[ntext]	NULL,
[DeferReasonNote]	[ntext]	NULL,  
[StatusDate] [datetime] NULL,
[AdviserId] [int] NULL,
[ActionFundId] [int] NULL,
[TenantId] [int] NULL,
[RefTransactionTypeId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAdvisaCentaRecommendationStatusAudit] ADD CONSTRAINT [PK_TAdvisaCentaRecommendationStatusAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
