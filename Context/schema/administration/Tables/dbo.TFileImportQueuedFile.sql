
CREATE TABLE [dbo].[TFileImportQueuedFile]
(
[FileImportQueuedFileId] [uniqueidentifier] NOT NULL,
[TenantId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[EntryDate] [datetime] NOT NULL,
[DeferUntil] [datetime] NOT NULL,
[SerializedJobData] [nvarchar](max) NOT NULL,
[FileImportHeaderId] [uniqueidentifier] NOT NULL,
[NumberOfRecords] [int] NOT NULL,
[EstimatedStartDate] [datetime] NOT NULL
)
GO
ALTER TABLE [dbo].[TFileImportQueuedFile] ADD CONSTRAINT [PK_TFileImportQueuedFile] PRIMARY KEY NONCLUSTERED  ([FileImportQueuedFileId]) WITH (FILLFACTOR=80)
GO



