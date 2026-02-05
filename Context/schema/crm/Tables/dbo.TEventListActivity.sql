CREATE TABLE [dbo].[TEventListActivity]
(
[EventListActivityId] [int] NOT NULL IDENTITY(1, 1),
[EventListId] [int] NOT NULL,
[EventListTemplateActivityId] [int] NOT NULL,
[FixedDate] [datetime] NULL,
[Duration] [int] NULL,
[ElapsedDays] [int] NULL,
[EditElapsedDaysFg] [bit] NOT NULL CONSTRAINT [DF_TEventListActivity_EditElapsedDaysFg] DEFAULT ((0)),
[AssignedUserId] [int] NULL,
[AssignedRoleId] [int] NULL,
[StartDate] [datetime] NULL,
[DeletedFg] [bit] NOT NULL,
[CompletedFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEventListActivity_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEventListActivity] ADD CONSTRAINT [PK_TEventListActivity_EventListActivityId] PRIMARY KEY NONCLUSTERED  ([EventListActivityId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IX_TEventListActivity_EventListId] ON [dbo].[TEventListActivity] ([EventListId])
GO
ALTER TABLE [dbo].[TEventListActivity] ADD CONSTRAINT [FK_TEventListActivity_TEventList] FOREIGN KEY ([EventListId]) REFERENCES [dbo].[TEventList] ([EventListId])
GO
ALTER TABLE [dbo].[TEventListActivity] ADD CONSTRAINT [FK_TEventListActivity_EventListTemplateActivityId_EventListTemplateActivityId] FOREIGN KEY ([EventListTemplateActivityId]) REFERENCES [dbo].[TEventListTemplateActivity] ([EventListTemplateActivityId])
GO
