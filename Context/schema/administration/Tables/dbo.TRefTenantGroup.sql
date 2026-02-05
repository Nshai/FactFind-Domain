CREATE TABLE [dbo].[TRefTenantGroup](
	[RefTenantGroupId] [int] IDENTITY(1,1) NOT NULL,
	[TenantGroupName] [varchar](150) NOT NULL,
	[RefTenantGroupGuid] [uniqueidentifier] NOT NULL,
	[ConcurrencyId] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TRefTenantGroup] ADD  CONSTRAINT [DF_TRefTenantGroup_RefTenantGroupGuid]  DEFAULT (newid()) FOR [RefTenantGroupGuid]
GO

ALTER TABLE [dbo].[TRefTenantGroup] ADD  CONSTRAINT [DF_TRefTenantGroup_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO


