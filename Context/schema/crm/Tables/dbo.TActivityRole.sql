CREATE TABLE [dbo].[TActivityRole]
(
[ActivityRoleId] [int] NOT NULL IDENTITY(1, 1),
[EventListTemplateActivityId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TActivityRole] ADD CONSTRAINT [PK_TActivityRole] PRIMARY KEY CLUSTERED  ([ActivityRoleId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TActivityRole] ADD CONSTRAINT [FK_TActivityRole_EventListTemplateActivityId_EventListTemplateActivityId] FOREIGN KEY ([EventListTemplateActivityId]) REFERENCES [dbo].[TEventListTemplateActivity] ([EventListTemplateActivityId])
GO
