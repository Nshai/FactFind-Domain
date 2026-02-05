CREATE TABLE [dbo].[TQuoteTermAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteItemId] [int] NOT NULL,
[PremiumAmount] [money] NULL,
[PremiumType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PremiumIsNet] [bit] NOT NULL CONSTRAINT [DF_TQuoteTermAudit_PremiumIsNet] DEFAULT ((0)),
[PremiumFrequency] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CoverAmount] [money] NOT NULL,
[TerminalIllness] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[QuoteTermId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteTermAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuoteTermAudit] ADD CONSTRAINT [PK_TQuoteTermAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQuoteTermAudit_QuoteTermId_ConcurrencyId] ON [dbo].[TQuoteTermAudit] ([QuoteTermId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
