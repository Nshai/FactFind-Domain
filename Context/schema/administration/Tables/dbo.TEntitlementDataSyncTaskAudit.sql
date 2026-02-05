CREATE TABLE [dbo].[TEntitlementDataSyncTaskAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EntitlementDataSyncTaskId] [int] NOT NULL,
[SourceTable] [varchar] (128) NOT NULL,
[LastAuditId] [int] NOT NULL,
[Status] [int] NOT NULL,
[LastUpdatedAt] [datetime] NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEntitlementDataSyncTaskAudit_StampDateTime] DEFAULT (GETUTCDATE()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TEntitlementDataSyncTaskAudit] ADD CONSTRAINT [PK_TEntitlementDataSyncTaskAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO
