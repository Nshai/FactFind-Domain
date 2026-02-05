CREATE TABLE [dbo].[TRefNavigationItemAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefNavigationItemId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[Name] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[XmlId] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefNavigationItemAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefNavigationItemAudit] ADD CONSTRAINT [PK_TRefNavigationItemAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
