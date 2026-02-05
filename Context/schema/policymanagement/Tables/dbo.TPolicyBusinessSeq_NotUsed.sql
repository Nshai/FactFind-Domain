CREATE TABLE [dbo].[TPolicyBusinessSeq_NotUsed]
(
[PolicyBusinessSeqId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TPolicyBus_MaxSequence_6__56] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBus_ConcurrencyId_5__56] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyBusinessSeq_NotUsed] ADD CONSTRAINT [PK_TPolicyBusinessSeq_7__56] PRIMARY KEY NONCLUSTERED  ([PolicyBusinessSeqId]) WITH (FILLFACTOR=80)
GO
