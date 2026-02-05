CREATE TABLE [dbo].[TMenuNodeRestrictedByAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefMenuNodeRestrictedById] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ProcessingOrder] [int] NOT NULL CONSTRAINT [DF_TMenuNodeRestrictedByAudit_ProcessingOrder] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMenuNodeRestrictedByAudit_ConcurrencyId] DEFAULT ((1)),
[MenuNodeRestrictedById] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMenuNodeRestrictedByAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedByAudit] ADD CONSTRAINT [PK_TMenuNodeRestrictedByAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMenuNodeRestrictedByAudit_MenuNodeRestrictedById_ConcurrencyId] ON [dbo].[TMenuNodeRestrictedByAudit] ([MenuNodeRestrictedById], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
