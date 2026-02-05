CREATE TABLE [dbo].[TPolicyBusinessCacheAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[CachedHTML] [text] COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessCacheAudit_ConcurrencyId] DEFAULT ((1)),
[PolicyBusinessCacheId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBusinessCacheAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessCacheAudit] ADD CONSTRAINT [PK_TPolicyBusinessCacheAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
