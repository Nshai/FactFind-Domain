CREATE TABLE [dbo].[TCofundsPlatformMigrationLog]
(
[CofundsPlatformMigrationLogId]  [int] IDENTITY(1,1) NOT NULL,
[TenantId] [int] NOT NULL,
[GroupId] [int] NOT NULL,
[ValScheduleId] [int] NOT NULL,
[MigrationAttemptedAt] [datetime2] NULL,
[Status] [varchar] (100) NOT NULL,
[DownloadPath] [varchar] (2000) NULL,
[MigrationResult] [varchar] (MAX) NULL,
[ErrorMessage] [varchar] (MAX) NULL,
[CreatedDate] [datetime2] NOT NULL
)
GO

ALTER TABLE [dbo].[TCofundsPlatformMigrationLog] ADD CONSTRAINT [PK_TCofundsPlatformMigrationLog] PRIMARY KEY CLUSTERED  ([CofundsPlatformMigrationLogId])
GO

ALTER TABLE [dbo].[TCofundsPlatformMigrationLog] ADD CONSTRAINT [DF_TCofundsPlatformMigrationLog_CreatedDate] DEFAULT GETDATE() FOR  [CreatedDate] 
GO