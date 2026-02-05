CREATE TABLE [dbo].[TEvalueUserAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[UserXml] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueUserAudit_ConcurrencyId] DEFAULT ((1)),
[EvalueUserId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEvalueUserAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvalueUserAudit] ADD CONSTRAINT [PK_TEvalueUserAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEvalueUserAudit_EvalueUserId_ConcurrencyId] ON [dbo].[TEvalueUserAudit] ([EvalueUserId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
