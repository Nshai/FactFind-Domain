CREATE TABLE [dbo].[TValQueueAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Guid] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[Status] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ValRequestId] [int] NULL,
[StartTime] [datetime] NOT NULL CONSTRAINT [DF_TValQueueAudit_StartTime] DEFAULT (getdate()),
[EndTime] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValQueueAudit_ConcurrencyId] DEFAULT ((1)),
[ValQueueId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValQueueAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValQueueAudit] ADD CONSTRAINT [PK_TValQueueAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
