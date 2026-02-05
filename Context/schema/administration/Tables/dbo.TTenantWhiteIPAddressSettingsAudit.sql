CREATE TABLE [dbo].[TTenantWhiteIPAddressSettingsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[ExpireAccessOn] [datetime] NULL,
[ExpireSettingName] varchar(50) NOT NULL,
[TenantWhiteIpAddressSettingsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTenantWhiteIPAddressSettingsAudit] ADD CONSTRAINT [PK_TTenantWhiteIPAddressSettingsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
