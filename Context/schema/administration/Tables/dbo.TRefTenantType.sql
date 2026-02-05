

CREATE TABLE [dbo].[TRefTenantType](
	[RefTenantTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_TRefTenantType] PRIMARY KEY CLUSTERED 
(
	[RefTenantTypeId] ASC
)
) 

CREATE UNIQUE NONCLUSTERED INDEX [IUX_TRefTenantType_Name] ON [dbo].[TRefTenantType]
(
	[Name] ASC
) 

