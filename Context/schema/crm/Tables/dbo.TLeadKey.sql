CREATE TABLE [dbo].[TLeadKey]
(
[LeadKeyId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EntityId] [int] NULL,
[CreatorId] [int] NULL,
[UserId] [int] NULL,
[RoleId] [int] NULL,
[RightMask] [int] NOT NULL CONSTRAINT [DF_TLeadKey_RightMask] DEFAULT ((0)),
[AdvancedMask] [int] NOT NULL CONSTRAINT [DF_TLeadKey_AdvancedMask] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadKey_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLeadKey] ADD CONSTRAINT [PK_TLeadKey] PRIMARY KEY NONCLUSTERED  ([LeadKeyId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TLeadKey_UserId] ON [dbo].[TLeadKey] ([UserId])
GO
CREATE NONCLUSTERED INDEX [IX_TLeadKey_EntityId_CreatorId_UserId] ON [dbo].[TLeadKey] ([EntityId], [CreatorId], [UserId])
GO
CREATE NONCLUSTERED INDEX [IX_TLeadKey_EntityId_RoleId] ON [dbo].[TLeadKey] ([EntityId], [RoleId]) INCLUDE ([AdvancedMask], [RightMask])
GO
CREATE NONCLUSTERED INDEX [IX_TLeadKey_EntityId_RoleId_UserId] ON [dbo].[TLeadKey] ([EntityId], [RoleId], [UserId]) INCLUDE ([AdvancedMask], [RightMask])
GO
