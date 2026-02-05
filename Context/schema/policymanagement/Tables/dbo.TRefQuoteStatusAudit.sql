CREATE TABLE [dbo].[TRefQuoteStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteStatusName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefQuoteStatusAudit_ConcurrencyId] DEFAULT ((1)),
[RefQuoteStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefQuoteStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefQuoteStatusAudit] ADD CONSTRAINT [PK_TRefQuoteStatusAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefQuoteStatusAudit_RefQuoteStatusId_ConcurrencyId] ON [dbo].[TRefQuoteStatusAudit] ([RefQuoteStatusId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
