CREATE TABLE [dbo].[TValPortalSetupBackup]
(
[ValPortalSetupId] [int] NOT NULL,
[Password] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
)
GO
ALTER TABLE [dbo].[TValPortalSetupBackup] ADD CONSTRAINT [PK_TValPortalSetupBackup] PRIMARY KEY CLUSTERED  ([ValPortalSetupId]) WITH (FILLFACTOR=80)
GO