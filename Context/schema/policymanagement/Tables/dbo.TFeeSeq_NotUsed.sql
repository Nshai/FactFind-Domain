CREATE TABLE [dbo].[TFeeSeq_NotUsed]
(
[FeeSeqId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TFeeSeq_MaxSequence_2__56] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeSeq_ConcurrencyId_1__56] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeSeq_NotUsed] ADD CONSTRAINT [PK_TFeeSeq_3__56] PRIMARY KEY NONCLUSTERED  ([FeeSeqId]) WITH (FILLFACTOR=80)
GO
