CREATE TABLE [dbo].[TActivityCategory2LifeCycleStepAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleStepId] [int] NOT NULL,
[ActivityCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2LifeCycleStepAudit_ConcurrencyId] DEFAULT ((1)),
[ActivityCategory2LifeCycleStepId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityCategory2LifeCycleStepAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TActivityCategory2LifeCycleStepAudit] ADD CONSTRAINT [PK_TActivityCategory2LifeCycleStepAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TActivityCategory2LifeCycleStepAudit_ActivityCategory2LifeCycleStepId_ConcurrencyId] ON [dbo].[TActivityCategory2LifeCycleStepAudit] ([ActivityCategory2LifeCycleStepId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
