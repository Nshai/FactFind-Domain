CREATE TABLE [dbo].[TActivityCategory2LifeCycleTransitionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleTransitionId] [int] NOT NULL,
[ActivityCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2LifeCycleTransitionAudit_ConcurrencyId] DEFAULT ((1)),
[ActivityCategory2LifeCycleTransitionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityCategory2LifeCycleTransitionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CheckOutcome] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2LifeCycleTransitionAudit_CheckOutcome] DEFAULT ((0)),
[CheckDueDate] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2LifeCycleTransitionAudit_CheckDueDate] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TActivityCategory2LifeCycleTransitionAudit] ADD CONSTRAINT [PK_TActivityCategory2LifeCycleTransitionAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
