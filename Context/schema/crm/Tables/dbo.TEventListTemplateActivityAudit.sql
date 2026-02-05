CREATE TABLE [dbo].[TEventListTemplateActivityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EventListTemplateId] [int] NOT NULL,
[ActivityCategoryId] [int] NOT NULL,
[FixedDateFg] [bit] NOT NULL,
[DeletableFg] [bit] NOT NULL,
[Duration] [int] NULL,
[ElapsedDays] [int] NULL,
[EditElapsedDaysFg] [bit] NOT NULL,
[AssignedUserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[EventListTemplateActivityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsRecurring] [bit] NULL,
[RFCCode] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEventListTemplateActivityAudit] ADD CONSTRAINT [PK_TEventListTemplateActivityAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
