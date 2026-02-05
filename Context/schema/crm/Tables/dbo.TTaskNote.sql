

CREATE TABLE [dbo].[TTaskNote]
(
[TaskNoteId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[LastEdited] [datetime] NOT NULL,
[Notes] [varchar] (max) NOT NULL,
[TaskId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTaskNote_ConcurrencyId] DEFAULT ((1)),
[EditedBy] [int] NULL,
[IsAvailableToPfpClient] [bit] NOT NULL CONSTRAINT [DF_TTaskNote_IsAvailableToPfpClient] DEFAULT ((0)),
[MigrationRef] [varchar] (255) NULL
)
-- ON ps_TTaskNote_TaskID(TaskId)

GO
ALTER TABLE [dbo].[TTaskNote] ADD CONSTRAINT [PK_TTaskNote] PRIMARY KEY CLUSTERED  ([TaskNoteId], [TaskId])
GO

CREATE NONCLUSTERED INDEX IX_TTaskNote_TaskId ON [dbo].[TTaskNote]
(	[TaskId]  )
-- ON ps_TTaskNote_TaskID(TaskId)
GO