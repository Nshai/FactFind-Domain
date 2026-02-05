CREATE TABLE [dbo].[TEventListTemplateOld]
(
[EventListTemplateId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[AllowAddTaskFg] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ClientRelatedFg] [bit] NOT NULL,
[PlanRelatedFg] [bit] NOT NULL,
[LeadRelatedFg] [bit] NOT NULL,
[AdviserRelatedFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TEventListTemplateOld] ADD CONSTRAINT [PK_TEventListTemplateOld] PRIMARY KEY CLUSTERED  ([EventListTemplateId]) WITH (FILLFACTOR=80)
GO
