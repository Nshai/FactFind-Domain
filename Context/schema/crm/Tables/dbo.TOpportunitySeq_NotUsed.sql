CREATE TABLE [dbo].[TOpportunitySeq_NotUsed]
(
[OpportunitySeqId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TOpportunitySeq_MaxSequence] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunitySeq_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOpportunitySeq_NotUsed] ADD CONSTRAINT [PK_TOpportunitySeq_OpportunitySeqId] PRIMARY KEY NONCLUSTERED  ([OpportunitySeqId]) WITH (FILLFACTOR=80)
GO
