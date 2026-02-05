CREATE TABLE [dbo].[TTenantWhiteIPAddressSettings]
(
[TenantWhiteIpAddressSettingsId] [int] NOT NULL IDENTITY(1, 1),

[TenantId] [int] NOT NULL,

[ExpireAccessOn] [datetime] NULL,

[ExpireSettingName] varchar(50) NOT NULL
)
GO
ALTER TABLE [dbo].[TTenantWhiteIPAddressSettings] ADD CONSTRAINT [PK_TTenantWhiteIPAddressSettings] PRIMARY KEY CLUSTERED  ([TenantWhiteIPAddressSettingsId])
GO
