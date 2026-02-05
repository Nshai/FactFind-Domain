CREATE TABLE [dbo].[TEventListTemplateHidden]
(
[EventListTemplateHiddenId] [int] NOT NULL IDENTITY(1, 1),
[EventListTemplateId] [int] NOT NULL,
[GroupId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TEventListTemplateHidden] ADD CONSTRAINT [PK_TEventListTemplateHidden] PRIMARY KEY CLUSTERED  ([EventListTemplateHiddenId])
GO
CREATE NONCLUSTERED INDEX [IX_TEventListTemplateHidden_GroupId] ON [dbo].[TEventListTemplateHidden] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TEventListTemplateHidden_TenantId] ON [dbo].[TEventListTemplateHidden] ([TenantId])
GO
ALTER TABLE [dbo].[TEventListTemplateHidden] ADD CONSTRAINT [FK_TEventListTemplateHidden_TEventListTemplate] FOREIGN KEY ([EventListTemplateId]) REFERENCES [dbo].[TEventListTemplate] ([EventListTemplateId]) ON DELETE CASCADE
GO
