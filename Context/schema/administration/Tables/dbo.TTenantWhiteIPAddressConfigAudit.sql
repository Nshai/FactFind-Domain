CREATE TABLE [dbo].[TTenantWhiteIPAddressConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[IPAddressRangeStart] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[IPAddressRangeEnd] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchievd] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[TenantWhiteIPAddressConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTenantWhiteIPAddressConfigAudit] ADD CONSTRAINT [PK_TTenantWhiteIPAddressConfigAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
