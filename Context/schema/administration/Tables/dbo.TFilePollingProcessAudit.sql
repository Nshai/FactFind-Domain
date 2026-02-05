CREATE TABLE [dbo].[TFilePollingProcessAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[WatchingFolder] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[IsEnabled] [bit] NOT NULL,
[PollingInterval] [int] NOT NULL,
[HasLimitInterval] [bit] NOT NULL,
[IntervalFrom] [int] NOT NULL,
[IntervalTo] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FilePollingProcessId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[NotificationEmails] [varchar] (500) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFilePollingProcessAudit] ADD CONSTRAINT [PK_TFilePollingProcessAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
