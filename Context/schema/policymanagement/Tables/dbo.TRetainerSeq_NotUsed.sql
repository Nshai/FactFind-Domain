CREATE TABLE [dbo].[TRetainerSeq_NotUsed]
(
[RetainerSeqId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TRetainerS_MaxSequence_2__56] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRetainerS_ConcurrencyId_1__56] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRetainerSeq_NotUsed] ADD CONSTRAINT [PK_TRetainerSeq_3__56] PRIMARY KEY NONCLUSTERED  ([RetainerSeqId]) WITH (FILLFACTOR=80)
GO
