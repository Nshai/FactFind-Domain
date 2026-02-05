CREATE TABLE [dbo].[TUserHash]
(
[UserHashId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[HashValue] [char] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserHash_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TUserHash] ADD CONSTRAINT [PK_TUserHash] PRIMARY KEY CLUSTERED  ([UserHashId]) WITH (FILLFACTOR=80)
GO
