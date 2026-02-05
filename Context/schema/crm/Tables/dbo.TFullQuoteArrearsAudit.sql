CREATE TABLE [dbo].[TFullQuoteArrearsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[ArrearsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteArrearsAudit_ConcurrencyId] DEFAULT ((1)),
[FullQuoteArrearsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFullQuoteArrearsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFullQuoteArrearsAudit] ADD CONSTRAINT [PK_TFullQuoteArrearsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFullQuoteArrearsAudit_FullQuoteArrearsId_ConcurrencyId] ON [dbo].[TFullQuoteArrearsAudit] ([FullQuoteArrearsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
