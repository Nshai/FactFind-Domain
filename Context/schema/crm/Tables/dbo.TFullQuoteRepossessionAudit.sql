CREATE TABLE [dbo].[TFullQuoteRepossessionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[RepossessionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteRepossessionAudit_ConcurrencyId] DEFAULT ((1)),
[FullQuoteRepossessionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFullQuoteRepossessionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFullQuoteRepossessionAudit] ADD CONSTRAINT [PK_TFullQuoteRepossessionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFullQuoteRepossessionAudit_FullQuoteRepossessionId_ConcurrencyId] ON [dbo].[TFullQuoteRepossessionAudit] ([FullQuoteRepossessionId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
