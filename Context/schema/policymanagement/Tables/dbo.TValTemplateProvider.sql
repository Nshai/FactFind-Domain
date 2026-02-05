CREATE TABLE [dbo].[TValTemplateProvider]
(
[ValTemplateProviderId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NULL,
[RefProdProviderId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValTemplateProvider_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValTemplateProvider] ADD CONSTRAINT [PK_TValTemplateProvider] PRIMARY KEY NONCLUSTERED  ([ValTemplateProviderId])
GO
