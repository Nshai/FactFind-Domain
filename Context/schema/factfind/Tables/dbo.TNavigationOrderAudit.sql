CREATE TABLE [dbo].[TNavigationOrderAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NavigationOrderId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[RefNavigationItemId] [int] NOT NULL,
[OrderNumber] [tinyint] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TNavigationOrderAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TNavigationOrderAudit] ADD CONSTRAINT [PK_TNavigationOrderAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
