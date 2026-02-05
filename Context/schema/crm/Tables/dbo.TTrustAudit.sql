CREATE TABLE [dbo].[TTrustAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefTrustTypeId] [int] NOT NULL,
[IndClientId] [int] NOT NULL,
[TrustName] [varchar] (250) NOT NULL,
[EstDate] [datetime] NULL,
[ArchiveFG] [tinyint] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTrustAudit_ConcurrencyId] DEFAULT ((1)),
[TrustId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTrustAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
MigrationRef varchar(255),
[LEI] [NVARCHAR](20) NULL,
[LEIExpiryDate] [DATE] NULL,
[RegistrationNumber] [varchar](50) NULL,
[RegistrationDate] [DATE] NULL,
[Instrument] [varchar](50) NULL,
[BusinessRegistrationNumber] [varchar](50) NULL,
[NatureOfTrust] [varchar](500) NULL,
[VatRegNo][varchar](50) NULL,
[EstablishmentCountryId] [int] NULL,
[ResidenceCountryId] [int] NULL
)
GO
ALTER TABLE [dbo].[TTrustAudit] ADD CONSTRAINT [PK_TTrustAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IX_TTrustAudit_StampDateTime_TrustId] ON [dbo].[TTrustAudit] ([StampDateTime], [TrustId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TTrustAudit_TrustId_ConcurrencyId] ON [dbo].[TTrustAudit] ([TrustId], [ConcurrencyId])
GO
