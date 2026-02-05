CREATE TABLE [dbo].[TRefMenuNodeRestrictedURLTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefMenuNodeRestrictedURLTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefMenuNodeRestrictedURLTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefMenuNodeRestrictedURLTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefMenuNodeRestrictedURLTypeAudit] ADD CONSTRAINT [PK_TRefMenuNodeRestrictedURLTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefMenuNodeRestrictedURLTypeAudit_RefMenuNodeRestrictedURLTypeId_ConcurrencyId] ON [dbo].[TRefMenuNodeRestrictedURLTypeAudit] ([RefMenuNodeRestrictedURLTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
