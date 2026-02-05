CREATE TABLE [dbo].[TAccountKey]
(
[AccountKeyId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EntityId] [int] NULL,
[CreatorId] [int] NULL,
[UserId] [int] NULL,
[RoleId] [int] NULL,
[RightMask] [int] NOT NULL CONSTRAINT [DF_TAccountKey_RightMask] DEFAULT ((0)),
[AdvancedMask] [int] NOT NULL CONSTRAINT [DF_TAccountKey_AdvancedMask] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAccountKey_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAccountKey] ADD CONSTRAINT [PK_TAccountKey] PRIMARY KEY NONCLUSTERED  ([AccountKeyId]) WITH (FILLFACTOR=80)
GO
