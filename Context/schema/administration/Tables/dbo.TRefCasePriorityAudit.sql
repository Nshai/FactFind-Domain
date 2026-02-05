CREATE TABLE [dbo].[TRefCasePriorityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CasePriorityName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsDefectPriority] [bit] NOT NULL CONSTRAINT [DF_TRefCasePriorityAudit_IsDefectPriority] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCasePriorityAudit_ConcurrencyId] DEFAULT ((1)),
[RefCasePriorityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefCasePriorityAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCasePriorityAudit] ADD CONSTRAINT [PK_TRefCasePriorityAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
