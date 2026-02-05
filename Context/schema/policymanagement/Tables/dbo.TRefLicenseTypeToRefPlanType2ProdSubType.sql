CREATE TABLE [dbo].[TRefLicenseTypeToRefPlanType2ProdSubType]
(
[RefLicenseTypeToRefPlanType2ProdSubTypeId] [int] NOT NULL IDENTITY(1, 1),
[RefLicenseTypeId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLicenseTypeToRefPlanType2ProdSubType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefLicenseTypeToRefPlanType2ProdSubType] ADD CONSTRAINT [PK_TRefLicenseTypeToRefPlanType2ProdSubType] PRIMARY KEY CLUSTERED  ([RefLicenseTypeToRefPlanType2ProdSubTypeId])
GO
ALTER TABLE [dbo].[TRefLicenseTypeToRefPlanType2ProdSubType] ADD CONSTRAINT [FK_TRefLicenseTypeToRefPlanType2ProdSubType_TRefPlanType2ProdSubType_RefPlanType2ProdSubTypeId] FOREIGN KEY ([RefPlanType2ProdSubTypeId]) REFERENCES [dbo].[TRefPlanType2ProdSubType] ([RefPlanType2ProdSubTypeId])
GO
