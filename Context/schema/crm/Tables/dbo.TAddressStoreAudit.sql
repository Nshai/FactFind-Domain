CREATE TABLE [dbo].[TAddressStoreAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndClientId] [int] NOT NULL,
[AddressLine1] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine2] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine3] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine4] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[CityTown] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefCountyId] [int] NULL,
[Postcode] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Extensible] [dbo].[extensible] NULL,
[PostCodeX] [int] NULL,
[PostCodeY] [int] NULL,
[RefCountryId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[AddressStoreId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PostCodeLatitudeX] [decimal] (18, 8) NULL,
[PostCodeLongitudeY] [decimal] (18, 8) NULL,
MigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TAddressStoreAudit] ADD CONSTRAINT [PK_TAddressStoreAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE CLUSTERED INDEX [CLX_TAddressStoreAudit_AddressStoreId] ON [dbo].[TAddressStoreAudit] ([AddressStoreId])
GO
CREATE NONCLUSTERED INDEX [IX_TAddressStoreAudit_StampDateTime] ON [dbo].[TAddressStoreAudit] ([StampDateTime])
GO
