CREATE TABLE [dbo].[TAddressLookupConfig]
(
[AddressLookupConfigId] [int] NOT NULL IDENTITY(1, 1),
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Password] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[RefApplicationLinkId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAddressLookupConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAddressLookupConfig] ADD CONSTRAINT [PK_TAddressLookupConfig] PRIMARY KEY CLUSTERED  ([AddressLookupConfigId])
GO
