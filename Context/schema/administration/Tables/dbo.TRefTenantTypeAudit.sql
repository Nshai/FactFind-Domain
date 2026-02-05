CREATE TABLE [dbo].[TRefTenantTypeAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[RefTenantTypeId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefTenantTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
 CONSTRAINT [PK_TRefTenantTypeAudit] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)
) 


