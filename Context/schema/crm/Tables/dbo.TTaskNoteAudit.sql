CREATE TABLE [dbo].[TTaskNoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[LastEdited] [datetime] NOT NULL,
[Notes] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[TaskId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[TaskNoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EditedBy] [int] NULL,
[IsAvailableToPfpClient] [bit] NULL CONSTRAINT [DF_TTaskNoteAudit_IsAvailableToPfpClient] DEFAULT ((0)),
MigrationRef varchar(255) null
)
GO
ALTER TABLE [dbo].[TTaskNoteAudit] ADD CONSTRAINT [PK_TTaskNoteAudit] PRIMARY KEY CLUSTERED  ([AuditId], [StampDateTime])
GO
ALTER TABLE [dbo].[TTaskNoteAudit] ADD  CONSTRAINT [DF_TTaskNoteAudit_StampDateTime]  DEFAULT (getdate()) FOR [StampDateTime]
GO
CREATE NONCLUSTERED INDEX [IDX_TTaskNoteAudit_TaskId] ON [dbo].[TTaskNoteAudit] ([TaskId])
GO
CREATE NONCLUSTERED INDEX IX_TTaskNoteAudit_TaskNoteId ON [dbo].[TTaskNoteAudit] ([TaskNoteId]) 
GO