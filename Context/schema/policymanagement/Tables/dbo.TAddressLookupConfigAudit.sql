CREATE TABLE [dbo].[TAddressLookupConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Password] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[RefApplicationLinkId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[AddressLookupConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAddressLookupConfigAudit] ADD CONSTRAINT [PK_TAddressLookupConfigAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
