CREATE TABLE [dbo].[TTaskConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AllowAutoAllocation] [bit] NOT NULL CONSTRAINT [DF_TTaskConfigAudit_AllowAutoAllocation] DEFAULT ((0)),
[MaxTasksPerUser] [int] NOT NULL CONSTRAINT [DF_TTaskConfigAudit_MaxTasksPerUser] DEFAULT ((0)),
[AssignedToDefault] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TTaskConfigAudit_AssignedToDefault] DEFAULT ('User'),
[LockDefault] [bit] NOT NULL CONSTRAINT [DF_TTaskConfigAudit_LockDefault] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTaskConfigAudit_ConcurrencyId] DEFAULT ((1)),
[TaskConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTaskConfigAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ShowinDiaryDefault] [bit] NULL
)
GO
ALTER TABLE [dbo].[TTaskConfigAudit] ADD CONSTRAINT [PK_TTaskConfigAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTaskConfigAudit_TaskConfigId_ConcurrencyId] ON [dbo].[TTaskConfigAudit] ([TaskConfigId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
