CREATE TABLE [dbo].[TEventListTemplateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[AllowAddTaskFg] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ClientRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplateAudit_ClientRelatedFg] DEFAULT ((0)),
[PlanRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplateAudit_PlanRelatedFg] DEFAULT ((0)),
[LeadRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplateAudit_LeadRelatedFg] DEFAULT ((0)),
[AdviserRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplateAudit_AdviserRelatedFg] DEFAULT ((0)),
[SchemeRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplateAudit_SchemeRelatedFg] DEFAULT ((0)),
[ServiceCaseRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TEventListTemplateAudit_ServiceCaseRelatedFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL,
[EventListTemplateId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NULL,
[GroupId] [int] NULL,
[IsPropagated][bit] NOT NULL CONSTRAINT [DF_TEventListTemplateAudit_IsPropagated] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEventListTemplateAudit] ADD CONSTRAINT [PK_TEventListTemplateAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
