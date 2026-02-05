CREATE TABLE [dbo].[TAdviceCaseSeq_NotUsed]
(
[AdviceCaseSeqId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TAdviceCase_MaxSequence_6__56] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCase_ConcurrencyId_5__56] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviceCaseSeq_NotUsed] ADD CONSTRAINT [PK_TAdviceCaseSeq_7__56] PRIMARY KEY NONCLUSTERED  ([AdviceCaseSeqId]) WITH (FILLFACTOR=80)
GO
