CREATE TABLE [dbo].[TEventListTemplate]
(
[EventListTemplateId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[AllowAddTaskFg] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ClientRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplate_ClientRelatedFg] DEFAULT ((0)),
[PlanRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplate_PlanRelatedFg] DEFAULT ((0)),
[LeadRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplate_LeadRelatedFg] DEFAULT ((0)),
[AdviserRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplate_AdviserRelatedFg] DEFAULT ((0)),
[SchemeRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplate_SchemeRelatedFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF__TEventLis__IsArc__6D58E265] DEFAULT ((0)),
[GroupId] [int] NULL,
[ServiceCaseRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplate_ServiceCaseRelatedFg] DEFAULT ((0)),
[IsPropagated][bit] NOT NULL CONSTRAINT [DF_TEventListTemplate_IsPropagated] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEventListTemplate] ADD CONSTRAINT [PK_TEventListTemplate] PRIMARY KEY CLUSTERED  ([EventListTemplateId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TEventListTemplate_GroupId] ON [dbo].[TEventListTemplate] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TEventListTemplate_IndigoClientId] ON [dbo].[TEventListTemplate] ([IndigoClientId])
GO
