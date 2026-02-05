CREATE TABLE [dbo].[TRefAddressType]
(
[RefAddressTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AddressTypeName] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAddressType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefAddressType] ADD CONSTRAINT [PK_TRefAddressType] PRIMARY KEY CLUSTERED  ([RefAddressTypeId])
GO
