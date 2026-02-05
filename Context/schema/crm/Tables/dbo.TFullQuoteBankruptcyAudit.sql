CREATE TABLE [dbo].[TFullQuoteBankruptcyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[BankruptcyId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteBankruptcyAudit_ConcurrencyId] DEFAULT ((1)),
[FullQuoteBankruptcyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFullQuoteBankruptcyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFullQuoteBankruptcyAudit] ADD CONSTRAINT [PK_TFullQuoteBankruptcyAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFullQuoteBankruptcyAudit_FullQuoteBankruptcyId_ConcurrencyId] ON [dbo].[TFullQuoteBankruptcyAudit] ([FullQuoteBankruptcyId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
