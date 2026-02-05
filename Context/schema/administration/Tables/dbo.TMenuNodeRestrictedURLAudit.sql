CREATE TABLE [dbo].[TMenuNodeRestrictedURLAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefMenuNodeRestrictedURLTypeId] [int] NOT NULL,
[MenuNodeRestrictedURLItemId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMenuNodeRestrictedURLAudit_ConcurrencyId] DEFAULT ((1)),
[MenuNodeRestrictedURLId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMenuNodeRestrictedURLAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedURLAudit] ADD CONSTRAINT [PK_TMenuNodeRestrictedURLAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMenuNodeRestrictedURLAudit_MenuNodeRestrictedURLId_ConcurrencyId] ON [dbo].[TMenuNodeRestrictedURLAudit] ([MenuNodeRestrictedURLId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
