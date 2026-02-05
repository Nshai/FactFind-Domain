CREATE TABLE [dbo].[TRefLicenseTypeToRefProdProviderAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefLicenseTypeId] [int] NOT NULL,
[RefProdproviderId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLicenseTypeToRefProdProviderAudit_ConcurrencyId] DEFAULT ((1)),
[RefLicenseTypeToRefProdProviderId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefLicenseTypeToRefProdProviderAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefLicenseTypeToRefProdProviderAudit] ADD CONSTRAINT [PK_TRefLicenseTypeToRefProdProviderAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
