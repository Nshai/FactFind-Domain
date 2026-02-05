CREATE TABLE [dbo].[TRefProdProviderAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NULL,
[FundProviderId] [int] NULL,
[NewProdProviderId] [int] NULL,
[RetireFg] [tinyint] NOT NULL CONSTRAINT [DF_TRefProdProviderAudit_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefProdProviderAudit_ConcurrencyId] DEFAULT ((1)),
[IsTransactionFeedSupported] [bit] NULL,
[RefProdProviderId] [int] NOT NULL,
[IsConsumerFriendly] [bit] NULL,
[RegionCode] [varchar] (2) NULL,
[IsBankAccountTransactionFeed] [bit] NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefProdProviderAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[DTCCIdentifier] [varchar] (20) NULL
)
GO
ALTER TABLE [dbo].[TRefProdProviderAudit] ADD CONSTRAINT [PK_TRefProdProviderAudit_AuditId] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefProdProviderAudit_RefProdProviderId_ConcurrencyId] ON [dbo].[TRefProdProviderAudit] ([RefProdProviderId], [ConcurrencyId])
GO
