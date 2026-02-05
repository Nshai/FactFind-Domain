CREATE TABLE [dbo].[TEvalueLogAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[UserPassword] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[DateRan] [datetime] NOT NULL CONSTRAINT [DF_TEvalueLogAudit_DateRan] DEFAULT (getdate()),
[ModellingStatus] [int] NOT NULL CONSTRAINT [DF_TEvalueLogAudit_ModellingStatus] DEFAULT ((0)),
[RefEvalueLogStatusId] [smallint] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueLogAudit_ConcurrencyId] DEFAULT ((1)),
[EvalueLogId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEvalueLogAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvalueLogAudit] ADD CONSTRAINT [PK_TEvalueLogAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEvalueLogAudit_EvalueLogId_ConcurrencyId] ON [dbo].[TEvalueLogAudit] ([EvalueLogId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
