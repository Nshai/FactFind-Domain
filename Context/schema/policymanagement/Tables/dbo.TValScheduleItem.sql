CREATE TABLE [dbo].[TValScheduleItem]
(
[ValScheduleItemId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ValScheduleId] [int] NOT NULL,
[ValQueueId] [int] NULL,
[NextOccurrence] [datetime] NULL,
[LastOccurrence] [datetime] NULL,
[ErrorMessage] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[RefValScheduleItemStatusId] [int] NULL,
[NotificationSentOn] [datetime] null,
[SaveAsFilePathAndName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValScheduleItem_ConcurrencyId] DEFAULT ((1)),
[DocVersionId] [int] NULL
)
GO
ALTER TABLE [dbo].[TValScheduleItem] ADD CONSTRAINT [PK_TValScheduleItem] PRIMARY KEY NONCLUSTERED  ([ValScheduleItemId])
GO
CREATE NONCLUSTERED INDEX [IX_TValScheduleItem_NextOccurrence] ON [dbo].[TValScheduleItem] ([NextOccurrence]) INCLUDE ([ValScheduleId], [ValScheduleItemId])
GO
CREATE NONCLUSTERED INDEX [IX_TValScheduleItem_RefValScheduleItemStatusId] ON [dbo].[TValScheduleItem] ([RefValScheduleItemStatusId])
GO
CREATE NONCLUSTERED INDEX [IDX_TValScheduleItem_ValScheduleId_NextOccurrence] ON [dbo].[TValScheduleItem] ([ValScheduleId], [NextOccurrence])
GO
