CREATE TABLE [dbo].[TEventListActivityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EventListId] [int] NOT NULL,
[EventListTemplateActivityId] [int] NOT NULL,
[FixedDate] [datetime] NULL,
[Duration] [int] NULL,
[ElapsedDays] [int] NULL,
[EditElapsedDaysFg] [bit] NOT NULL CONSTRAINT [DF_TEventListActivityAudit_EditElapsedDaysFg] DEFAULT ((0)),
[AssignedUserId] [int] NULL,
[AssignedRoleId] [int] NULL,
[StartDate] [datetime] NULL,
[DeletedFg] [bit] NOT NULL,
[CompletedFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[EventListActivityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEventListActivityAudit] ADD CONSTRAINT [PK_TEventListActivityAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=75)
GO
