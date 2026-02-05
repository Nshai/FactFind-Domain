CREATE TABLE [dbo].[TQuoteMortgageSeq]
(
[QuoteMortgageSeqId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TQuoteMortgageSeq_MaxSequence] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteMortgageSeq_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuoteMortgageSeq] ADD CONSTRAINT [PK_TQuoteMortgageSeq] PRIMARY KEY NONCLUSTERED  ([QuoteMortgageSeqId])
GO
