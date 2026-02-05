CREATE TABLE [dbo].[TPolicyBusinessIntegration]
(
[PolicyBusinessIntegrationId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessIntegration_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyBusinessIntegration] ADD CONSTRAINT [PK_TPolicyBusinessIntegration] PRIMARY KEY CLUSTERED  ([PolicyBusinessIntegrationId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessIntegration_PolicyBusinessId_TenantId] ON [dbo].[TPolicyBusinessIntegration] ([PolicyBusinessId], [TenantId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessIntegration_Guid_TenantId] ON [dbo].[TPolicyBusinessIntegration] ([TenantId], [Guid])
GO
ALTER TABLE [dbo].[TPolicyBusinessIntegration] ADD CONSTRAINT [FK_TPolicyBusinessIntegration_TPolicyBusiness] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
