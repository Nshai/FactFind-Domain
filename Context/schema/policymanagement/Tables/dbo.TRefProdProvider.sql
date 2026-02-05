CREATE TABLE [dbo].[TRefProdProvider]
(
[RefProdProviderId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NULL,
[FundProviderId] [int] NULL,
[NewProdProviderId] [int] NULL,
[RetireFg] [tinyint] NOT NULL CONSTRAINT [DF_TRefProdProvider_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefProdPr_ConcurrencyId] DEFAULT ((1)),
[IsTransactionFeedSupported] [bit] NOT NULL  CONSTRAINT [DF_TRefProdProvider_IsTransactionFeedSupported] DEFAULT ((0)),
[IsConsumerFriendly] [bit] NULL CONSTRAINT [DF_TRefProdProvder_IsConsumerFriendly] DEFAULT ((0)),
[RegionCode] [varchar] (2) NOT NULL CONSTRAINT [DF_TRefProdProvider_RegionCode] DEFAULT (('GB')),
[IsBankAccountTransactionFeed] [bit] NOT NULL CONSTRAINT [DF_TRefProdProvider_IsBankAccountTransactionFeed] DEFAULT((0)),
[DTCCIdentifier] [varchar] (20) NULL,
[LogoHref] [varchar] (250) NULL
)
GO
ALTER TABLE [dbo].[TRefProdProvider] ADD CONSTRAINT [PK_TRefProdProvider_RefProdProviderId] PRIMARY KEY CLUSTERED  ([RefProdProviderId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefProdProvider_CRMContactId] ON [dbo].[TRefProdProvider] ([CRMContactId], [RefProdProviderId])
GO
CREATE NONCLUSTERED INDEX [IX_TRefProdProvider_RefProdProviderId_CRMContactId_RetireFg] ON [dbo].[TRefProdProvider] ([RefProdProviderId], [CRMContactId], [RetireFg])
GO
