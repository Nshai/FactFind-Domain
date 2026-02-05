CREATE TABLE [dbo].[TAssets]
(
[AssetsId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[Owner] [varchar] (512) NULL,
[Description] [varchar] (512)  NULL,
[Amount] [money] NULL,
[ValuedOn] [datetime] NULL,
[PriceUpdatedByUser] [varchar] (255) NULL,
[Type] [varchar] (512) NULL,
[PurchasePrice] [money] NULL,
[PurchasedOn] [datetime] NULL,
[loanamount] [bit] NULL,
[investmentprop] [bit] NULL,
[PolicyBusinessId] [int] NULL,
[AssetCategoryId] [int] NULL,
[percentOwnership] [decimal] (10, 2) NULL,
[RelatedtoAddress] [varchar] (1000) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TAssets__ConcurrencyId] DEFAULT ((1)),
[IsVisibleToClient] [bit] NOT NULL CONSTRAINT [DF__TAssets__IsVisibleToClient] DEFAULT ((1)),
[WhoCreatedUserId] [int] NULL,
[AssetMigrationRef] [varchar] (255) NULL,
[percentOwnershipCrmContact2] [decimal] (10, 2) NULL,
[AddressLine2] [varchar](1000) NULL,
[AddressLine3] [varchar](1000) NULL,
[AddressLine4] [varchar](1000) NULL,
[AddressCityTown] [varchar](255) NULL,
[AddressPostCode] [varchar](20) NULL,
[RefCountyId] [int] NULL,
[RefCountryId] [int] NULL,
[IncomeId] [int] NULL,
[IsHolding] [bit] NOT NULL CONSTRAINT [DF__TAssets__IsHolding] DEFAULT ((0)),
[CurrencyCode] [char] (3) NOT NULL,
[AddressId] [int] NULL,
[CrystallisationStatus] [varchar](20) NULL,
[CrystallisedPercentage] [decimal] (10, 2) NULL,
[UncrystallisedPercentage] [decimal] (10, 2) NULL,
[PensionArrangement] [varchar] (100) NULL
)
GO
ALTER TABLE [dbo].[TAssets] ADD CONSTRAINT [PK_TAssets] PRIMARY KEY NONCLUSTERED  ([AssetsId])
GO
CREATE CLUSTERED INDEX [IX_TAssets_CRMContactId] ON [dbo].[TAssets] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAssets_PolicyBusinessId] ON [dbo].[TAssets] ([PolicyBusinessId]) INCLUDE ([AssetCategoryId], [AssetsId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAssets_AddressId] ON [dbo].[TAssets] ([AddressId])
GO
CREATE INDEX IX_TAssets_CRMContactId2 ON TAssets (CRMContactId2)
GO