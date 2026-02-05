CREATE TABLE [dbo].[TAddress]
(
[AddressId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NULL,
[AddressStoreId] [int] NULL,
[RefAddressTypeId] [int] NOT NULL CONSTRAINT [DF_TAddress_RefAddressTypeId] DEFAULT ((0)),
[AddressTypeName] [varchar] (50) NULL,
[DefaultFg] [tinyint] NOT NULL,
[RefAddressStatusId] [tinyint] NULL,
[ResidentFromDate] [datetime] NULL,
[ResidentToDate] [datetime] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAddress_ConcurrencyId] DEFAULT ((1)),
[IsRegisteredOnElectoralRoll] [bit] NULL,
[MigrationRef] [varchar] (255) NULL,
[ResidencyStatus] [int] NULL,
[CreatedOn] [datetime] NULL CONSTRAINT [DF_TAddress_CreatedOn] DEFAULT (getdate()),
[CreatedByUserId] [int] NULL,
[UpdatedOn] [datetime] NULL CONSTRAINT [DF_TAddress_UpdatedOn] DEFAULT (getdate()),
[UpdatedByUserId] [int] NULL,
[TenureType] [varchar] (255) NULL,
[PropertyStatus] [varchar] (255) NULL,
[IsPotentialMortgage] [bit] NULL,
)
GO
ALTER TABLE [dbo].[TAddress] ADD CONSTRAINT [PK_TAddress] PRIMARY KEY CLUSTERED  ([AddressId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAddress_AddressStoreId] ON [dbo].[TAddress] ([AddressStoreId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAddress_CRMContactId] ON [dbo].[TAddress] ([CRMContactId]) include (AddressStoreId,IndCLientId,DefaultFG)
GO
CREATE NONCLUSTERED INDEX [IDX_TAddress_IndClientId] ON [dbo].[TAddress] ([IndClientId]) INCLUDE ([AddressStoreId], [CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAddress_IndClientId2] ON [dbo].[TAddress] ([IndClientId]) INCLUDE ([AddressId],[CRMContactId],[AddressStoreId],[DefaultFg])
GO
ALTER TABLE [dbo].[TAddress] WITH CHECK ADD CONSTRAINT [FK_TAddress_TRefAddressStatus] FOREIGN KEY ([RefAddressStatusId]) REFERENCES [dbo].[TRefAddressStatus] ([RefAddressStatusId])
GO
create index IX_Taddress_MigrationRef_IndClientId on TAddress(MigrationRef,IndClientId) 
go 
CREATE NONCLUSTERED INDEX IX_TAddress_DefaultFG ON [dbo].[TAddress] ([DefaultFg]) INCLUDE ([CRMContactId],[AddressStoreId]) 
go
CREATE NONCLUSTERED INDEX IX_TAddress_CRMContactId ON [dbo].[TAddress] ([CRMContactId]) INCLUDE ([AddressId],[AddressStoreId],[RefAddressTypeId],[AddressTypeName],[DefaultFg])
go