CREATE TABLE [dbo].[TTenant2RefTenantGroup](
	[Tenant2RefTenantGroup] [int] IDENTITY(1,1) NOT NULL,
	[RefTenantGroupId] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[TenantGuid] [uniqueidentifier] NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_TTenant2RefTenantGroup] PRIMARY KEY CLUSTERED 
(
	[Tenant2RefTenantGroup] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TTenant2RefTenantGroup] ADD  CONSTRAINT [DF_TTenant2RefTenantGroup_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO


