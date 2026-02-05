CREATE TABLE [dbo].[TAcrFile]
(
[AcrFileId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TenantId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[FileName] [nvarchar] (400) COLLATE Latin1_General_CI_AS NOT NULL,
[StartTime] [datetime] NOT NULL,
[EndTime] [datetime] NULL,
[ResultFileName] [nvarchar] (400) COLLATE Latin1_General_CI_AS NULL,
[Exception] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAcrFile] ADD CONSTRAINT [PK_TAcrFile] PRIMARY KEY CLUSTERED  ([AcrFileId])
GO
CREATE NONCLUSTERED INDEX [IX_TAcrFile_FileName] ON [dbo].[TAcrFile] ([FileName])
GO
CREATE NONCLUSTERED INDEX [IX_TAcrFile_TenantId] ON [dbo].[TAcrFile] ([TenantId])
GO
