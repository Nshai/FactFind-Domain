CREATE TABLE [dbo].[TMembership]
(
[MembershipId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMembership_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMembership] ADD CONSTRAINT [PK_TMembership] PRIMARY KEY NONCLUSTERED  ([MembershipId])
GO
CREATE CLUSTERED INDEX [IDX1_TMembership_RoleId_UserId] ON [dbo].[TMembership] ([RoleId],[UserId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMembership_UserId_RoleId] ON [dbo].[TMembership] ([UserId], [RoleId])
GO
ALTER TABLE [dbo].[TMembership] WITH CHECK ADD CONSTRAINT [FK_TMembership_RoleId_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[TRole] ([RoleId])
GO
ALTER TABLE [dbo].[TMembership] WITH CHECK ADD CONSTRAINT [FK_TMembership_UserId_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
