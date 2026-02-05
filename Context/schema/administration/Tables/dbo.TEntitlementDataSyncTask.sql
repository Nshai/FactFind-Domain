CREATE TABLE [dbo].[TEntitlementDataSyncTask]
(
[EntitlementDataSyncTaskId] [int] NOT NULL IDENTITY(1, 1),
[SourceTable] [varchar] (128) NOT NULL,
[LastAuditId] [int] NOT NULL,
[Status] [int] NOT NULL,
[LastUpdatedAt] [datetime] NOT NULL CONSTRAINT [DF_TEntitlementDataSyncTask_LastUpdatedAt] DEFAULT (GETUTCDATE())
)
GO
ALTER TABLE [dbo].[TEntitlementDataSyncTask] ADD CONSTRAINT [PK_TEntitlementDataSyncTask] PRIMARY KEY CLUSTERED ([EntitlementDataSyncTaskId])
GO
