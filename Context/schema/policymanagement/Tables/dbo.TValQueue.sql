CREATE TABLE [dbo].[TValQueue]
(
[ValQueueId] [int] NOT NULL IDENTITY(1, 1),
[Guid] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[Status] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ValRequestId] [int] NULL,
[StartTime] [datetime] NOT NULL CONSTRAINT [DF_TValQueue_StartTime] DEFAULT (getdate()),
[EndTime] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValQueueg_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValQueue] ADD CONSTRAINT [PK_TValQueue] PRIMARY KEY CLUSTERED  ([ValQueueId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TValQueue_PolicyBusinessId_StartTime] ON [dbo].[TValQueue] ([PolicyBusinessId], [StartTime]) WITH (FILLFACTOR=80)
GO
