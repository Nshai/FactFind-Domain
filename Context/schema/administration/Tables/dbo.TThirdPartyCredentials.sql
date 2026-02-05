CREATE TABLE [dbo].[TThirdPartyCredentials]
(
[ThirdPartyCredentialsId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UserId] [int] NULL,
[ThirdPartyId] [int] NULL,
[UserDescription] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[UserName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Password] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Password2] [varbinary] (4000) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TThirdPartyCredentials_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TThirdPartyCredentials] ADD CONSTRAINT [PK_TThirdPartyCredentials] PRIMARY KEY NONCLUSTERED  ([ThirdPartyCredentialsId])
GO
