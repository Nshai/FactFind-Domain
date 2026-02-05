CREATE TABLE [dbo].[TControllerActionToTSystem]
(
[ControllerActionToTSystemId] [int] NOT NULL IDENTITY(1, 1),
[ControllerActionId] [int] NOT NULL,
[SystemId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TControllerActionToTSystem_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TControllerActionToTSystem] ADD CONSTRAINT [PK_TControllerActionToTSystem] PRIMARY KEY CLUSTERED  ([ControllerActionToTSystemId])
GO
CREATE NONCLUSTERED INDEX [IX_TControllerActionToTSystem_ControllerActionId] ON [dbo].[TControllerActionToTSystem] ([ControllerActionId])
GO
CREATE NONCLUSTERED INDEX [IX_TControllerActionToTSystem_SystemId] ON [dbo].[TControllerActionToTSystem] ([SystemId])
GO
ALTER TABLE [dbo].[TControllerActionToTSystem] ADD CONSTRAINT [FK_TControllerActionToTSystem_TControllerAction] FOREIGN KEY ([ControllerActionId]) REFERENCES [dbo].[TControllerAction] ([ControllerActionId])
GO
ALTER TABLE [dbo].[TControllerActionToTSystem] ADD CONSTRAINT [FK_TControllerActionToTSystem_TSystem] FOREIGN KEY ([SystemId]) REFERENCES [dbo].[TSystem] ([SystemId])
GO
