CREATE TABLE [dbo].[TQuoteSeqAudit_NotUsed]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TQuoteSeqAudit_MaxSequence] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteSeqAudit_ConcurrencyId] DEFAULT ((1)),
[QuoteSeqId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteSeqAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuoteSeqAudit_NotUsed] ADD CONSTRAINT [PK_TQuoteSeqAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQuoteSeqAudit_QuoteSeqId_ConcurrencyId] ON [dbo].[TQuoteSeqAudit_NotUsed] ([QuoteSeqId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
