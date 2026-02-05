CREATE TABLE [dbo].[TPractitionerKey]
(
[PractitionerKeyId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EntityId] [int] NULL,
[CreatorId] [int] NULL,
[UserId] [int] NULL,
[RoleId] [int] NULL,
[RightMask] [int] NOT NULL CONSTRAINT [DF_TPractitionerKey_RightMask] DEFAULT ((0)),
[AdvancedMask] [int] NOT NULL CONSTRAINT [DF_TPractitionerKey_AdvancedMask] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPractitionerKey_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPractitionerKey] ADD CONSTRAINT [PK_TPractitionerKey] PRIMARY KEY NONCLUSTERED  ([PractitionerKeyId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPractitionerKey_CreatorId] ON [dbo].[TPractitionerKey] ([CreatorId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPractitionerKey_EntityId] ON [dbo].[TPractitionerKey] ([EntityId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPractitionerKey_RoleId] ON [dbo].[TPractitionerKey] ([RoleId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPractitionerKey_UserId] ON [dbo].[TPractitionerKey] ([UserId]) INCLUDE ([CreatorId]) WITH (FILLFACTOR=80)
GO
