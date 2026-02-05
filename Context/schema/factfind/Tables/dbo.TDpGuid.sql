CREATE TABLE [dbo].[TDpGuid]
(
[DpGuidId] [int] NOT NULL IDENTITY(1, 1),
[EntityId] [int] NOT NULL,
[DpGuidTypeId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TDpGuid_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDpGuid_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDpGuid] ADD CONSTRAINT [PK_TDpGuid] PRIMARY KEY NONCLUSTERED  ([DpGuidId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TDpGuid_EntityId] ON [dbo].[TDpGuid] ([EntityId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TDpGuid_Guid] ON [dbo].[TDpGuid] ([Guid]) WITH (FILLFACTOR=80)
GO
