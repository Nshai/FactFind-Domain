CREATE TABLE [dbo].[TLifeCycleStepAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StatusId] [int] NOT NULL,
[LifeCycleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLifeCycleStepAudit_ConcurrencyId] DEFAULT ((1)),
[LifeCycleStepId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLifeCycleStepAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsSystem] [bit] NULL
)
GO
ALTER TABLE [dbo].[TLifeCycleStepAudit] ADD CONSTRAINT [PK_TLifeCycleStepAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TLifeCycleStepAudit_LifeCycleStepId_ConcurrencyId] ON [dbo].[TLifeCycleStepAudit] ([LifeCycleStepId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
