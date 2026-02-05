CREATE TABLE [dbo].[TEventAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[IndUserId] [int] NOT NULL,
[RefSubjectId] [int] NULL,
[Subject] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Location] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PersonId] [int] NULL,
[ContactName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[Notes] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFG] [tinyint] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[CompleteFG] [tinyint] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[EventId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEventAudit] ADD CONSTRAINT [PK_TEventAudit_1__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TEventAudit_EventId_ConcurrencyId] ON [dbo].[TEventAudit] ([EventId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
