CREATE TABLE [dbo].[TCreditNoteSeqAudit_NotUsed]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL CONSTRAINT [DF_TCreditNot_MaxSequence_3__56] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCreditNot_ConcurrencyId_2__56] DEFAULT ((1)),
[CreditNoteSeqId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCreditNot_StampDateTime_4__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCreditNoteSeqAudit_NotUsed] ADD CONSTRAINT [PK_TCreditNoteSeqAudit_5__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TCreditNoteSeqAudit_CreditNoteSeqId_ConcurrencyId] ON [dbo].[TCreditNoteSeqAudit_NotUsed] ([CreditNoteSeqId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
