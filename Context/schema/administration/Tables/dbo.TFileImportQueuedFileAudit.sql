
CREATE TABLE [dbo].[TFileImportQueuedFileAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[EntryDate] [datetime] NOT NULL,
[DeferUntil] [datetime] NOT NULL,
[SerializedJobData] [nvarchar](max)  NOT NULL,
[FileImportHeaderId] [uniqueidentifier] NOT NULL,
[NumberOfRecords] [int] NOT NULL,
[EstimatedStartDate] [datetime] NOT NULL,
[FileImportQueuedFileId] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFileImportQueuedFileAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFileImportQueuedFileAudit] ADD CONSTRAINT [PK_TFileImportQueuedFileAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO



