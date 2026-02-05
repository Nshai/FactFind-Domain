CREATE TABLE [dbo].[TServiceActionToTSystem]
(
[ServiceActionToTSystemId] [int] NOT NULL IDENTITY(1, 1),
[ServiceActionId] [int] NOT NULL,
[SystemId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TServiceActionToTSystem_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TServiceActionToTSystem] ADD CONSTRAINT [PK_TServiceActionToTSystem] PRIMARY KEY CLUSTERED  ([ServiceActionToTSystemId])
GO
CREATE NONCLUSTERED INDEX [IX_TServiceActionToTSystem_ServiceActionId] ON [dbo].[TServiceActionToTSystem] ([ServiceActionId])
GO
CREATE NONCLUSTERED INDEX [IX_TServiceActionToTSystem_SystemId] ON [dbo].[TServiceActionToTSystem] ([SystemId])
GO
ALTER TABLE [dbo].[TServiceActionToTSystem] ADD CONSTRAINT [FK_TServiceActionToTSystem_TServiceAction] FOREIGN KEY ([ServiceActionId]) REFERENCES [dbo].[TServiceAction] ([ServiceActionId])
GO
ALTER TABLE [dbo].[TServiceActionToTSystem] ADD CONSTRAINT [FK_TServiceActionToTSystem_TSystem] FOREIGN KEY ([SystemId]) REFERENCES [dbo].[TSystem] ([SystemId])
GO
