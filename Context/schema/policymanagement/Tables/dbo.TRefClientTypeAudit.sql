CREATE TABLE [dbo].[TRefClientTypeAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[RefClientTypeId] [int] NOT NULL,
	[Name] [nvarchar] (250) NOT NULL,
	[ClientTypeGroup] [nvarchar] (250),
	[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefClientTypeAudit_ConcurrencyId] DEFAULT ((1)),
	[StampAction] [char] (1) NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefClientTypeAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (50) NULL
)
GO
ALTER TABLE [dbo].[TRefClientTypeAudit] ADD CONSTRAINT [PK_TRefClientTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
