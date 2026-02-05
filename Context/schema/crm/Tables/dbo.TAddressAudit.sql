CREATE TABLE [dbo].[TAddressAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NULL,
[AddressStoreId] [int] NULL,
[RefAddressTypeId] [int] NOT NULL,
[AddressTypeName] [varchar] (50)  NULL,
[Extensible] [dbo].[extensible] NULL,
[DefaultFg] [tinyint] NOT NULL,
[RefAddressStatusId] [tinyint] NULL,
[ResidentFromDate] [datetime] NULL,
[ResidentToDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL,
[AddressId] [int] NOT NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255)  NULL,
[IsRegisteredOnElectoralRoll] [bit] NULL,
[MigrationRef] [varchar] (255)  NULL,
[ResidencyStatus] [int] NULL,
[TenureType] [varchar] (255)  NULL,
[PropertyStatus] [varchar] (255)  NULL,
[IsPotentialMortgage] [bit] NULL,
[CreatedOn] [datetime] NULL,
[CreatedByUserId] [int] NULL,
[UpdatedOn] [datetime] NULL,
[UpdatedByUserId] [int] NULL
)
GO
CREATE CLUSTERED INDEX [CLX_TAddressAudit_AddressId] ON [dbo].[TAddressAudit] ([AddressId])
GO
CREATE NONCLUSTERED INDEX [IX_TAddressAudit_StampDateTime] ON [dbo].[TAddressAudit] ([StampDateTime])
GO
CREATE NONCLUSTERED INDEX [IX_TAddressAudit_AddressStoreId] ON [dbo].[TAddressAudit] ([AddressStoreId])
GO
