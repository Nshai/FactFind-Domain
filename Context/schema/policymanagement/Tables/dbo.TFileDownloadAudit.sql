CREATE TABLE [dbo].[TFileDownloadAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[Status] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Url] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[FileType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[StatusTime] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFileDownloadAudit_ConcurrencyId] DEFAULT ((1)),
[FileDownloadId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFileDownloadAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFileDownloadAudit] ADD CONSTRAINT [PK_TFileDownloadAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TFileDownloadAudit_FileDownloadId_ConcurrencyId] ON [dbo].[TFileDownloadAudit] ([FileDownloadId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
