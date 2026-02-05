CREATE TABLE [dbo].[TClientIntegration]
(
[ClientIntegrationId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientIntegration_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ClientReference] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IntegrationTypeId] [int] NOT NULL,
[IntegrationDate] [datetime] NOT NULL
)
GO
ALTER TABLE [dbo].[TClientIntegration] ADD CONSTRAINT [PK_TClientIntegration] PRIMARY KEY CLUSTERED  ([ClientIntegrationId])
GO
