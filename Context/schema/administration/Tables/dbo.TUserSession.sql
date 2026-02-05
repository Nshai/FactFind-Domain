CREATE TABLE [dbo].[TUserSession]
(
[UserSessionId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[SessionId] [varchar] (128)  NULL,
[DelegateId] [int] NULL,
[DelegateSessionId] [varchar] (128)  NULL,
[Sequence] [int] NOT NULL CONSTRAINT [DF_TUserSession_Sequence] DEFAULT ((0)),
[IP] [varchar] (16)  NULL,
[LastAccess] [datetime] NULL,
[Search] [text]  NULL,
[Recent] [text]  NULL,
[RecentWork] [text]  NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserSession_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TUserSession] ADD CONSTRAINT [PK_TUserSession_UserSessionId] PRIMARY KEY CLUSTERED  ([UserSessionId])
GO
CREATE NONCLUSTERED INDEX [IX_TUserSession_DelegateId] ON [dbo].[TUserSession] ([DelegateId])
GO
CREATE NONCLUSTERED INDEX [IX_TUserSession_DelegateSessionId] ON [dbo].[TUserSession] ([DelegateSessionId])
GO
CREATE NONCLUSTERED INDEX [IX_TUserSession_SessionId] ON [dbo].[TUserSession] ([SessionId])
GO
CREATE NONCLUSTERED INDEX [IX_TUserSession_UserId] ON [dbo].[TUserSession] ([UserId])
GO
ALTER TABLE [dbo].[TUserSession] WITH CHECK ADD CONSTRAINT [FK_TUserSession_TUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
