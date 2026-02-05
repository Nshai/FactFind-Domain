CREATE TABLE [dbo].[TFileDownload]
(
[FileDownloadId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[Status] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Url] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[FileType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[StatusTime] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFileDownload_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFileDownload] ADD CONSTRAINT [PK_TFileDownload] PRIMARY KEY NONCLUSTERED  ([FileDownloadId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TFileDownLoad] ON [dbo].[TFileDownload] ([QuoteId]) WITH (FILLFACTOR=80)
GO
