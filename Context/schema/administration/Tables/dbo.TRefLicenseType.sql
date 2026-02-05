CREATE TABLE [dbo].[TRefLicenseType]
(
[RefLicenseTypeId] [int] NOT NULL IDENTITY(1, 1),
[LicenseTypeName] [varchar] (64)  NOT NULL,
[RefLicenseStatusId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLicenseType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefLicenseType] ADD CONSTRAINT [PK_TRefLicenseType] PRIMARY KEY CLUSTERED  ([RefLicenseTypeId])
GO
ALTER TABLE [dbo].[TRefLicenseType] WITH CHECK ADD CONSTRAINT [FK_TRefLicenseType_TRefLicenseStatus_RefLicenseStatusId] FOREIGN KEY ([RefLicenseStatusId]) REFERENCES [dbo].[TRefLicenseStatus] ([RefLicenseStatusId])
GO
