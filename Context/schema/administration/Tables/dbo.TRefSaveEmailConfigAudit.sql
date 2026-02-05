CREATE TABLE [dbo].[TRefSaveEmailConfigAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[SaveEmailConfigName] [varchar] (100) NOT NULL,
	[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefSaveEmailConfigAudit_ConcurrencyId] DEFAULT ((1)),
	[RefSaveEmailConfigId] [tinyint] NOT NULL,
	[StampAction] [char] (1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TRefSaveEmailConfigAudit] ADD CONSTRAINT [PK_TRefSaveEmailConfigAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
