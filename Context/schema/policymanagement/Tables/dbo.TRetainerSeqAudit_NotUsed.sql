CREATE TABLE [dbo].[TRetainerSeqAudit_NotUsed]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TRetainerS_MaxSequence_4__56] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRetainerS_ConcurrencyId_3__56] DEFAULT ((1)),
[RetainerSeqId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRetainerS_StampDateTime_5__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRetainerSeqAudit_NotUsed] ADD CONSTRAINT [PK_TRetainerSeqAudit_6__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRetainerSeqAudit_RetainerSeqId_ConcurrencyId] ON [dbo].[TRetainerSeqAudit_NotUsed] ([RetainerSeqId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
