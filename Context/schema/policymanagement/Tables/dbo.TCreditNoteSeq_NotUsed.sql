CREATE TABLE [dbo].[TCreditNoteSeq_NotUsed]
(
[CreditNoteSeqId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TCreditNot_MaxSequence_2__58] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCreditNot_ConcurrencyId_1__58] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCreditNoteSeq_NotUsed] ADD CONSTRAINT [PK_TCreditNoteSeq_3__58] PRIMARY KEY NONCLUSTERED  ([CreditNoteSeqId]) WITH (FILLFACTOR=80)
GO
