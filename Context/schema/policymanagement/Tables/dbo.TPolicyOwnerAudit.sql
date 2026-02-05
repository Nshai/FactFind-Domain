CREATE TABLE [dbo].[TPolicyOwnerAudit]
(
	 [AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION
	,[PolicyOwnerId] [int] NOT NULL
	,[CRMContactId] [int] NOT NULL
	,[PolicyDetailId] [int] NOT NULL
	,[OwnerOrder] [smallint] NULL
	,[PlanMigrationRef] [varchar](255) NULL
	,[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyOwnerAudit_ConcurrencyId] DEFAULT ((1))
	,[StampAction] [char] (1) NOT NULL
	,[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyOwnerAudit_StampDateTime] DEFAULT (getdate())
	,[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TPolicyOwnerAudit] ADD CONSTRAINT [PK_TPolicyOwnerAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) 
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyOwnerAudit_PolicyOwnerId_ConcurrencyId] ON [dbo].[TPolicyOwnerAudit] ([PolicyOwnerId], [ConcurrencyId])
GO
