CREATE TABLE [dbo].[TFullQuoteIVAAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[IVAId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteIVAAudit_ConcurrencyId] DEFAULT ((1)),
[FullQuoteIVAId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFullQuoteIVAAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFullQuoteIVAAudit] ADD CONSTRAINT [PK_TFullQuoteIVAAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFullQuoteIVAAudit_FullQuoteIVAId_ConcurrencyId] ON [dbo].[TFullQuoteIVAAudit] ([FullQuoteIVAId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
