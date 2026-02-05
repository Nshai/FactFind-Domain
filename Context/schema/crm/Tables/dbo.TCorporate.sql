CREATE TABLE [dbo].[TCorporate]
(
[CorporateId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NULL,
[CorporateName] [varchar] (250) NULL,
[ArchiveFg] [tinyint] NULL,
[BusinessType] [varchar] (2500) NULL,
[RefCorporateTypeId] [int] NULL,
[CompanyRegNo] [varchar] (50) NULL,
[EstIncorpDate] [datetime] NULL,
[YearEnd] [datetime] NULL,
[VatRegFg] [tinyint] NULL,
[VatRegNo] [varchar] (50) NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCorporate_ConcurrencyId] DEFAULT ((1)),
MigrationRef varchar(255),
[CreatedOn] [datetime] NULL CONSTRAINT [DF_TCorporate_CreatedOn] DEFAULT (getdate()),
[CreatedByUserId] [int] NULL,
[UpdatedOn] [datetime] NULL CONSTRAINT [DF_TCorporate_UpdatedOn] DEFAULT (getdate()),
[UpdatedByUserId] [int] NULL,
[LEI] [NVARCHAR](20) NULL,
[LEIExpiryDate] [DATE] NULL,
[BusinessRegistrationNumber] [varchar](50) NULL,
[NINumber] [varchar](50) NULL
)
GO
ALTER TABLE [dbo].[TCorporate] ADD CONSTRAINT [PK_TCorporate] PRIMARY KEY CLUSTERED  ([CorporateId])
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporate_RefCorporateTypeId] ON [dbo].[TCorporate] ([RefCorporateTypeId])
GO
ALTER TABLE [dbo].[TCorporate] WITH CHECK ADD CONSTRAINT [FK_TCorporate_RefCorporateTypeId_RefCorporateTypeId] FOREIGN KEY ([RefCorporateTypeId]) REFERENCES [dbo].[TRefCorporateType] ([RefCorporateTypeId])
GO
create index IX_TCorporate_IndClientId_MigrationRef on TCorporate(IndClientId,MigrationRef) 
go 
