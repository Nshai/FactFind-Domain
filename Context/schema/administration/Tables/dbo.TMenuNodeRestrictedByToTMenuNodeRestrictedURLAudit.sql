CREATE TABLE [dbo].[TMenuNodeRestrictedByToTMenuNodeRestrictedURLAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[MenuNodeRestrictedById] [int] NOT NULL,
[MenuNodeRestrictedURLId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMenuNodeRestrictedByToTMenuNodeRestrictedURLAudit_ConcurrencyId] DEFAULT ((1)),
[MenuNodeRestrictedByToTMenuNodeRestrictedURLId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMenuNodeRestrictedByToTMenuNodeRestrictedURLAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedByToTMenuNodeRestrictedURLAudit] ADD CONSTRAINT [PK_TMenuNodeRestrictedByToTMenuNodeRestrictedURLAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMenuNodeRestrictedByToTMenuNodeRestrictedURLAudit_MenuNodeRestrictedByToTMenuNodeRestrictedURLId_ConcurrencyId] ON [dbo].[TMenuNodeRestrictedByToTMenuNodeRestrictedURLAudit] ([MenuNodeRestrictedByToTMenuNodeRestrictedURLId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
