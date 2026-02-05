CREATE TABLE [dbo].[TFullQuoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NOT NULL,
[FactFindId] [int] NOT NULL,
[SourceDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[FullQuoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFullQuoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFullQuoteAudit] ADD CONSTRAINT [PK_TFullQuoteAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFullQuoteAudit_FullQuoteId_ConcurrencyId] ON [dbo].[TFullQuoteAudit] ([FullQuoteId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
