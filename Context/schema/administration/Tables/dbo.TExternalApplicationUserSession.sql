CREATE TABLE [dbo].[TExternalApplicationUserSession]
(
[ExternalApplicationUserSessionId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[SessionId] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[LastAccessed] [datetime] NULL,
[IP] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[ExternalApplication] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExternalApplicationUserSession_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TExternalApplicationUserSession] ADD CONSTRAINT [PK_TExternalApplicationUserSession] PRIMARY KEY NONCLUSTERED  ([ExternalApplicationUserSessionId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TExternalApplicationUserSession_SessionId] ON [dbo].[TExternalApplicationUserSession] ([SessionId])
GO
CREATE NONCLUSTERED INDEX [IX_TExternalApplicationUserSession_TenantId_UserId] ON [dbo].[TExternalApplicationUserSession] ([TenantId], [UserId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_TExternalApplicationUserSession] ON [dbo].[TExternalApplicationUserSession] ([UserId], [TenantId], [ExternalApplication])
GO
