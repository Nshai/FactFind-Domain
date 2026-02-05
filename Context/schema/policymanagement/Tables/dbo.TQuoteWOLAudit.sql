CREATE TABLE [dbo].[TQuoteWOLAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteItemId] [int] NOT NULL,
[CoverBasis] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CoverRequested] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[QuotationBasis] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SumAssured] [decimal] (10, 2) NULL,
[Premium] [decimal] (10, 2) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteWOLAudit_ConcurrencyId] DEFAULT ((1)),
[QuoteWOLId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteWOLAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuoteWOLAudit] ADD CONSTRAINT [PK_TQuoteWOLAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQuoteWOLAudit_QuoteWOLId_ConcurrencyId] ON [dbo].[TQuoteWOLAudit] ([QuoteWOLId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
