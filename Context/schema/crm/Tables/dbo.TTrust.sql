CREATE TABLE [dbo].[TTrust]
(
[TrustId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefTrustTypeId] [int] NOT NULL,
[IndClientId] [int] NOT NULL,
[TrustName] [varchar] (250) NOT NULL,
[EstDate] [datetime] NULL,
[ArchiveFG] [tinyint] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTrust_ConcurrencyId] DEFAULT ((1)),
MigrationRef varchar(255),
[CreatedOn] [datetime] NULL CONSTRAINT [DF_TTrust_CreatedOn] DEFAULT (getdate()),
[CreatedByUserId] [int] NULL,
[UpdatedOn] [datetime] NULL CONSTRAINT [DF_TTrust_UpdatedOn] DEFAULT (getdate()),
[UpdatedByUserId] [int] NULL,
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
ALTER TABLE [dbo].[TTrust] ADD CONSTRAINT [PK_TTrust] PRIMARY KEY CLUSTERED  ([TrustId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTrust_RefTrustTypeId] ON [dbo].[TTrust] ([RefTrustTypeId])
GO
ALTER TABLE [dbo].[TTrust] ADD CONSTRAINT [FK_TTrust_RefTrustTypeId_RefTrustTypeId] FOREIGN KEY ([RefTrustTypeId]) REFERENCES [dbo].[TRefTrustType] ([RefTrustTypeId])
GO
create index IX_TTrust_IndClientId_MigrationRef on TTrust(IndClientId,MigrationRef) 
go 
