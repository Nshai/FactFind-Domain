CREATE TABLE [dbo].[TUserCalendarConfig]
(
[UserCalendarConfigId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[DateTime] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TUserCalendarConfig] ADD CONSTRAINT [PK_TUserCalendarConfig] PRIMARY KEY CLUSTERED  ([UserCalendarConfigId])
GO
