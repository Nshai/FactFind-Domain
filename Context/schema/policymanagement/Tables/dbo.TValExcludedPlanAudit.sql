CREATE TABLE [dbo].[TValExcludedPlanAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[ExcludedByUserId] [int] NULL,
[ExcludedDate] [datetime] NOT NULL CONSTRAINT [DF_TValExcludedPlanAudit_ExcludedDate] DEFAULT (getdate()),
[EmailAlertSent] [bit] NOT NULL CONSTRAINT [DF_TValExcludedPlanAudit_EmailAlertSent] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValExcludedPlanAudit_ConcurrencyId] DEFAULT ((1)),
[ValExcludedPlanId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValExcludedPlanAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValExcludedPlanAudit] ADD CONSTRAINT [PK_TValExcludedPlanAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TValExcludedPlanAudit_ValExcludedPlanId_ConcurrencyId] ON [dbo].[TValExcludedPlanAudit] ([ValExcludedPlanId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
