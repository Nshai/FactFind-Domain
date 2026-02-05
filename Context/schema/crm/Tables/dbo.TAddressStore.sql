CREATE TABLE [dbo].[TAddressStore]
(
[AddressStoreId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[AddressLine1] [varchar] (1000) NULL,
[AddressLine2] [varchar] (1000) NULL,
[AddressLine3] [varchar] (1000) NULL,
[AddressLine4] [varchar] (1000) NULL,
[CityTown] [varchar] (255) NULL,
[RefCountyId] [int] NULL,
[Postcode] [varchar] (20) NULL,
[RefCountryId] [int] NULL,
[PostCodeX] [int] NULL,
[PostCodeY] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAddressStore_ConcurrencyId] DEFAULT ((1)),
[PostCodeLatitudeX] [decimal] (18, 8) NULL,
[PostCodeLongitudeY] [decimal] (18, 8) NULL,
MigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TAddressStore] ADD CONSTRAINT [PK_TAddressStore] PRIMARY KEY CLUSTERED  ([AddressStoreId]) 

GO
CREATE NONCLUSTERED INDEX [IDX_TAddressStore_IndClientId_PostCode] ON [dbo].[TAddressStore] ([IndClientId], [Postcode]) 

GO
ALTER TABLE [dbo].[TAddressStore] WITH CHECK ADD CONSTRAINT [FK_TAddressStore_TRefCountry] FOREIGN KEY ([RefCountryId]) REFERENCES [dbo].[TRefCountry] ([RefCountryId])
GO
ALTER TABLE [dbo].[TAddressStore] WITH CHECK ADD CONSTRAINT [FK_TAddressStore_TRefCounty] FOREIGN KEY ([RefCountyId]) REFERENCES [dbo].[TRefCounty] ([RefCountyId])
GO