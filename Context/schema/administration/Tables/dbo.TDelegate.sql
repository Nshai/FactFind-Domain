CREATE TABLE [dbo].[TDelegate]
(
[DelegateId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[DelegatedUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDelegate_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDelegate] ADD CONSTRAINT [PK_TDelegate] PRIMARY KEY NONCLUSTERED  ([DelegateId])
GO
CREATE NONCLUSTERED INDEX [IDX_TDelegate_DelegatedUserId] ON [dbo].[TDelegate] ([DelegatedUserId])
GO
CREATE CLUSTERED INDEX [IDX1_TDelegate_UserId] ON [dbo].[TDelegate] ([UserId])
GO
ALTER TABLE [dbo].[TDelegate] WITH CHECK ADD CONSTRAINT [FK_TDelegate_DelegatedUserId_UserId] FOREIGN KEY ([DelegatedUserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
ALTER TABLE [dbo].[TDelegate] WITH CHECK ADD CONSTRAINT [FK_TDelegate_UserId_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
