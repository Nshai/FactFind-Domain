CREATE TABLE [dbo].[TFullQuoteLiabilitiesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[LiabilitiesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteLiabilitiesAudit_ConcurrencyId] DEFAULT ((1)),
[FullQuoteLiabilitiesId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFullQuoteLiabilitiesAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFullQuoteLiabilitiesAudit] ADD CONSTRAINT [PK_TFullQuoteLiabilitiesAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFullQuoteLiabilitiesAudit_FullQuoteLiabilitiesId_ConcurrencyId] ON [dbo].[TFullQuoteLiabilitiesAudit] ([FullQuoteLiabilitiesId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
