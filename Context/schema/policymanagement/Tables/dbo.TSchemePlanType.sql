CREATE TABLE [dbo].[TSchemePlanType]
(
[SchemePlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[SchemeTypeId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSchemePlanType_ConcurrencyId] DEFAULT ((1)),
[RefLicenceTypeId] [int] NOT NULL CONSTRAINT [DF__TSchemePl__RefLi__65F7B7BF] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSchemePlanType] ADD CONSTRAINT [PK_TSchemePlanType] PRIMARY KEY NONCLUSTERED  ([SchemePlanTypeId])
GO
ALTER TABLE [dbo].[TSchemePlanType] ADD CONSTRAINT [FK_TSchemePlanType_RefPlanType2ProdSubTypeId_TRefPlanType2ProdSubType] FOREIGN KEY ([RefPlanType2ProdSubTypeId]) REFERENCES [dbo].[TRefPlanType2ProdSubType] ([RefPlanType2ProdSubTypeId])
GO
ALTER TABLE [dbo].[TSchemePlanType] ADD CONSTRAINT [FK_TSchemePlanType_SchemeTypeId_TSchemeType] FOREIGN KEY ([SchemeTypeId]) REFERENCES [dbo].[TSchemeType] ([SchemeTypeId])
GO
