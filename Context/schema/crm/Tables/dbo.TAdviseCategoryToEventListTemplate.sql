CREATE TABLE [dbo].[TAdviseCategoryToEventListTemplate]
(
[AdviseCategoryToEventListTemplateId] [int] NOT NULL IDENTITY(1, 1),
[AdviseCategoryId] [int] NOT NULL,
[EventListTemplateId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviseCategoryToEventList_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviseCategoryToEventListTemplate] ADD CONSTRAINT [PK_TAdviseCategoryToEventList] PRIMARY KEY CLUSTERED  ([AdviseCategoryToEventListTemplateId])
GO
