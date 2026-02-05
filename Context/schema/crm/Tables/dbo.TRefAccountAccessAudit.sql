CREATE TABLE [dbo].[TRefAccountAccessAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AccessTypeName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAccountAccessAudit_ConcurrencyId] DEFAULT ((1)),
[RefAccountAccessId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefAccountAccessAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAccountAccessAudit] ADD CONSTRAINT [PK_TRefAccountAccessAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefAccountAccessAudit_RefAccountAccessId_ConcurrencyId] ON [dbo].[TRefAccountAccessAudit] ([RefAccountAccessId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
