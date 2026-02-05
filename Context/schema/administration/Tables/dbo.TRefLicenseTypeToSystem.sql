CREATE TABLE [dbo].[TRefLicenseTypeToSystem]
(
[RefLicenseTypeToSystemId] [int] NOT NULL IDENTITY(1, 1),
[RefLicenseTypeId] [int] NOT NULL,
[SystemId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLicenseTypeToSystem_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefLicenseTypeToSystem] ADD CONSTRAINT [PK_TRefLicenseTypeToSystem] PRIMARY KEY NONCLUSTERED  ([RefLicenseTypeToSystemId])
GO
CREATE NONCLUSTERED INDEX [IX_TRefLicenseTypeToSystem_RefLicenseTypeId] ON [dbo].[TRefLicenseTypeToSystem] ([RefLicenseTypeId])
GO
CREATE CLUSTERED INDEX [IDX_TRefLicenseTypeToSystem_SystemId_RefLicenseTypeId] ON [dbo].[TRefLicenseTypeToSystem] ([RefLicenseTypeId], [SystemId])
GO
ALTER TABLE [dbo].[TRefLicenseTypeToSystem] WITH CHECK ADD CONSTRAINT [FK_TRefLicenseTypeToSystem_TRefLicenseType_RefLicenseTypeId] FOREIGN KEY ([RefLicenseTypeId]) REFERENCES [dbo].[TRefLicenseType] ([RefLicenseTypeId])
GO
ALTER TABLE [dbo].[TRefLicenseTypeToSystem] WITH CHECK ADD CONSTRAINT [FK_TRefLicenseTypeToSystem_TSystem_SystemId] FOREIGN KEY ([SystemId]) REFERENCES [dbo].[TSystem] ([SystemId])
GO
