CREATE TABLE [dbo].[TCreditNoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NULL,
[RetainerId] [int] NULL,
[ProvBreakId] [int] NULL,
[NetAmount] [money] NULL,
[VATAmount] [money] NULL,
[DateRaised] [datetime] NULL,
[SentToClientDate] [datetime] NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SequentialRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TCreditNot_ConcurrencyId_1__56] DEFAULT ((1)),
[CreditNoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCreditNot_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCreditNoteAudit] ADD CONSTRAINT [PK_TCreditNoteAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TCreditNoteAudit_CreditNoteId_ConcurrencyId] ON [dbo].[TCreditNoteAudit] ([CreditNoteId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
