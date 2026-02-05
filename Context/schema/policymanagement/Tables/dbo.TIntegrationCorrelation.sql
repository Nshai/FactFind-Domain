CREATE TABLE [dbo].[TIntegrationCorrelation]
(
[IntegrationCorrelationId] [int] NOT NULL IDENTITY(1, 1),
[CorrelationId] [uniqueidentifier] NOT NULL,
[EntityId] [int] NOT NULL,
[EntityType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[PortalId] [int] NOT NULL,
[TenantId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TIntegrationCorrelation] ADD CONSTRAINT [PK_TIntegrationCorrelation] PRIMARY KEY CLUSTERED  ([IntegrationCorrelationId])
GO
