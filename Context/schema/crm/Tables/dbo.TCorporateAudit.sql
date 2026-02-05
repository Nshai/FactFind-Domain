CREATE TABLE [dbo].[TCorporateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NULL,
[CorporateName] [varchar] (250) NULL,
[ArchiveFG] [tinyint] NULL,
[BusinessType] [varchar] (2500) NULL,
[RefCorporateTypeId] [int] NULL,
[CompanyRegNo] [varchar] (50) NULL,
[EstIncorpDate] [datetime] NULL,
[YearEnd] [datetime] NULL,
[VatRegFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[VatRegNo] [varchar] (50) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCorporateAudit_ConcurrencyId] DEFAULT ((1)),
[CorporateId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCorporateAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
MigrationRef varchar(255),
[LEI] [NVARCHAR](20) NULL,
[LEIExpiryDate] [DATE] NULL,
[BusinessRegistrationNumber] [varchar](50) NULL,
[NINumber] [varchar](50) NULL
)
GO
ALTER TABLE [dbo].[TCorporateAudit] ADD CONSTRAINT [PK_TCorporateAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TCorporateAudit_CorporateId_ConcurrencyId] ON [dbo].[TCorporateAudit] ([CorporateId], [ConcurrencyId])
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporateAudit_StampDateTime_CorporateId] ON [dbo].[TCorporateAudit] ([StampDateTime], [CorporateId])
GO
