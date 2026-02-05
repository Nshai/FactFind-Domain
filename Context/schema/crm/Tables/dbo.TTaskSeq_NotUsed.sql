CREATE TABLE [dbo].[TTaskSeq_NotUsed]
(
[TaskSeqId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTaskSeq_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TTaskSeq_NotUsed] ADD CONSTRAINT [PK_TTaskSeq] PRIMARY KEY NONCLUSTERED  ([TaskSeqId])
GO
create clustered index IX_TTaskSeq_IndigoClientId on [TTaskSeq_NotUsed] (IndigoClientId) 
go