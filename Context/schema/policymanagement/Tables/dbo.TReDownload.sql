CREATE TABLE [dbo].[TReDownload]
(
[ReDownloadId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[QuoteId] [int] NOT NULL,
[QuoteItemId] [int] NULL,
[Url] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DocumentId] [int] NULL,
[XmlSentId] [int] NULL,
[FileDownloadId] [int] NULL,
[CRMContactId] [int] NULL,
[CreatedOn] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TReDownload] ADD CONSTRAINT [PK_TReDownload] PRIMARY KEY CLUSTERED  ([ReDownloadId])
GO
