CREATE TABLE [dbo].[TActivityCategory2ActivityOutcomeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ActivityCategoryId] [int] NOT NULL,
[ActivityOutcomeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2ActivityOutcomeAudit_ConcurrencyId] DEFAULT ((1)),
[ActivityCategory2ActivityOutcomeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityCategory2ActivityOutcomeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TActivityCategory2ActivityOutcomeAudit] ADD CONSTRAINT [PK_TActivityCategory2ActivityOutcomeAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
