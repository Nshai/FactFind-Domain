CREATE TABLE [dbo].[TResources]
(
[ResourcesId] [int] NOT NULL IDENTITY(1, 1),
[AppointmentId] [int] NOT NULL,
[ResourceListId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TResources_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TResources] ADD CONSTRAINT [PK_TResources_ResourcesId] PRIMARY KEY NONCLUSTERED  ([ResourcesId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TResources_AppointmentIdASC] ON [dbo].[TResources] ([AppointmentId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TResources_ResourceListIdASC] ON [dbo].[TResources] ([ResourceListId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TResources] ADD CONSTRAINT [FK_TResources_AppointmentId_AppointmentId] FOREIGN KEY ([AppointmentId]) REFERENCES [dbo].[TAppointment] ([AppointmentId])
GO
ALTER TABLE [dbo].[TResources] ADD CONSTRAINT [FK_TResources_TResourceList] FOREIGN KEY ([ResourceListId]) REFERENCES [dbo].[TResourceList] ([ResourceListId])
GO
