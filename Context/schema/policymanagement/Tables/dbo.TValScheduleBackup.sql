CREATE TABLE [dbo].[TValScheduleBackup]
(
[ValScheduleId] [int] NOT NULL,
[PasswordForFileAccess] [varchar] (100) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValScheduleBackup] ADD CONSTRAINT [PK_TValScheduleBackup] PRIMARY KEY NONCLUSTERED  ([ValScheduleId]) WITH (FILLFACTOR=80)
GO

