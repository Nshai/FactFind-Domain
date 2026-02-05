CREATE TABLE [dbo].[TExWebAccount]
(
[ExWebAccountId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[ExWebUserId] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ExWebPassword] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExWebAccount_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TExWebAccount] ADD CONSTRAINT [PK_TExWebAccount] PRIMARY KEY CLUSTERED  ([ExWebAccountId]) WITH (FILLFACTOR=80)
GO
