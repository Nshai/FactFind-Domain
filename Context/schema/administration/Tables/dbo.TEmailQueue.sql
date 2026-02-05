CREATE TABLE [dbo].[TEmailQueue]
(
[EmailQueueId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[OwnerId] [int] NULL,
[QueueDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Subject] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[StatusId] [int] NULL,
[ToAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FromAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CcAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[BccAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Body] [text] COLLATE Latin1_General_CI_AS NULL,
[PreMergedFg] [bit] NOT NULL CONSTRAINT [DF_TEmailQueue_PreMergedFg] DEFAULT ((0)),
[Guid] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MergeData] [text] COLLATE Latin1_General_CI_AS NULL,
[AddedDate] [datetime] NOT NULL CONSTRAINT [DF_TEmailQueue_AddedDate] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailQueue_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEmailQueue] ADD CONSTRAINT [PK_TEmailQueue] PRIMARY KEY CLUSTERED  ([EmailQueueId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TEmailQueue_StatusIdASC] ON [dbo].[TEmailQueue] ([StatusId]) WITH (FILLFACTOR=80)
GO
