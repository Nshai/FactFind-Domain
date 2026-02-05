CREATE TABLE [dbo].[TSecureMessageUser]
(
[SecureMessageUserId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NULL,
[Name] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSecureMessageUser_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TSecureMessageUser] ADD CONSTRAINT [PK_TSecureMessageUser] PRIMARY KEY CLUSTERED  ([SecureMessageUserId])
GO
CREATE NONCLUSTERED INDEX [IX_TSecureMessageUser_Name] ON [dbo].[TSecureMessageUser] ([Name])
GO
CREATE NONCLUSTERED INDEX [IX_TSecureMessageUser_UserId] ON [dbo].[TSecureMessageUser] ([UserId])
GO
