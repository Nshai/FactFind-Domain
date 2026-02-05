CREATE TABLE [dbo].[TUserPasswordBackup]
(
[UserId] [int] NOT NULL ,
[Password] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[PasswordHistory] [varchar] (512) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TUserPasswordBackup] ADD CONSTRAINT [PK_TUserPasswordBackup] PRIMARY KEY CLUSTERED  ([UserId]) WITH (FILLFACTOR=90)
GO
