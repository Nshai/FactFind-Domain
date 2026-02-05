CREATE TABLE [dbo].[TEventListTemplateActivity]
(
[EventListTemplateActivityId] [int] NOT NULL IDENTITY(1, 1),
[EventListTemplateId] [int] NOT NULL,
[ActivityCategoryId] [int] NOT NULL,
[FixedDateFg] [bit] NOT NULL,
[DeletableFg] [bit] NOT NULL,
[Duration] [int] NULL,
[ElapsedDays] [int] NULL,
[EditElapsedDaysFg] [bit] NOT NULL,
[AssignedUserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[IsRecurring] [bit] NULL CONSTRAINT [DF_TEventListTemplateActivity_IsRecurring] DEFAULT ((0)),
[RFCCode] [varchar] (1000)  NULL
)
GO
ALTER TABLE [dbo].[TEventListTemplateActivity] ADD CONSTRAINT [PK_TEventListTemplateActivity] PRIMARY KEY CLUSTERED  ([EventListTemplateActivityId])
GO
ALTER TABLE [dbo].[TEventListTemplateActivity] WITH CHECK ADD CONSTRAINT [FK_TEventListTemplateActivity_TActivityCategory] FOREIGN KEY ([ActivityCategoryId]) REFERENCES [dbo].[TActivityCategory] ([ActivityCategoryId])
GO
ALTER TABLE [dbo].[TEventListTemplateActivity] ADD CONSTRAINT [FK_TEventListTemplateActivity_TTEventListTemplate] FOREIGN KEY ([EventListTemplateId]) REFERENCES [dbo].[TEventListTemplate] ([EventListTemplateId]) ON DELETE CASCADE
GO
