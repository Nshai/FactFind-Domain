CREATE TABLE [dbo].[TRefCurrencyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CurrencyCode] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Symbol] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCurrencyAudit_ConcurrencyId] DEFAULT ((1)),
[RefCurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefCurrencyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCurrencyAudit] ADD CONSTRAINT [PK_TRefCurrencyAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefCurrencyAudit_RefCurrencyId_ConcurrencyId] ON [dbo].[TRefCurrencyAudit] ([RefCurrencyId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
