CREATE TABLE [dbo].[TRefDataAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefDataId] [int] NOT NULL,
[Name] [nvarchar] (255) NOT NULL,
[Type] [varchar] (50) NOT NULL,
[Property] [varchar] (50) NOT NULL,
[RegionCode] [varchar] (2) NULL,
[Attributes] [nvarchar] (MAX) NULL,
[TenantId] [int] NULL,
[Archived] [bit] NOT NULL CONSTRAINT [DF_TRefDataAudit_Archived] DEFAULT ((0)),
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefDataAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
      
GO
ALTER TABLE [dbo].[TRefDataAudit] ADD CONSTRAINT [PK_TRefDataAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
    
GO
