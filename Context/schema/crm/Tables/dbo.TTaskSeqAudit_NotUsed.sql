CREATE TABLE [dbo].[TTaskSeqAudit_NotUsed]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTaskSeqAudit_ConcurrencyId] DEFAULT ((0)),
[TaskSeqId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTaskSeqAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTaskSeqAudit_NotUsed] ADD CONSTRAINT [PK_TTaskSeqAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTaskSeqAudit_TaskSeqId_ConcurrencyId] ON [dbo].[TTaskSeqAudit_NotUsed] ([TaskSeqId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
