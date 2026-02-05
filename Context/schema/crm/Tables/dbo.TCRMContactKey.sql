CREATE TABLE [dbo].[TCRMContactKey]
(
[CRMContactKeyId] [bigint] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EntityId] [int] NULL,
[CreatorId] [int] NULL,
[UserId] [int] NULL,
[RoleId] [int] NULL,
[RightMask] [int] NOT NULL CONSTRAINT [DF_TCRMContactKey_RightMask] DEFAULT ((0)),
[AdvancedMask] [int] NOT NULL CONSTRAINT [DF_TCRMContactKey_AdvancedMask] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCRMContactKey_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCRMContactKey] ADD CONSTRAINT [PK_TCRMContactKey] PRIMARY KEY NONCLUSTERED  ([CRMContactKeyId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContactKey_CreatorId] ON [dbo].[TCRMContactKey] ([CreatorId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TCRMContactKey_Test] ON [dbo].[TCRMContactKey] ([CreatorId], [EntityId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContactKey_EntityId] ON [dbo].[TCRMContactKey] ([EntityId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TCRMContactKey_EntityId_UserId_CreatorId_RightMask_AdvancedMask_RoleId] ON [dbo].[TCRMContactKey] ([EntityId], [UserId], [CreatorId], [RightMask], [AdvancedMask], [RoleId])
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContactKey_RoleId] ON [dbo].[TCRMContactKey] ([RoleId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContactKey_UserId] ON [dbo].[TCRMContactKey] ([UserId]) WITH (FILLFACTOR=80)
GO
