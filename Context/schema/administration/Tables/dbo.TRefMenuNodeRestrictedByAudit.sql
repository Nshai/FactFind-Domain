CREATE TABLE [dbo].[TRefMenuNodeRestrictedByAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefMenuNodeRestrictedByAudit_ConcurrencyId] DEFAULT ((1)),
[RefMenuNodeRestrictedById] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefMenuNodeRestrictedByAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefMenuNodeRestrictedByAudit] ADD CONSTRAINT [PK_TRefMenuNodeRestrictedByAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefMenuNodeRestrictedByAudit_RefMenuNodeRestrictedById_ConcurrencyId] ON [dbo].[TRefMenuNodeRestrictedByAudit] ([RefMenuNodeRestrictedById], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
