CREATE TABLE [dbo].[TQuoteSeq_NotUsed]
(
[QuoteSeqId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TQuoteSeq_MaxSequence] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteSeq_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuoteSeq_NotUsed] ADD CONSTRAINT [PK_TQuoteSeq] PRIMARY KEY NONCLUSTERED  ([QuoteSeqId]) WITH (FILLFACTOR=80)
GO
