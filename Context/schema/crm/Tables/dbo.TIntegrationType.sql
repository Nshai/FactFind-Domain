CREATE TABLE [dbo].[TIntegrationType]
(
[IntegrationTypeId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntegrationType_ConcurrencyId] DEFAULT ((1)),
[TenantId] [int] NOT NULL,
[IntegrationTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsEnabled] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TIntegrationType] ADD CONSTRAINT [PK_TIntegrationType] PRIMARY KEY CLUSTERED  ([IntegrationTypeId])
GO
