CREATE TABLE [dbo].[TRefLicenseTypeToRefProdProvider]
(
[RefLicenseTypeToRefProdProviderId] [int] NOT NULL IDENTITY(1, 1),
[RefLicenseTypeId] [int] NOT NULL,
[RefProdproviderId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLicenseTypeToRefProdProvider_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefLicenseTypeToRefProdProvider] ADD CONSTRAINT [PK_TRefLicenseTypeToRefProdProvider] PRIMARY KEY CLUSTERED  ([RefLicenseTypeToRefProdProviderId])
GO
ALTER TABLE [dbo].[TRefLicenseTypeToRefProdProvider] ADD CONSTRAINT [FK_TRefLicenseTypeToRefProdProvider_TRefProdProvider_RefProdProviderId] FOREIGN KEY ([RefProdproviderId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO
CREATE NONCLUSTERED INDEX IX_TRefLicenseTypeToRefProdProvider_RefLicenseTypeId_RefProdproviderId ON [dbo].[TRefLicenseTypeToRefProdProvider] ([RefLicenseTypeId],[RefProdproviderId]) with (sort_in_tempdb = on)
GO