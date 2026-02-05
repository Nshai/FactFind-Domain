CREATE TABLE [dbo].[TPolicyBusinessSeqAudit_NotUsed]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TPolicyBus_MaxSequence_7__56] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBus_ConcurrencyId_6__56] DEFAULT ((1)),
[PolicyBusinessSeqId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBus_StampDateTime_8__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessSeqAudit_NotUsed] ADD CONSTRAINT [PK_TPolicyBusinessSeqAudit_9__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyBusinessSeqAudit_PolicyBusinessSeqId_ConcurrencyId] ON [dbo].[TPolicyBusinessSeqAudit_NotUsed] ([PolicyBusinessSeqId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
