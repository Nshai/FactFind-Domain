CREATE TABLE [dbo].[TUserPreference]
(
[UserPreferenceId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[PreferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PreferenceValue] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserPreference_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TUserPreference] ADD CONSTRAINT [PK_TUserPreference] PRIMARY KEY NONCLUSTERED  ([UserPreferenceId])
GO
