CREATE TABLE [dbo].[TFundToFundSuperSectorAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FundId] [int] NOT NULL,
[FundSuperSectorId] [int] NOT NULL,
[IsFromFeed] [bit] NOT NULL,
[IsEquity] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FundToFundSuperSectorId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF__TFundToFu__Stamp__7279C34C] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFundToFundSuperSectorAudit] ADD CONSTRAINT [PK_TFundToFundSuperSectorAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TFundToFundSuperSectorAudit_FundToFundSuperSectorId_ConcurrencyId] ON [dbo].[TFundToFundSuperSectorAudit] ([FundToFundSuperSectorId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
