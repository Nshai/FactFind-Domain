CREATE TABLE [dbo].[TUserExtended]
(
[UserExtendedId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[MigrationRef] [varchar] (255) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserExtended_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TUserExtended] ADD CONSTRAINT [PK_TUserExtended] PRIMARY KEY NONCLUSTERED  ([UserExtendedId])
GO
CREATE UNIQUE CLUSTERED INDEX [CI_TUserExtended_UserId] ON [dbo].[TUserExtended] ([UserId])
GO