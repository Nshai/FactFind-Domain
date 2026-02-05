CREATE TABLE [dbo].[TQuoteMortgageSeqAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientCode] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[MaxSequence] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[QuoteMortgageSeqId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteMortgageSeqAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuoteMortgageSeqAudit] ADD CONSTRAINT [PK_TQuoteMortgageSeqAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TQuoteMortgageSeqAudit_QuoteMortgageSeqId_ConcurrencyId] ON [dbo].[TQuoteMortgageSeqAudit] ([QuoteMortgageSeqId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
