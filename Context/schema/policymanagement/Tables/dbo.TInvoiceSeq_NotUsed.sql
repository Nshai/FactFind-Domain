CREATE TABLE [dbo].[TInvoiceSeq_NotUsed]
(
[InvoiceSeqId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TInvoiceSeq_MaxSequence] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInvoiceSeq_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TInvoiceSeq_NotUsed] ADD CONSTRAINT [PK_TInvoiceSeq] PRIMARY KEY NONCLUSTERED  ([InvoiceSeqId]) WITH (FILLFACTOR=80)
GO
