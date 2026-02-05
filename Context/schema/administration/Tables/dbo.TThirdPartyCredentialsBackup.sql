CREATE TABLE [dbo].[TThirdPartyCredentialsBackup]
(
[ThirdPartyCredentialsId] [int] NOT NULL,
[Password] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
)
GO
ALTER TABLE [dbo].[TThirdPartyCredentialsBackup] ADD CONSTRAINT [PK_TThirdPartyCredentialsBackup] PRIMARY KEY NONCLUSTERED  ([ThirdPartyCredentialsId])
GO
