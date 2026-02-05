CREATE TABLE [dbo].[TPolicy]
(
[PolicyId] [int] NOT NULL IDENTITY(1, 1),
[EntityId] [int] NOT NULL,
[RightMask] [int] NOT NULL CONSTRAINT [DF_TPolicy_RightMask] DEFAULT ((0)),
[AdvancedMask] [int] NOT NULL CONSTRAINT [DF_TPolicy_AdvancedMask] DEFAULT ((0)),
[RoleId] [int] NOT NULL,
[Propogate] [bit] NOT NULL CONSTRAINT [DF_TPolicy_Propogate] DEFAULT ((1)),
[Applied] [varchar] (16) NOT NULL CONSTRAINT [DF_TPolicy_Applied] DEFAULT ('no'),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicy_ConcurrencyId] DEFAULT ((1)),
[Inherit] [bit] NOT NULL CONSTRAINT [DF_TPolicy_Inherit] DEFAULT ((0)),
[UserId] INT NULL,
[GroupId] INT NULL
)
GO
ALTER TABLE [dbo].[TPolicy] ADD CONSTRAINT [PK_TPolicy] PRIMARY KEY NONCLUSTERED  ([PolicyId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicy_EntityId] ON [dbo].[TPolicy] ([EntityId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicy_RoleId] ON [dbo].[TPolicy] ([RoleId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicy_IndigoClientId_EntityId_RoleId] ON [dbo].[TPolicy] ([IndigoClientId], [EntityId], [RoleId]) INCLUDE (RightMask, Propogate) 
Go
ALTER TABLE [dbo].[TPolicy] ADD CONSTRAINT [FK_TPolicy_EntityId_EntityId] FOREIGN KEY ([EntityId]) REFERENCES [dbo].[TEntity] ([EntityId])
GO
ALTER TABLE [dbo].[TPolicy] WITH CHECK ADD CONSTRAINT [FK_TPolicy_RoleId_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[TRole] ([RoleId])
GO
