CREATE TABLE [dbo].[TRefEvalueLogStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueLogStatusAudit_ConcurrencyId] DEFAULT ((1)),
[RefEvalueLogStatusId] [smallint] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEvalueLogStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefEvalueLogStatusAudit] ADD CONSTRAINT [PK_TEvalueLogStatusAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEvalueLogStatusAudit_EvalueLogStatusId_ConcurrencyId] ON [dbo].[TRefEvalueLogStatusAudit] ([RefEvalueLogStatusId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
