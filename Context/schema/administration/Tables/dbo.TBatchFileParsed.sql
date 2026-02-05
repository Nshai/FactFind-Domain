CREATE TABLE [dbo].[TBatchFileParsed]
(
[BatchFileParsedId] [int] NOT NULL IDENTITY(1, 1),
[FileName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsSuccess] [bit] NOT NULL,
[StatusDescription] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[BatchFileProcessId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TBatchFileParsed_ConcurrencyId] DEFAULT ((1)),
[DateProcessed] [datetime] NOT NULL CONSTRAINT [DF_TBatchFileParsed_DateProcessed] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[TBatchFileParsed] ADD CONSTRAINT [PK_TBatchFileParsed] PRIMARY KEY CLUSTERED  ([BatchFileParsedId])
GO
