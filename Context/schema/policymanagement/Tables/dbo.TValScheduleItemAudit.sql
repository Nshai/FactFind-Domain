CREATE TABLE [dbo].[TValScheduleItemAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ValScheduleId] [int] NOT NULL,
[ValQueueId] [int] NULL,
[NextOccurrence] [datetime] NULL,
[LastOccurrence] [datetime] NULL,
[ErrorMessage] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[RefValScheduleItemStatusId] [int] NULL,
[NotificationSentOn] [datetime] null,
[SaveAsFilePathAndName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValScheduleItemAudit_ConcurrencyId] DEFAULT ((1)),
[ValScheduleItemId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValScheduleItemAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[DocVersionId] [int] NULL
)
GO
ALTER TABLE [dbo].[TValScheduleItemAudit] ADD CONSTRAINT [PK_TValScheduleItemAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TValScheduleItemAudit_ValScheduleItemId_ConcurrencyId] ON [dbo].[TValScheduleItemAudit] ([ValScheduleItemId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
