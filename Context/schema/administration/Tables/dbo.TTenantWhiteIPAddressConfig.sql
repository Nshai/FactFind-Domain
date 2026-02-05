CREATE TABLE [dbo].[TTenantWhiteIPAddressConfig]
(
[TenantWhiteIPAddressConfigId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[IPAddressRangeStart] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[IPAddressRangeEnd] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchievd] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTenantWhiteIPAddressConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTenantWhiteIPAddressConfig] ADD CONSTRAINT [PK_TTenantWhiteIPAddressConfig] PRIMARY KEY CLUSTERED  ([TenantWhiteIPAddressConfigId])
GO
