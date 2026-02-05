CREATE TABLE [dbo].[TAssetsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Owner] [varchar] (512) NULL,
[Description] [varchar] (512) NULL,
[Amount] [money] NULL,
[ValuedOn] [datetime] NULL,
[PriceUpdatedByUser] [varchar] (255) NULL,
[Type] [varchar] (512) NULL,
[PurchasePrice] [money] NULL,
[PurchasedOn] [datetime] NULL,
[loanamount] [bit] NULL,
[investmentprop] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[AssetsId] [int] NOT NULL,
[PolicyBusinessId] [int] NULL,
[AssetCategoryId] [int] NULL,
[percentOwnership] [decimal] (10, 2) NULL,
[RelatedToAddress] [varchar] (1000) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TAssetsAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) NULL,
[IsVisibleToClient] [bit] NULL,
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
[IsHolding] [bit] NULL,
[CurrencyCode] [char] (3) NULL,
[AddressId] [int] NULL,
[CrystallisationStatus] [varchar](20) NULL,
[CrystallisedPercentage] [decimal] (10, 2) NULL,
[UncrystallisedPercentage] [decimal] (10, 2) NULL,
[PensionArrangement] [varchar] (100) NULL
)
GO
ALTER TABLE [dbo].[TAssetsAudit] ADD CONSTRAINT [PK_TAssetsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) 
GO
CREATE NONCLUSTERED INDEX [IDX_TAssetsAudit_AssetsId_ConcurrencyId] ON [dbo].[TAssetsAudit] ([AssetsId], [ConcurrencyId])
GO
