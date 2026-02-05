CREATE TABLE [dbo].[TTenantEmailAssociation]
(
[TenantEmailAssociationId] [int] NOT NULL IDENTITY(1, 1),
[EmailAssociationTypeId] [int] NOT NULL,
[TenantEmailConfigId] [int] NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF_TTenantEmailAssociation_IsActive] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTenantEmailAssociation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTenantEmailAssociation] ADD CONSTRAINT [PK_TTenantEmailAssociation] PRIMARY KEY CLUSTERED  ([TenantEmailAssociationId])
GO
ALTER TABLE [dbo].[TTenantEmailAssociation] ADD CONSTRAINT [FK_TRefAssociationType] FOREIGN KEY ([EmailAssociationTypeId]) REFERENCES [dbo].[TRefEmailAssociationType] ([RefEmailAssociationTypeId])
GO
ALTER TABLE [dbo].[TTenantEmailAssociation] ADD CONSTRAINT [FK_TTenantEmailAssociation_TTenantEmailConfig] FOREIGN KEY ([TenantEmailConfigId]) REFERENCES [dbo].[TTenantEmailConfig] ([TenantEmailConfigId])
GO
