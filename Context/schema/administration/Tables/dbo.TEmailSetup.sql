CREATE TABLE [dbo].[TEmailSetup]
(
[EmailSetupId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[DisplayName] [varchar] (255)  NOT NULL,
[AutomaticBccFg] [bit] NOT NULL CONSTRAINT [DF_TEmailSetUp_IsAutomaticBcc] DEFAULT ((1)),
[Signatures] [text]  NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailSetUp_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEmailSetup] ADD CONSTRAINT [PK_TEmailSetUp] PRIMARY KEY CLUSTERED  ([EmailSetupId])
GO
CREATE NONCLUSTERED INDEX [IX_TEmailSetup_UserIdASC] ON [dbo].[TEmailSetup] ([UserId])
GO
ALTER TABLE [dbo].[TEmailSetup] WITH CHECK ADD CONSTRAINT [FK_TEmailSetUp_TUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
