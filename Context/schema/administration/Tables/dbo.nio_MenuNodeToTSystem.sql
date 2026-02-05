CREATE TABLE [dbo].[nio_MenuNodeToTSystem]
(
[nio_MenuNodeToTSystemId] [int] NOT NULL IDENTITY(1, 1),
[nio_MenuNodeId] [int] NOT NULL,
[SystemId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_nio_MenuNodeToTSystem_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[nio_MenuNodeToTSystem] ADD CONSTRAINT [PK_nio_MenuNodeToTSystem] PRIMARY KEY NONCLUSTERED  ([nio_MenuNodeToTSystemId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_nio_MenuNodeToTSystem_nio_MenuNodeId_SystemId] ON [dbo].[nio_MenuNodeToTSystem] ([nio_MenuNodeId], [SystemId])
GO
